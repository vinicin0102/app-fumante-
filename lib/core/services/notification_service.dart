import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

// Função top-level para background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Se necessário inicializar Firebase aqui também para usar outros serviços
  // await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Request Permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
      return;
    }

    // 2. Setup Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Get Token
    try {
      String? token = await _firebaseMessaging.getToken();
      debugPrint("FCM Token: $token");
      // Aqui você enviaria o token para seu backend se necessário
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
    }

    // 4. Local Notifications Setup
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    // 5. Create Channel (Android High Importance)
    // Isso é necessário para heads-up notifications no Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'Notificações Importantes', // title
      description: 'Este canal é usado para notificações importantes.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 6. Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        _showNotification(message, channel);
      }
    });

    // Handle interaction when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("App opened from terminated state via notification");
        // Handle navigation or logic
      }
    });

    // Handle interaction when app is in background and opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("App opened from background state via notification");
        // Handle navigation or logic
    });
  }

  Future<void> _showNotification(RemoteMessage message, AndroidNotificationChannel channel) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    
    // Se for iOS, o sistema lida com foreground se configurado, 
    // mas usando local notifications permite customização.
    // Para Android precisamos mostrar manualmente se quisermos heads-up enquanto o app está aberto.

    if (notification != null && android != null) {
       _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            // ou '@mipmap/ic_launcher' se android.smallIcon for nulo/inválido
          ),
        ),
      );
    }
  }
}
