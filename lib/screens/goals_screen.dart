import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class Goal {
  String id;
  String title;
  bool isDone;
  DateTime deadline;
  String priority;

  Goal({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.deadline,
    this.priority = 'normal',
  });
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> _goals = [];
  String _filter = 'semua';

  final TextEditingController _goalController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedPriority = 'normal';

  @override
  void initState() {
    super.initState();
    _loadSampleGoals();
  }

  void _loadSampleGoals() {
    _goals = [
      Goal(
        id: '1',
        title: 'Menyelesaikan modul Widget Flutter',
        isDone: true,
        deadline: DateTime.now().add(const Duration(days: 2)),
        priority: 'high',
      ),
      Goal(
        id: '2',
        title: 'Latihan soal Algoritma bab 3',
        isDone: true,
        deadline: DateTime.now().add(const Duration(days: 1)),
        priority: 'high',
      ),
      Goal(
        id: '3',
        title: 'Membuat project StatefulWidget',
        isDone: false,
        deadline: DateTime.now().add(const Duration(days: 5)),
        priority: 'normal',
      ),
      Goal(
        id: '4',
        title: 'Review materi Basis Data',
        isDone: false,
        deadline: DateTime.now().add(const Duration(days: 3)),
        priority: 'low',
      ),
    ];
  }

  void _addGoal() {
    _goalController.clear();
    _selectedPriority = 'normal';
    _selectedDate = DateTime.now().add(const Duration(days: 7));
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: const Text('Tambah Goal Baru'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _goalController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Goal',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  items: const [
                    DropdownMenuItem(value: 'high', child: Row(
                      children: [Icon(Icons.flag, color: Colors.red, size: 16), SizedBox(width: 8), Text('Tinggi')],
                    )),
                    DropdownMenuItem(value: 'normal', child: Row(
                      children: [Icon(Icons.flag, color: Colors.orange, size: 16), SizedBox(width: 8), Text('Normal')],
                    )),
                    DropdownMenuItem(value: 'low', child: Row(
                      children: [Icon(Icons.flag, color: Colors.green, size: 16), SizedBox(width: 8), Text('Rendah')],
                    )),
                  ],
                  onChanged: (value) => setStateDialog(() => _selectedPriority = value!),
                  decoration: const InputDecoration(labelText: 'Prioritas'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Deadline'),
                  subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setStateDialog(() => _selectedDate = date);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_goalController.text.isNotEmpty) {
                    setState(() {
                      _goals.add(Goal(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _goalController.text,
                        isDone: false,
                        deadline: _selectedDate,
                        priority: _selectedPriority,
                      ));
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Goal berhasil ditambahkan!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A6FBB)),
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editGoal(Goal goal) {
    _goalController.text = goal.title;
    _selectedPriority = goal.priority;
    _selectedDate = goal.deadline;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: const Text('Edit Goal'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _goalController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Goal',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  items: const [
                    DropdownMenuItem(value: 'high', child: Row(
                      children: [Icon(Icons.flag, color: Colors.red, size: 16), SizedBox(width: 8), Text('Tinggi')],
                    )),
                    DropdownMenuItem(value: 'normal', child: Row(
                      children: [Icon(Icons.flag, color: Colors.orange, size: 16), SizedBox(width: 8), Text('Normal')],
                    )),
                    DropdownMenuItem(value: 'low', child: Row(
                      children: [Icon(Icons.flag, color: Colors.green, size: 16), SizedBox(width: 8), Text('Rendah')],
                    )),
                  ],
                  onChanged: (value) => setStateDialog(() => _selectedPriority = value!),
                  decoration: const InputDecoration(labelText: 'Prioritas'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Deadline'),
                  subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) setStateDialog(() => _selectedDate = date);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
              ElevatedButton(
                onPressed: () {
                  if (_goalController.text.isNotEmpty) {
                    setState(() {
                      goal.title = _goalController.text;
                      goal.priority = _selectedPriority;
                      goal.deadline = _selectedDate;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✏️ Goal berhasil diupdate!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A6FBB)),
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleGoal(Goal goal) {
    setState(() {
      goal.isDone = !goal.isDone;
    });

    if (goal.isDone) {
      NotificationService.showGoalCompleted(goal.title);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(goal.isDone ? '🎉 Goal selesai! Selamat!' : 'Goal dibatalkan'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteGoal(Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Goal'),
        content: Text('Yakin ingin menghapus "${goal.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _goals.removeWhere((g) => g.id == goal.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ Goal dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  List<Goal> get _filteredGoals {
    if (_filter == 'selesai') return _goals.where((g) => g.isDone).toList();
    if (_filter == 'belum') return _goals.where((g) => !g.isDone).toList();
    return _goals;
  }

  int get _completedCount => _goals.where((g) => g.isDone).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Target Belajar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _addGoal,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Goal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6FBB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('$_completedCount/${_goals.length}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            const Text('Selesai', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('${_goals.isEmpty ? 0 : (_completedCount / _goals.length * 100).toInt()}%', 
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            const Text('Progress', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _goals.isEmpty ? 0 : _completedCount / _goals.length,
                    backgroundColor: Colors.grey.shade200,
                    color: const Color(0xFF1A6FBB),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _filter == 'semua',
                  onSelected: (_) => setState(() => _filter = 'semua'),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF1A6FBB).withAlpha(25),
                  labelStyle: TextStyle(color: _filter == 'semua' ? const Color(0xFF1A6FBB) : Colors.black87),
                ),
                FilterChip(
                  label: const Text('Belum'),
                  selected: _filter == 'belum',
                  onSelected: (_) => setState(() => _filter = 'belum'),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF1A6FBB).withAlpha(25),
                  labelStyle: TextStyle(color: _filter == 'belum' ? const Color(0xFF1A6FBB) : Colors.black87),
                ),
                FilterChip(
                  label: const Text('Selesai'),
                  selected: _filter == 'selesai',
                  onSelected: (_) => setState(() => _filter = 'selesai'),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF1A6FBB).withAlpha(25),
                  labelStyle: TextStyle(color: _filter == 'selesai' ? const Color(0xFF1A6FBB) : Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_filteredGoals.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.flag_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Belum ada goal', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              ..._filteredGoals.map((goal) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: goal.isDone ? Colors.grey.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 2)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: goal.priority == 'high' ? Colors.red : (goal.priority == 'normal' ? Colors.orange : Colors.green),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _toggleGoal(goal),
                      child: Icon(
                        goal.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: goal.isDone ? Colors.green : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: goal.isDone ? TextDecoration.lineThrough : null,
                              color: goal.isDone ? Colors.grey : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${goal.deadline.day}/${goal.deadline.month}/${goal.deadline.year}',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                          onPressed: () => _editGoal(goal),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                          onPressed: () => _deleteGoal(goal),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}