import 'package:flutter/material.dart';
import '../services/notification_service.dart';


class Schedule {
  String id;
  String day;
  String subject;
  String time;
  String duration;
  String status;
  Color color;

  Schedule({
    required this.id,
    required this.day,
    required this.subject,
    required this.time,
    required this.duration,
    this.status = 'Akan datang',
    this.color = const Color(0xFFF5A623),
  });
}

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  List<Schedule> _schedules = [];
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final List<String> _subjects = ['Flutter Dasar', 'Algoritma', 'Basis Data', 'Jaringan Komputer', 'Matematika Diskrit'];

  @override
  void initState() {
    super.initState();
    _loadSampleSchedules();
  }

  void _loadSampleSchedules() {
    _schedules = [
      Schedule(
        id: '1',
        day: 'Senin',
        subject: 'Flutter Dasar',
        time: '07:00 - 09:00',
        duration: '2 jam',
        status: 'Selesai',
        color: const Color(0xFF22C55E),
      ),
      Schedule(
        id: '2',
        day: 'Selasa',
        subject: 'Algoritma',
        time: '09:00 - 10:30',
        duration: '1.5 jam',
        status: 'Sedang',
        color: const Color(0xFF1A6FBB),
      ),
      Schedule(
        id: '3',
        day: 'Rabu',
        subject: 'Basis Data',
        time: '13:00 - 15:00',
        duration: '2 jam',
        status: 'Akan datang',
        color: const Color(0xFFF5A623),
      ),
    ];
  }

  void _showAddScheduleDialog() {
    String selectedDay = 'Senin';
    String selectedSubject = 'Flutter Dasar';
    final timeController = TextEditingController(text: '08:00 - 10:00');
    final durationController = TextEditingController(text: '2 jam');
    
    NotificationService.showStudyReminder(selectedSubject, timeController.text);


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Tambah Jadwal Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedDay,
                items: _days.map((day) => DropdownMenuItem(value: day, child: Text(day))).toList(),
                onChanged: (value) => selectedDay = value!,
                decoration: const InputDecoration(labelText: 'Hari'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedSubject,
                items: _subjects.map((subject) => DropdownMenuItem(value: subject, child: Text(subject))).toList(),
                onChanged: (value) => selectedSubject = value!,
                decoration: const InputDecoration(labelText: 'Mata Kuliah'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Waktu (contoh: 08:00 - 10:00)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Durasi (contoh: 2 jam)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _schedules.add(Schedule(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  day: selectedDay,
                  subject: selectedSubject,
                  time: timeController.text,
                  duration: durationController.text,
                ));
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Jadwal berhasil ditambahkan!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A6FBB)),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteSchedule(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal'),
        content: const Text('Yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _schedules.removeWhere((s) => s.id == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ Jadwal dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String get _currentDay {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return days[DateTime.now().weekday % 7];
  }

  List<Schedule> get _todaySchedules {
    return _schedules.where((s) => s.day == _currentDay).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Jadwal Hari Ini'),
                  Tab(text: 'Semua Jadwal'),
                ],
                indicatorColor: Color(0xFF1A6FBB),
                labelColor: Color(0xFF1A6FBB),
                unselectedLabelColor: Colors.grey,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTodaySchedule(),
                  _buildAllSchedules(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddScheduleDialog,
          backgroundColor: const Color(0xFF1A6FBB),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTodaySchedule() {
    final todaySchedules = _todaySchedules;
    
    if (todaySchedules.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada jadwal hari ini', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todaySchedules.length,
      itemBuilder: (context, index) {
        final schedule = todaySchedules[index];
        return _buildScheduleCard(schedule);
      },
    );
  }

  Widget _buildAllSchedules() {
    if (_schedules.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada jadwal', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Tekan tombol + untuk menambah', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final schedule = _schedules[index];
        return _buildScheduleCard(schedule);
      },
    );
  }

  Widget _buildScheduleCard(Schedule schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: schedule.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(schedule.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${schedule.day} · ${schedule.time}'),
            Text(schedule.duration, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: schedule.color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                schedule.status,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: schedule.color),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              onPressed: () => _deleteSchedule(schedule.id),
            ),
          ],
        ),
      ),
    );
  }
}