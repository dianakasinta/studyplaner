import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // HAPUS 'const' - ini tidak bisa konstan
    final AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // JANGAN LUPA panggil initialize
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // HAPUS 'const' - ini juga tidak bisa konstan
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'study_channel',
      'Go Study!',
      importance: Importance.high,
      priority: Priority.high,
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // PERBAIKI: pakai positional parameters, BUKAN named parameters
    await _notifications.show(
      id,      // tanpa 'id:'
      title,   // tanpa 'title:'
      body,    // tanpa 'body:'
      details, // tanpa 'notificationDetails:'
    );
  }

  static Future<void> showGoalCompleted(String goalTitle) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '🎉 Goal Selesai!',
      body: 'Selamat! Anda telah menyelesaikan: $goalTitle',
    );
  }

  static Future<void> showStudyReminder(String subject, String time) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '⏰ Waktunya Belajar!',
      body: 'Jadwal $subject pada $time',
    );
  }
}