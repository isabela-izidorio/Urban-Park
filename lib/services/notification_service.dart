import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showParkingConfirmation({
    required String zoneName,
    required String plate,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'parking_confirmations',
        'Confirmações de estacionamento',
        channelDescription: 'Avisos sobre reservas confirmadas no Urban Park',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Estacionamento confirmado!',
      'Sua vaga em $zoneName foi registrada para o veículo $plate.',
      details,
    );
  }
}
