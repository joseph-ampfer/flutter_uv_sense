import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/uv_monitor_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/results_screen.dart';
import 'models/data_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}

// Global variable to hold the selected skin type across navigation
SkinType? globalSelectedSkinType;

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  SkinType? _selectedSkinType;

  void _updateSkinType(SkinType skinType) {
    setState(() {
      _selectedSkinType = skinType;
    });
    globalSelectedSkinType = skinType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if skin type was updated from quiz results
    if (globalSelectedSkinType != null && globalSelectedSkinType != _selectedSkinType) {
      setState(() {
        _selectedSkinType = globalSelectedSkinType;
      });
    }
  }

  List<Widget> get _screens => [
    const HomeScreen(),
    UVMonitorScreen(
      initialSkinType: _selectedSkinType,
      onSkinTypeUpdated: _updateSkinType,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'UV Monitor',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

