import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Goals per hari
  final Map<String, List<Map<String, dynamic>>> _dailyGoals = {
    'Senin': [
      {'text': 'Menyelesaikan modul Widget Flutter (halaman 1-30)', 'done': false},
      {'text': 'Membuat project sederhana dengan Flutter', 'done': false},
      {'text': 'Review materi Basis Data bab 1', 'done': false},
    ],
    'Selasa': [
      {'text': 'Latihan soal Algoritma bab 3', 'done': false},
      {'text': 'Mengerjakan tugas Matematika Diskrit', 'done': false},
      {'text': 'Membaca artikel tentang State Management', 'done': false},
    ],
    'Rabu': [
      {'text': 'Praktek Jaringan Komputer (Konfigurasi Router)', 'done': false},
      {'text': 'Menyelesaikan modul Flutter lanjutan', 'done': false},
      {'text': 'Review kodingan minggu lalu', 'done': false},
    ],
    'Kamis': [
      {'text': 'Mengerjakan 10 soal Algoritma', 'done': false},
      {'text': 'Membuat ERD untuk project akhir', 'done': false},
      {'text': 'Latihan SQL Query', 'done': false},
    ],
    'Jumat': [
      {'text': 'Menyelesaikan laporan mingguan', 'done': false},
      {'text': 'Push project ke GitHub', 'done': false},
      {'text': 'Review seluruh materi minggu ini', 'done': false},
    ],
    'Sabtu': [
      {'text': 'Belajar Flutter dari YouTube', 'done': false},
      {'text': 'Mengerjakan project akhir', 'done': false},
      {'text': 'Baca dokumentasi Flutter', 'done': false},
    ],
    'Minggu': [
      {'text': 'Istirahat dan recharge', 'done': false},
      {'text': 'Rencanakan target minggu depan', 'done': false},
      {'text': 'Review kodingan', 'done': false},
    ],
  };

  late String _currentDay;
  late List<Map<String, dynamic>> _currentGoals;
  int _completedGoals = 0;

  @override
  void initState() {
    super.initState();
    _updateDailyData();
  }

  void _updateDailyData() {
    final now = DateTime.now();
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    _currentDay = days[now.weekday % 7];
    
    _currentGoals = _dailyGoals[_currentDay]?.map((goal) => 
      Map<String, dynamic>.from(goal)
    ).toList() ?? [];
    
    _completedGoals = _currentGoals.where((g) => g['done'] == true).length;
  }

  void _toggleGoal(int index) {
    setState(() {
      _currentGoals[index]['done'] = !_currentGoals[index]['done'];
      _completedGoals = _currentGoals.where((g) => g['done'] == true).length;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_currentGoals[index]['done'] ? '✅ Goal selesai! Selamat!' : 'Goal dibatalkan'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.04;
    final progress = _currentGoals.isEmpty ? 0.0 : _completedGoals / _currentGoals.length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getGreeting()}, Diana!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_currentDay, ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Goals Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('🎯 Goals Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('$_completedGoals/${_currentGoals.length} selesai', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _currentGoals.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Tidak ada goals untuk hari ini', style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : Column(
                          children: [
                            ...List.generate(_currentGoals.length, (index) => _buildGoalItem(index)),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey.shade200,
                                    color: const Color(0xFF1A6FBB),
                                    borderRadius: BorderRadius.circular(4),
                                    minHeight: 10,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A6FBB)),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(int index) {
    final goal = _currentGoals[index];
    return GestureDetector(
      onTap: () => _toggleGoal(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              goal['done'] ? Icons.check_circle : Icons.radio_button_unchecked,
              color: goal['done'] ? const Color(0xFF22C55E) : const Color(0xFF8FA0B8),
              size: 26,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                goal['text'],
                style: TextStyle(
                  fontSize: 14,
                  decoration: goal['done'] ? TextDecoration.lineThrough : null,
                  color: goal['done'] ? Colors.grey : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}