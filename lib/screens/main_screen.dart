import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'planner_screen.dart';
import 'goals_screen.dart';
import 'timer_screen.dart';
import 'modules_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const PlannerScreen(),
    const GoalsScreen(),
    const TimerScreen(),
    const ModulesScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Jadwal Belajar',
    'Target & Goals',
    'Timer Belajar',
    'Modul & Materi',
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (user != null) ...[
            Text(
              user.displayName?.split(' ').first ?? 'User',
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A6FBB)),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.grey),
              onPressed: () async {
                await authService.signOut();
              },
            ),
          ],
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A6FBB),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.flag_outlined), label: 'Goals'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), label: 'Timer'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Modul'),
        ],
      ),
    );
  }
}