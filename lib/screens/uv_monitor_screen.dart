import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_models.dart';
import '../data/mock_data.dart';
import '../services/ble_service.dart';
import '../providers/skin_type_provider.dart';


// UV Monitor Screen
class UVMonitorScreen extends StatefulWidget {
  const UVMonitorScreen({super.key});

  @override
  State<UVMonitorScreen> createState() => _UVMonitorScreenState();
}

class _UVMonitorScreenState extends State<UVMonitorScreen> {
  double currentUV = 0.0;
  double uvAlertThreshold = 6.0;
  
  List<UVReading> uvReadings = [];

  @override
  void initState() {
    super.initState();
    // Try to reconnect to last device after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBle();
    });
  }

  Future<void> _initializeBle() async {
    try {
      await context.read<BleService>().reconnectToLastDevice();
    } catch (e) {
      print('Error reconnecting: $e');
    }
  }

  void _addUVReading(double uvValue) {
    final reading = UVReading(
      id: 'reading_${DateTime.now().millisecondsSinceEpoch}',
      uvIndex: uvValue,
      timestamp: DateTime.now(),
    );
    setState(() {
      uvReadings.insert(0, reading);
      // Keep only last 50 readings
      if (uvReadings.length > 50) {
        uvReadings = uvReadings.sublist(0, 50);
      }
    });
  }

  UVLevel _getUVLevel(double uvIndex) {
    if (uvIndex <= 2) return UVLevel('Low', Colors.green);
    if (uvIndex <= 5) return UVLevel('Moderate', Colors.yellow);
    if (uvIndex <= 7) return UVLevel('High', Colors.orange);
    if (uvIndex <= 10) return UVLevel('Very High', Colors.red);
    return UVLevel('Extreme', Colors.purple);
  }

  UVRecommendation _getRecommendations(SkinType selectedSkinType) {
    final recommendation = uvRecommendations.firstWhere(
      (r) => currentUV >= r.uvIndex,
      orElse: () => uvRecommendations.last,
    );
    final safeTime = (recommendation.safeExposure * (selectedSkinType.burnTime / 20)).round();
    return UVRecommendation(
      uvIndex: recommendation.uvIndex,
      safeExposure: safeTime,
      protection: recommendation.protection,
    );
  }

  Future<void> _scanForDevices() async {
    try {
      await context.read<BleService>().scanForDevices();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan failed: $e')),
        );
      }
    }
  }

  Future<void> _readUVValue() async {
    final bleService = context.read<BleService>();
    
    if (!bleService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect to a device first')),
      );
      return;
    }

    try {
      final uvValue = await bleService.startUVReading();
      if (uvValue != null) {
        setState(() {
          currentUV = uvValue;
        });
        _addUVReading(uvValue);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('UV Index: ${uvValue.toStringAsFixed(1)}')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No UV data received')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to read UV: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSkinType = context.watch<SkinTypeProvider>().selectedSkinType;
    final uvLevel = _getUVLevel(currentUV);
    final recommendations = _getRecommendations(selectedSkinType);
    
    return Consumer<BleService>(
      builder: (context, bleService, child) {
        return Scaffold(
          body: RefreshIndicator(
        onRefresh: () async {
          _scanForDevices();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('UV Monitor'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.bluetooth,
                    color: bleService.isConnected ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    _showDeviceModal();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _showSettingsModal();
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Current UV Card
                  _buildUVCard(uvLevel),
                  const SizedBox(height: 16),
                  
                  // Device Status Card
                  if (bleService.isConnected) _buildDeviceCard(bleService),
                  if (bleService.isConnected) const SizedBox(height: 16),
                  
                  // Recommendations Card
                  _buildRecommendationsCard(recommendations, selectedSkinType),
                  const SizedBox(height: 16),
                  
                  // Quiz Card
                  _buildQuizCard(),
                  const SizedBox(height: 16),
                  
                  // Recent Readings Card
                  _buildReadingsCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: bleService.isReading ? null : _readUVValue,
            icon: bleService.isReading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.sensors),
            label: Text(bleService.isReading ? 'Reading...' : 'Read UV'),
            backgroundColor: bleService.isReading ? Colors.grey[300]! : Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildUVCard(UVLevel uvLevel) {
    return Consumer<BleService>(
      builder: (context, bleService, child) {
        return Card(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  uvLevel.color,
                  uvLevel.color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.wb_sunny, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  currentUV.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  uvLevel.level,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  bleService.isReading ? 'Reading...' : 'UV Index',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: bleService.isReading ? null : _readUVValue,
                  icon: bleService.isReading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(bleService.isReading ? 'Reading for 3s...' : 'Read UV Level'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: uvLevel.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeviceCard(BleService bleService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.bluetooth_connected, color: Colors.green),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bleService.connectedDevice?.platformName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Connected',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(UVRecommendation recommendations, SkinType selectedSkinType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  'Protection Recommendations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Safe exposure: ${recommendations.safeExposure} minutes for ${selectedSkinType.name} skin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...recommendations.protection.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  Expanded(child: Text(tip)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard() {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/quiz'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.quiz,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find Your Skin Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Take our personalized quiz to get better UV protection recommendations',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Readings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...uvReadings.take(5).map((reading) {
              final readingLevel = _getUVLevel(reading.uvIndex);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            reading.uvIndex.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: readingLevel.color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            readingLevel.level,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${reading.timestamp.hour.toString().padLeft(2, '0')}:${reading.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDeviceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildDeviceModal(),
    );
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildSettingsModal(),
    );
  }

  Widget _buildDeviceModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.only(top: 8),
      child: Consumer<BleService>(
        builder: (context, bleService, child) {
          return Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bluetooth Devices',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: bleService.isScanning 
                      ? null 
                      : () => context.read<BleService>().scanForDevices(),
                  child: Text(bleService.isScanning ? 'Scanning...' : 'Scan for Devices'),
                ),
              ),
              // Device list automatically updates via Provider
              if (bleService.discoveredDevices.isEmpty && !bleService.isScanning)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No devices found.\nTap "Scan for Devices" to search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else if (bleService.isScanning && bleService.discoveredDevices.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Scanning for devices...'),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: bleService.discoveredDevices.length,
                    itemBuilder: (context, index) {
                      final device = bleService.discoveredDevices[index];
                      final isCurrentlyConnected = bleService.connectedDevice?.remoteId == device.remoteId;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.bluetooth),
                          title: Text(device.platformName.isEmpty ? 'Unknown Device' : device.platformName),
                          subtitle: Text(device.remoteId.toString()),
                          trailing: isCurrentlyConnected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : bleService.isConnecting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.chevron_right),
                          onTap: () async {
                            try {
                              await context.read<BleService>().connectToDevice(device);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Connected to ${device.platformName}')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to connect: $e')),
                                );
                              }
                            }
                          },
                          tileColor: isCurrentlyConnected ? Colors.green[50] : null,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(top: 8),
      child: Consumer<SkinTypeProvider>(
        builder: (context, skinTypeProvider, child) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Skin Type',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        ...skinTypes.map((skin) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: skinTypeProvider.selectedSkinType.id == skin.id 
                              ? Theme.of(context).colorScheme.primaryContainer 
                              : null,
                          child: ListTile(
                            leading: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: skin.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Text(skin.name),
                            subtitle: Text(skin.description),
                            onTap: () {
                              context.read<SkinTypeProvider>().updateSkinType(skin);
                            },
                          ),
                        )),
                        const SizedBox(height: 20),
                        const Text(
                          'UV Alert Threshold',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alert when UV index exceeds ${uvAlertThreshold.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Slider(
                                  value: uvAlertThreshold,
                                  min: 0,
                                  max: 11,
                                  divisions: 22,
                                  label: uvAlertThreshold.toStringAsFixed(1),
                                  onChanged: (value) {
                                    setModalState(() {
                                      uvAlertThreshold = value;
                                    });
                                    setState(() {
                                      uvAlertThreshold = value;
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '0.0 (Low)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '11.0 (Extreme)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
