import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 25 * 60;
  int _totalSeconds = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  String _selectedSubject = 'Flutter Dasar';
  final List<Map<String, dynamic>> _studyLogs = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _stopTimer();
        _addStudyLog();
        _showCompletionDialog();
      }
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  void _resetTimer() {
    _stopTimer();
    setState(() => _seconds = _totalSeconds);
  }

  void _setPreset(int minutes) {
    _stopTimer();
    setState(() {
      _totalSeconds = minutes * 60;
      _seconds = _totalSeconds;
    });
  }

  void _addStudyLog() {
    final now = DateTime.now();
    final duration = _totalSeconds ~/ 60;
    final endTime = now.add(Duration(seconds: _totalSeconds));
    
    setState(() {
      _studyLogs.insert(0, {
        'subject': _selectedSubject,
        'duration': duration >= 60 ? '${duration ~/ 60}j ${duration % 60}m' : '${duration}m',
        'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Sesi Selesai!'),
        content: Text('Selamat! Anda telah belajar $_selectedSubject selama ${_totalSeconds ~/ 60} menit.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String get _timeDisplay {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final progress = _seconds / _totalSeconds;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFF1A6FBB),
                ),
              ),
              Column(
                children: [
                  Text(
                    _timeDisplay,
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A6FBB),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedSubject,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildPresetButton(25, '🍅 25 min'),
              _buildPresetButton(45, '📚 45 min'),
              _buildPresetButton(60, '🎯 60 min'),
              _buildPresetButton(5, '☕ 5 min'),
            ],
          ),
          const SizedBox(height: 30),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isRunning ? _stopTimer : _startTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 20),
                label: Text(_isRunning ? 'Jeda' : 'Mulai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6FBB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: _selectedSubject,
              items: const [
                DropdownMenuItem(value: 'Flutter Dasar', child: Text('Flutter Dasar')),
                DropdownMenuItem(value: 'Algoritma', child: Text('Algoritma')),
                DropdownMenuItem(value: 'Basis Data', child: Text('Basis Data')),
                DropdownMenuItem(value: 'Jaringan Komputer', child: Text('Jaringan Komputer')),
                DropdownMenuItem(value: 'Matematika Diskrit', child: Text('Matematika Diskrit')),
              ],
              onChanged: (value) => setState(() => _selectedSubject = value!),
              decoration: InputDecoration(
                labelText: 'Pilih Mata Pelajaran',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          if (_studyLogs.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('📝 Log Belajar Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const Divider(height: 1),
                  ..._studyLogs.take(5).map((log) => ListTile(
                    dense: true,
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A6FBB),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(log['subject'], style: const TextStyle(fontSize: 13)),
                    subtitle: Text(log['time'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    trailing: Text(log['duration'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A6FBB))),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(int minutes, String label) {
    final isSelected = _totalSeconds == minutes * 60 && !_isRunning;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _setPreset(minutes),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF1A6FBB).withAlpha(25),
      labelStyle: TextStyle(color: isSelected ? const Color(0xFF1A6FBB) : Colors.black87),
    );
  }
}