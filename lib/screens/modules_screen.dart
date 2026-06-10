import 'package:flutter/material.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  List<Map<String, dynamic>> _modules = [];

  @override
  void initState() {
    super.initState();
    _loadSampleModules();
  }

  void _loadSampleModules() {
    _modules = [
      {'id': '1', 'name': 'Flutter Dasar - Slide', 'subject': 'Flutter Dasar', 'type': 'PDF', 'size': '4.2 MB'},
      {'id': '2', 'name': 'Widget Reference', 'subject': 'Flutter Dasar', 'type': 'PDF', 'size': '2.1 MB'},
      {'id': '3', 'name': 'Dart Programming', 'subject': 'Flutter Dasar', 'type': 'DOCX', 'size': '1.8 MB'},
      {'id': '4', 'name': 'Algoritma Sorting', 'subject': 'Algoritma', 'type': 'PDF', 'size': '3.5 MB'},
      {'id': '5', 'name': 'SQL Cheatsheet', 'subject': 'Basis Data', 'type': 'PDF', 'size': '0.8 MB'},
    ];
  }

  void _showAddModuleDialog() {
    final nameController = TextEditingController();
    String selectedSubject = 'Flutter Dasar';
    String selectedType = 'PDF';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: const Text('Tambah Modul'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Modul',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  items: const [
                    DropdownMenuItem(value: 'Flutter Dasar', child: Text('Flutter Dasar')),
                    DropdownMenuItem(value: 'Algoritma', child: Text('Algoritma')),
                    DropdownMenuItem(value: 'Basis Data', child: Text('Basis Data')),
                    DropdownMenuItem(value: 'Jaringan Komputer', child: Text('Jaringan Komputer')),
                  ],
                  onChanged: (value) => setStateDialog(() => selectedSubject = value!),
                  decoration: const InputDecoration(
                    labelText: 'Mata Kuliah',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'PDF', child: Text('PDF')),
                    DropdownMenuItem(value: 'DOCX', child: Text('DOCX')),
                    DropdownMenuItem(value: 'PPTX', child: Text('PPTX')),
                  ],
                  onChanged: (value) => setStateDialog(() => selectedType = value!),
                  decoration: const InputDecoration(
                    labelText: 'Tipe File',
                    border: OutlineInputBorder(),
                  ),
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
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      _modules.add({
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'name': nameController.text,
                        'subject': selectedSubject,
                        'type': selectedType,
                        'size': '0 MB',
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Modul ditambahkan!')),
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

  void _deleteModule(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Modul'),
        content: const Text('Yakin ingin menghapus modul ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _modules.removeWhere((m) => m['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ Modul dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddModuleDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Modul'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6FBB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_modules.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.folder_open, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Belum ada modul', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Tekan tombol + untuk menambah', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _modules.length,
                itemBuilder: (context, index) {
                  final module = _modules[index];
                  final isPdf = module['type'] == 'PDF';
                  
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isPdf ? Colors.red.withAlpha(25) : const Color(0xFF1A6FBB).withAlpha(25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isPdf ? Icons.picture_as_pdf : Icons.description,
                                color: isPdf ? Colors.red : const Color(0xFF1A6FBB),
                                size: 24,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                              onPressed: () => _deleteModule(module['id']),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          module['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${module['subject']} · ${module['size']}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPdf ? Colors.red.withAlpha(25) : const Color(0xFF1A6FBB).withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            module['type'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isPdf ? Colors.red : const Color(0xFF1A6FBB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}