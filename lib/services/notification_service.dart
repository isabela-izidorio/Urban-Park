import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings: settings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showVehicleAdded({
    required String plate,
    required String type,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'vehicle_updates',
        'Cadastro de veículos',
        channelDescription: 'Avisos sobre veículos cadastrados no Urban Park',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Veículo cadastrado!',
      body: 'O veículo $plate ($type) foi adicionado à sua conta.',
      notificationDetails: details,
    );
  }

  static Future<void> showReservationConfirmation({
    required String zoneName,
    required String plate,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'reservation_confirmations',
        'Reservas confirmadas',
        channelDescription: 'Avisos sobre reservas realizadas no Urban Park',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Reserva Confirmada!',
      body: 'A reserva de $zoneName para o veículo $plate foi confirmada.',
      notificationDetails: details,
    );
  }
}
