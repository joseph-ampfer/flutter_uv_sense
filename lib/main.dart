import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/uv_monitor_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/results_screen.dart';
import 'services/ble_service.dart';
import 'providers/skin_type_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BleService()),
        ChangeNotifierProvider(create: (context) => SkinTypeProvider()),
      ],
      child: MaterialApp(
        title: 'Simple App',
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
        home: const MainNavigationPage(),
        routes: {
          '/quiz': (context) => const QuizScreen(),
          '/results': (context) {
            final responses = ModalRoute.of(context)!.settings.arguments as Map<int, int>;
            return ResultsScreen(responses: responses);
          },
        },
      ),
    );
  }
}

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UVMonitorScreen();
  }
}

