// import 'package:flutter/material.dart';
// import 'package:plant_app/components/navigation.dart';
// import 'package:plant_app/constants.dart';
// import 'package:plant_app/screens/home/home_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Plant App',
//       color: kPrimaryColor,
//       theme: ThemeData(
//         scaffoldBackgroundColor: kBackgroundColor,
//         primaryColor: Color(0xFF0C9869),
//         textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: Scaffold(body : Navigation()),
//     );
//   }
// }

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:plant_app/components/navigation.dart';
import 'package:plant_app/core/service/fire_base_option.dart';
import 'package:plant_app/core/service/notification_service.dart';
import 'package:plant_app/screens/Login/Screen/splash_screen.dart';
import 'package:plant_app/screens/Notification/Screen/Bloc/notification_bloc.dart';
import 'package:plant_app/screens/Notification/Screen/Bloc/notification_event.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterSecureStorage storage = const FlutterSecureStorage();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationBloc? notificationBloc;

/// ✅ Fetch notifications and store them in local storage
void fetchNotificationsFromServer() async {
  if (notificationBloc != null) {
    print("📩 Fetching notifications in the foreground...");
    notificationBloc!.add(FetchNotifications());
  } else {
    print("⚠️ App is closed! Saving notifications for later...");
    // notificationBloc!.add(FetchNotifications());
    // Example: Save a dummy notification (Replace with actual API call)
    await storage.write(
        key: "latest_notification", value: "New notification received!");
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  // Run a periodic timer in the background every 15 minutes
  Timer.periodic(const Duration(seconds: 30), (timer) {
    print("🔄 Background Service Running: Fetching Notifications...");
    fetchNotificationsFromServer();
    // Send event to the main isolate
    service.invoke("fetchNotifications");
  });
}

/// ✅ Initialize local notifications
void initializeLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

/// ✅ Background message handler (Cannot use UI)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔥 Handling a background message: ${message.messageId}");
  String notificationId = DateTime.now().toString();
  await NotificationService.instance.showNotification(
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      notificationId);
  fetchNotificationsFromServer();
}

/// ✅ Foreground notification handler
void _setupFCM(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🎯 Foreground Notification: ${message.notification?.title}");

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'sadqahzakaat_channel',
      'SadqahZakaat Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );

    // ✅ Fetch notifications in UI
    context.read<NotificationBloc>().add(FetchNotifications());
    fetchNotificationsFromServer();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences and Firebase
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local notifications
  initializeLocalNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Check onboarding status
  bool isOnboardingComplete = prefs.getBool('onboardingComplete') ?? false;
//   String? token = await FirebaseMessaging.instance.getToken();
//   print("🔑 FCM Token: $token");
  // Start background service
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      // onBackground: _onBackground,
    ),
  );
  await service.startService();

  // Set the NotificationBloc globally
  notificationBloc = NotificationBloc();

  runApp(MyApp(showOnboarding: !isOnboardingComplete));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    final service = FlutterBackgroundService();

    // Listen for background events and update NotificationBloc
    service.on("fetchNotifications").listen((event) {
      print("📩 Received Background Event: Fetching Notifications...");
      // context.read<NotificationBloc>().add(FetchNotifications());
      fetchNotificationsFromServer();
    });
    return
      ScreenUtilInit(
        designSize: const Size(330, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return BlocProvider(
            create: (context) => notificationBloc!,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashPage()
            ),
          );
        },
      // ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    _setupFCM(context);
    restoreNotifications();
  }

  void restoreNotifications() async {
    String? savedNotification = await storage.read(key: "latest_notification");
    if (savedNotification != null) {
      print("📥 Restoring saved notification: $savedNotification");
      context.read<NotificationBloc>().add(FetchNotifications());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()), // Placeholder
    );
  }
}
