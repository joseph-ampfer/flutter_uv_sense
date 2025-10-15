import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../data/mock_data.dart';


// UV Monitor Screen
class UVMonitorScreen extends StatefulWidget {
  final SkinType? initialSkinType;
  final Function(SkinType)? onSkinTypeUpdated;
  
  const UVMonitorScreen({
    super.key,
    this.initialSkinType,
    this.onSkinTypeUpdated,
  });

  @override
  State<UVMonitorScreen> createState() => _UVMonitorScreenState();
}

class _UVMonitorScreenState extends State<UVMonitorScreen> {
  double currentUV = 6.2;
  late SkinType selectedSkinType;
  Device? connectedDevice;
  bool showDeviceModal = false;
  bool showSettingsModal = false;
  bool isScanning = false;
  
  List<UVReading> uvReadings = [];
  List<Device> bluetoothDevices = [
    Device(id: 'UV001', name: 'UV Sensor Pro', batteryLevel: 85, isConnected: true),
    Device(id: 'UV002', name: 'SunGuard Device', batteryLevel: 62, isConnected: false),
    Device(id: 'UV003', name: 'UV Monitor X', batteryLevel: 91, isConnected: false),
  ];

  @override
  void initState() {
    super.initState();
    selectedSkinType = widget.initialSkinType ?? skinTypes[2]; // Medium skin type default
    connectedDevice = bluetoothDevices.firstWhere((device) => device.isConnected);
    _generateMockReadings();
  }

  void _generateMockReadings() {
    final now = DateTime.now();
    uvReadings = List.generate(10, (index) {
      return UVReading(
        id: 'reading_$index',
        uvIndex: (currentUV + (index * 0.5) - 2).clamp(0.0, 12.0),
        timestamp: now.subtract(Duration(minutes: index * 15)),
      );
    });
  }

  UVLevel _getUVLevel(double uvIndex) {
    if (uvIndex <= 2) return UVLevel('Low', Colors.green);
    if (uvIndex <= 5) return UVLevel('Moderate', Colors.yellow);
    if (uvIndex <= 7) return UVLevel('High', Colors.orange);
    if (uvIndex <= 10) return UVLevel('Very High', Colors.red);
    return UVLevel('Extreme', Colors.purple);
  }

  UVRecommendation _getRecommendations() {
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

  void _connectToDevice(String deviceId) {
    setState(() {
      // Disconnect all devices first
      bluetoothDevices = bluetoothDevices.map((device) => 
        Device(
          id: device.id,
          name: device.name,
          batteryLevel: device.batteryLevel,
          isConnected: false,
        )
      ).toList();
      
      // Connect the selected device
      final deviceIndex = bluetoothDevices.indexWhere((device) => device.id == deviceId);
      if (deviceIndex != -1) {
        bluetoothDevices[deviceIndex] = Device(
          id: bluetoothDevices[deviceIndex].id,
          name: bluetoothDevices[deviceIndex].name,
          batteryLevel: bluetoothDevices[deviceIndex].batteryLevel,
          isConnected: true,
        );
        connectedDevice = bluetoothDevices[deviceIndex];
      }
    });
  }

  void _scanForDevices() {
    setState(() {
      isScanning = true;
    });
    
    // Simulate scanning delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final uvLevel = _getUVLevel(currentUV);
    final recommendations = _getRecommendations();
    
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
                    color: connectedDevice != null ? Colors.blue : Colors.grey,
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
                  if (connectedDevice != null) _buildDeviceCard(),
                  if (connectedDevice != null) const SizedBox(height: 16),
                  
                  // Recommendations Card
                  _buildRecommendationsCard(recommendations),
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
    );
  }

  Widget _buildUVCard(UVLevel uvLevel) {
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
            const Text(
              'UV Index',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.wifi, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  connectedDevice!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.battery_full),
                const SizedBox(width: 4),
                Text('${connectedDevice!.batteryLevel}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(UVRecommendation recommendations) {
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
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
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
              onPressed: isScanning ? null : _scanForDevices,
              child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: bluetoothDevices.length,
              itemBuilder: (context, index) {
                final device = bluetoothDevices[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.id),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (device.isConnected)
                          const Text(
                            'Connected',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                          ),
                        const SizedBox(width: 8),
                        Text('${device.batteryLevel}%'),
                      ],
                    ),
                    onTap: () => _connectToDevice(device.id),
                    tileColor: device.isConnected ? Colors.green[50] : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            alignment: Alignment.center,
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
                  color: selectedSkinType.id == skin.id ? Theme.of(context).colorScheme.primaryContainer : null,
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
                      setState(() {
                        selectedSkinType = skin;
                      });
                      widget.onSkinTypeUpdated?.call(skin);
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
                    child: Text('Alert when UV index exceeds 6.0'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
