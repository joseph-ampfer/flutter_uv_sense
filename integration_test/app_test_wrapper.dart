import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/screens/uv_monitor_screen.dart';
import 'package:simple_app/screens/quiz_screen.dart';
import 'package:simple_app/screens/results_screen.dart';
import 'package:simple_app/services/ble_service.dart';
import 'package:simple_app/providers/skin_type_provider.dart';
import 'test_helpers.dart';

/// Test wrapper app with injectable mock services
class TestApp extends StatelessWidget {
  final BleService? bleService;
  final SkinTypeProvider? skinTypeProvider;

  const TestApp({
    super.key,
    this.bleService,
    this.skinTypeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BleService>(
          create: (context) => bleService ?? MockBleService(),
        ),
        ChangeNotifierProvider<SkinTypeProvider>(
          create: (context) => skinTypeProvider ?? SkinTypeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'UV Monitor Test App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        home: const UVMonitorScreen(),
        routes: {
          '/quiz': (context) => const QuizScreen(),
          '/results': (context) {
            final responses =
                ModalRoute.of(context)!.settings.arguments as Map<int, int>;
            return ResultsScreen(responses: responses);
          },
        },
      ),
    );
  }
}

/// Create a test app with custom mock services
Widget createTestApp({
  MockBleService? mockBleService,
  SkinTypeProvider? skinTypeProvider,
}) {
  return TestApp(
    bleService: mockBleService,
    skinTypeProvider: skinTypeProvider,
  );
}

