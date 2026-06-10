import 'package:flutter/material.dart';

class Subject {
  final String name;
  final Color color;
  final String tag;
  double hours;
  final double target;
  List<Session> sessions;

  Subject({
    required this.name,
    required this.color,
    required this.tag,
    required this.hours,
    required this.target,
    required this.sessions,
  });
}

class Session {
  final String day;
  final String time;
  final String dur;

  Session({
    required this.day,
    required this.time,
    required this.dur,
  });
}

class Goal {
  String title;
  String description;
  String subject;
  String priority;
  DateTime deadline;
  bool done;

  Goal({
    required this.title,
    required this.description,
    required this.subject,
    required this.priority,
    required this.deadline,
    this.done = false,
  });
}

class StudyModule {
  final String name;
  final String subject;
  final String type;
  final String size;

  StudyModule({
    required this.name,
    required this.subject,
    required this.type,
    required this.size,
  });
}

class StudyImage {
  final String name;
  final String subject;
  final String type;
  final String size;

  StudyImage({
    required this.name,
    required this.subject,
    required this.type,
    required this.size,
  });
}

class AppData {
  static List<Subject> subjects = [
    Subject(
      name: 'Flutter Dasar',
      color: const Color(0xFF1A6FBB),
      tag: 'flutter',
      hours: 4,
      target: 6,
      sessions: [
        Session(day: 'Sen', time: '07:00 - 09:00', dur: '2j'),
        Session(day: 'Rab', time: '13:00 - 15:00', dur: '2j'),
      ],
    ),
    Subject(
      name: 'Algoritma & Pemrograman',
      color: const Color(0xFFF5A623),
      tag: 'algoritma',
      hours: 3,
      target: 5,
      sessions: [
        Session(day: 'Sel', time: '09:00 - 10:30', dur: '1.5j'),
        Session(day: 'Kam', time: '14:00 - 16:00', dur: '2j'),
      ],
    ),
    Subject(
      name: 'Basis Data',
      color: const Color(0xFF22C55E),
      tag: 'db',
      hours: 5,
      target: 6,
      sessions: [
        Session(day: 'Sen', time: '13:00 - 15:00', dur: '2j'),
        Session(day: 'Jum', time: '08:00 - 11:00', dur: '3j'),
      ],
    ),
    Subject(
      name: 'Jaringan Komputer',
      color: const Color(0xFF7C3AED),
      tag: 'jaringan',
      hours: 2,
      target: 4,
      sessions: [
        Session(day: 'Rab', time: '16:00 - 17:00', dur: '1j'),
        Session(day: 'Sab', time: '09:00 - 10:00', dur: '1j'),
      ],
    ),
    Subject(
      name: 'Matematika Diskrit',
      color: const Color(0xFFEF4444),
      tag: 'matematika',
      hours: 1.5,
      target: 3,
      sessions: [
        Session(day: 'Sel', time: '19:00 - 20:30', dur: '1.5j'),
      ],
    ),
  ];

  static List<Goal> goals = [
    Goal(
      title: 'Memahami konsep Widget Tree di Flutter',
      description: 'Mempelajari halaman 8-28 materi Flutter Dasar termasuk visible dan non-visible widget',
      subject: 'flutter',
      priority: 'high',
      deadline: DateTime(2026, 6, 8),
      done: true,
    ),
    Goal(
      title: 'Latihan soal Algoritma bab 3 & 4',
      description: 'Mengerjakan minimum 20 soal latihan algoritma sorting dan searching',
      subject: 'algoritma',
      priority: 'high',
      deadline: DateTime(2026, 6, 7),
      done: true,
    ),
    Goal(
      title: 'Membuat project StatefulWidget sederhana',
      description: 'Implementasi counter app menggunakan StatefulWidget dan setState()',
      subject: 'flutter',
      priority: 'med',
      deadline: DateTime(2026, 6, 10),
      done: false,
    ),
    Goal(
      title: 'Review materi Basis Data untuk UTS',
      description: 'Membaca ulang semua materi dari bab 1-5 dan membuat rangkuman',
      subject: 'db',
      priority: 'high',
      deadline: DateTime(2026, 6, 12),
      done: false,
    ),
    Goal(
      title: 'Rangkum State Management Flutter',
      description: 'Provider, Riverpod, BLoC — membuat mind map perbandingan',
      subject: 'flutter',
      priority: 'med',
      deadline: DateTime(2026, 6, 15),
      done: false,
    ),
    Goal(
      title: 'Latihan konfigurasi Router Jaringan',
      description: 'Praktik konfigurasi OSPF dan RIP menggunakan Packet Tracer',
      subject: 'jaringan',
      priority: 'low',
      deadline: DateTime(2026, 6, 20),
      done: false,
    ),
  ];

  static List<StudyModule> modules = [
    StudyModule(name: 'Flutter Dasar - Slide Lengkap', subject: 'Flutter Dasar', type: 'PDF', size: '4.2 MB'),
    StudyModule(name: 'Widget Reference Guide', subject: 'Flutter Dasar', type: 'PDF', size: '2.1 MB'),
    StudyModule(name: 'Dart Programming Basics', subject: 'Flutter Dasar', type: 'DOCX', size: '1.8 MB'),
    StudyModule(name: 'Algoritma Sorting Lengkap', subject: 'Algoritma', type: 'PDF', size: '3.5 MB'),
    StudyModule(name: 'Modul Basis Data Relasional', subject: 'Basis Data', type: 'PDF', size: '5.0 MB'),
    StudyModule(name: 'SQL Query Cheatsheet', subject: 'Basis Data', type: 'DOCX', size: '0.8 MB'),
  ];

  static List<StudyImage> images = [
    StudyImage(name: 'Widget Tree Diagram', subject: 'Flutter Dasar', type: 'PNG', size: '1.2 MB'),
    StudyImage(name: 'StatelessWidget vs StatefulWidget', subject: 'Flutter Dasar', type: 'PNG', size: '0.9 MB'),
    StudyImage(name: 'Layout Row & Column', subject: 'Flutter Dasar', type: 'PNG', size: '1.1 MB'),
    StudyImage(name: 'ERD Basis Data', subject: 'Basis Data', type: 'PNG', size: '0.7 MB'),
  ];

  static List<Map<String, dynamic>> studyLogs = [
    {'subject': 'Flutter Dasar', 'duration': '2j 0m', 'time': '07:00 - 09:00', 'color': const Color(0xFF1A6FBB)},
    {'subject': 'Algoritma & Pemrograman', 'duration': '1j 30m', 'time': '09:30 - 11:00', 'color': const Color(0xFFF5A623)},
  ];
}