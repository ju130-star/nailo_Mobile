import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoService {
  static final _notificacoes = FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const AndroidInitializationSettings initAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: initAndroid);

    await _notificacoes.initialize(initSettings);
  }

  static Future<void> enviarNotificacao({
    required String titulo,
    required String corpo,
  }) async {
    const AndroidNotificationDetails detalhesAndroid =
        AndroidNotificationDetails(
      'canal_agenda',
      'Notificações de Agendamento',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails detalhes =
        NotificationDetails(android: detalhesAndroid);

    await _notificacoes.show(
      0,
      titulo,
      corpo,
      detalhes,
    );
  }
}
