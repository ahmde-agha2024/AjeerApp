

import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/controllers/common/chat_provider.dart';
import 'package:ajeer/controllers/common/notifications_provider.dart';
import 'package:ajeer/controllers/customer/customer_orders_provider.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/controllers/general/about_app_controller.dart';
import 'package:ajeer/controllers/service_provider/provider_home_page_provider.dart';
import 'package:ajeer/controllers/service_provider/provider_offers_provider.dart';
import 'package:ajeer/controllers/service_provider/provider_services_provider.dart';
import 'package:ajeer/controllers/service_provider/provider_subscriptions_provider.dart';
import 'package:ajeer/firebase_options.dart';
import 'package:ajeer/ui/screens/home_provider/AjeerCardDistrubutions.dart';
import 'package:ajeer/ui/screens/no_internet_connection.dart';
import 'package:ajeer/ui/screens/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'AppRouter.dart';
import 'NewDesign/plans.dart';
import 'bussiness/change_language_provider.dart';
import 'bussiness/connectivity_provider.dart';
import 'bussiness/drawer_provider.dart';
import 'bussiness/firebase_notification_service.dart';
import 'bussiness/tabs_provider.dart';
import 'constants/get_storage.dart';
import 'constants/my_colors.dart';
import 'controllers/common/address_provider.dart';
import 'controllers/general/on_boarding_provider.dart';
import 'controllers/general/review_pass_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'ajeer',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  try {
    FirebaseNotificationService firebaseNotificationService =
    FirebaseNotificationService();
    await firebaseNotificationService.initializeNotifications();
  } catch (e) {
    print("Error initializing notifications: $e");
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await GetStorage.init();

  final String currentLang = storage.read('language') ?? 'ar';

  if (['ar', 'en'].contains(currentLang)) {
    await translator.init(
      localeType: LocalizationDefaultType.device,
      languagesList: <String>['ar', 'en'],
      assetsDirectory: 'assets/translate/',
      language: currentLang,
    );
  } else {
    await translator.init(
      localeType: LocalizationDefaultType.device,
      languagesList: <String>['ar', 'en'],
      assetsDirectory: 'assets/translate/',
      language: 'ar',
    );
  }
  //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(
    Phoenix(
      child: LocalizedApp(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => Auth()),
            ChangeNotifierProvider(create: (_) => TabsProvider()),
            ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
            ChangeNotifierProvider(create: (_) => AboutApp()),
            ChangeNotifierProxyProvider<Auth, CustomerHomeProvider>(
              create: (context) => CustomerHomeProvider(null),
              update: (BuildContext context, Auth authProvider,
                  CustomerHomeProvider? homeProvider) =>
                  CustomerHomeProvider(authProvider.accessToken),
            ),
            ChangeNotifierProxyProvider<Auth, CustomerOrdersProvider>(
              create: (context) => CustomerOrdersProvider(null),
              update: (BuildContext context, Auth authProvider,
                  CustomerOrdersProvider? ordersProvider) =>
                  CustomerOrdersProvider(authProvider.accessToken),
            ),
            ChangeNotifierProxyProvider<Auth, ProviderHomePageProvider>(
              create: (context) => ProviderHomePageProvider(null),
              update: (BuildContext context, Auth authProvider,
                  ProviderHomePageProvider? providerHomeProvider) =>
                  ProviderHomePageProvider(authProvider.accessToken),
            ),
            ChangeNotifierProxyProvider<Auth, NotificationsProvider>(
              create: (context) => NotificationsProvider(null),
              update: (BuildContext context, Auth authProvider,
                  NotificationsProvider? providerNotificationsProvider) =>
                  NotificationsProvider(authProvider.accessToken),
            ),
            ChangeNotifierProxyProvider<Auth, ProviderOffersProvider>(
              create: (context) => ProviderOffersProvider(null),
              update: (BuildContext context, Auth authProvider,
                  ProviderOffersProvider? providerServicesProvider) =>
                  ProviderOffersProvider(authProvider.accessToken),
            ),
            ChangeNotifierProxyProvider<Auth, ProviderServicesProvider>(
              create: (context) => ProviderServicesProvider(null),
              update: (BuildContext context, Auth authProvider,
                  ProviderServicesProvider? providerServicesProvider) =>
                  ProviderServicesProvider(authProvider.accessToken),
            ),
            ChangeNotifierProvider(create: (_) => DrawerProvider()),
            ChangeNotifierProxyProvider<Auth, AddressProvider>(
              create: (context) => AddressProvider(null),
              update: (BuildContext context, Auth authProvider,
                  AddressProvider? addressProvider) =>
                  AddressProvider(authProvider.accessToken),
            ),
            ChangeNotifierProxyProvider<Auth, Chat>(
              create: (context) => Chat(null),
              update: (BuildContext context, Auth authProvider,
                  Chat? chatProvider) =>
                  Chat(authProvider.accessToken),
            ),
            ChangeNotifierProxyProvider<Auth, ProviderSubscriptions>(
              create: (context) => ProviderSubscriptions(null),
              update: (BuildContext context, Auth authProvider,
                  ProviderSubscriptions? providerSubscriptions) =>
                  ProviderSubscriptions(authProvider.accessToken),
            ),
            ChangeNotifierProvider(create: (_) => ReviewPass()),
          ],
          child: MyApp(
            appRouter: AppRouter(),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? get instance => _instance;
  static _MyAppState? _instance;
}

class _MyAppState extends State<MyApp> {
  late ConnectivityResult _connectivityResult = ConnectivityResult.wifi;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    MyApp._instance = this;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Builder(
          builder: (context) {
            var langProvider = Provider.of<LanguageProvider>(context);
            final isConnected =
                context.watch<ConnectivityProvider>().isConnected;

            print('Connection Status: ${_connectivityResult.toString()}');
            return NoInternetScreen(
              child: MaterialApp(
                navigatorKey: navigatorKey,
                title: "Ajeer",
                theme: ThemeData(
                  canvasColor: MyColors.MainGohan,
                  textTheme:
                  GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme),
                  useMaterial3: true,
                  inputDecorationTheme: const InputDecorationTheme(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: MyColors.MainBulma, width: 2.0),
                    ),
                    labelStyle: TextStyle(color: MyColors.MainBulma),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  pageTransitionsTheme: const PageTransitionsTheme(builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  }),
                  scaffoldBackgroundColor: Colors.white,
                ),
                builder: (context, child) {
                  return MediaQuery(
                    child: child!,
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.linear(1.0)),
                  );
                },
                debugShowCheckedModeBanner: false,
                locale: langProvider.locale,
                supportedLocales: translator.locals(),
                localizationsDelegates: translator.delegates,
                initialRoute: '/',
                routes: {
                  '/': (context) => Stack(
                    children: [
                      if (isConnected) SplashScreen(),
                      // TabsScreen(),
                      Container(),
                    ],
                  ),

                },
              ),
            );
          },
        );
      },
    );
  }
}



// import 'package:ajeer/controllers/common/auth_provider.dart';
// import 'package:ajeer/controllers/common/chat_provider.dart';
// import 'package:ajeer/controllers/common/notifications_provider.dart';
// import 'package:ajeer/controllers/customer/customer_orders_provider.dart';
// import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
// import 'package:ajeer/controllers/general/about_app_controller.dart';
// import 'package:ajeer/controllers/service_provider/provider_home_page_provider.dart';
// import 'package:ajeer/controllers/service_provider/provider_offers_provider.dart';
// import 'package:ajeer/controllers/service_provider/provider_services_provider.dart';
// import 'package:ajeer/controllers/service_provider/provider_subscriptions_provider.dart';
// import 'package:ajeer/firebase_options.dart';
// import 'package:ajeer/services/call_service.dart';
// import 'package:ajeer/ui/screens/call%20screens/receiver_call_screen.dart';
// import 'package:ajeer/ui/screens/no_internet_connection.dart';
// import 'package:ajeer/ui/screens/splash_screen.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// //import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// import 'AppRouter.dart';
// import 'bussiness/change_language_provider.dart';
// import 'bussiness/connectivity_provider.dart';
// import 'bussiness/drawer_provider.dart';
// import 'bussiness/firebase_notification_service.dart';
// import 'bussiness/tabs_provider.dart';
// import 'constants/get_storage.dart';
// import 'constants/my_colors.dart';
// import 'controllers/common/address_provider.dart';
// import 'controllers/general/on_boarding_provider.dart';
// import 'controllers/general/review_pass_provider.dart';
// import 'services/call_notification_service.dart';
//
// // إضافة معالجة الإشعارات في الخلفية
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // تأكد من تهيئة Firebase
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       name: 'ajeer',
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }
//
//   // print("Handling a background message: ${message.data}");
//   // print("Background message data: ${message.data}");
//
//       print("0sssss00");
//       print(message.notification!.body);
//       print(message.data);
//
//
//   if (message.data.isNotEmpty) {
//     // يمكنك هنا إضافة أي معالجة إضافية للإشعارات في الخلفية
//     print("Received call notification in background");
//     print("Channel Name: ${message.data}");
//     print("Caller Name: ${message.data['callerName']}");
//     print("Caller Type: ${message.data['caller_type']}");
//   }
// }
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // تعيين معالج الإشعارات في الخلفية
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       name: 'ajeer',
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }
//
//   try {
//     // إنشاء قناة الإشعارات
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description: 'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );
//
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     // طلب إذن الإشعارات
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseNotificationService firebaseNotificationService =
//         FirebaseNotificationService();
//     await firebaseNotificationService.initializeNotifications();
//
//     // Handle incoming messages when app is in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Received FCM message: ${message.data}");
//
//       // التحقق من نوع الإشعار
//       if (message.data['type'] == 'call') {
//         String channelName = message.data['channelName'] ?? '';
//         String callerName = message.data['callerName'] ?? '';
//         String callerImageUrl = message.data['callerImageUrl'] ?? '';
//         String callerType = message.data['caller_type'] ?? '';
//
//         if (navigatorKey.currentContext != null) {
//           // عرض شاشة المكالمة
//           showDialog(
//             context: navigatorKey.currentContext!,
//             barrierDismissible: false,
//             builder: (context) => ReceiverCallScreen(
//               channelName: channelName,
//               callerImageUrl: callerImageUrl,
//               callerName: callerName,
//               isRtl: true,
//             ),
//           );
//         }
//       }
//     });
//
//     // Handle notification tap when app is in background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Opened FCM message: ${message}");
//
//       if (message.data['type'] == 'call') {
//         String channelName = message.data['channelName'] ?? '';
//         String callerName = message.data['callerName'] ?? '';
//         String callerImageUrl = message.data['callerImageUrl'] ?? '';
//         String callerType = message.data['caller_type'] ?? '';
//
//         if (navigatorKey.currentContext != null) {
//           // عرض شاشة المكالمة
//           showDialog(
//             context: navigatorKey.currentContext!,
//             barrierDismissible: false,
//             builder: (context) => ReceiverCallScreen(
//               channelName: channelName,
//               callerImageUrl: callerImageUrl,
//               callerName: callerName,
//               isRtl: true,
//             ),
//           );
//         }
//       }
//     });
//   } catch (e) {
//     print("Error initializing notifications: $e");
//   }
//
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//
//   await GetStorage.init();
//
//   final String currentLang = storage.read('language') ?? 'ar';
//
//   if (['ar', 'en'].contains(currentLang)) {
//     await translator.init(
//       localeType: LocalizationDefaultType.device,
//       languagesList: <String>['ar', 'en'],
//       assetsDirectory: 'assets/translate/',
//       language: currentLang,
//     );
//   } else {
//     await translator.init(
//       localeType: LocalizationDefaultType.device,
//       languagesList: <String>['ar', 'en'],
//       assetsDirectory: 'assets/translate/',
//       language: 'ar',
//     );
//   }
//   //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//   runApp(
//     Phoenix(
//       child: LocalizedApp(
//         child: MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
//             ChangeNotifierProvider(create: (_) => LanguageProvider()),
//             ChangeNotifierProvider(create: (_) => Auth()),
//             ChangeNotifierProvider(create: (_) => TabsProvider()),
//             ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
//             ChangeNotifierProvider(create: (_) => AboutApp()),
//             ChangeNotifierProxyProvider<Auth, CustomerHomeProvider>(
//               create: (context) => CustomerHomeProvider(null),
//               update: (BuildContext context, Auth authProvider,
//                       CustomerHomeProvider? homeProvider) =>
//                   CustomerHomeProvider(authProvider.accessToken),
//             ),
//             ChangeNotifierProxyProvider<Auth, CustomerOrdersProvider>(
//               create: (context) => CustomerOrdersProvider(null),
//               update: (BuildContext context, Auth authProvider,
//                       CustomerOrdersProvider? ordersProvider) =>
//                   CustomerOrdersProvider(authProvider.accessToken),
//             ),
//             ChangeNotifierProxyProvider<Auth, ProviderHomePageProvider>(
//               create: (context) => ProviderHomePageProvider(null),
//               update: (BuildContext context, Auth authProvider,
//                       ProviderHomePageProvider? providerHomeProvider) =>
//                   ProviderHomePageProvider(authProvider.accessToken),
//             ),
//             ChangeNotifierProxyProvider<Auth, NotificationsProvider>(
//               create: (context) => NotificationsProvider(null),
//               update: (BuildContext context, Auth authProvider,
//                       NotificationsProvider? providerNotificationsProvider) =>
//                   NotificationsProvider(authProvider.accessToken),
//             ),
//             ChangeNotifierProxyProvider<Auth, ProviderOffersProvider>(
//               create: (context) => ProviderOffersProvider(null),
//               update: (BuildContext context, Auth authProvider,
//                       ProviderOffersProvider? providerServicesProvider) =>
//                   ProviderOffersProvider(authProvider.accessToken),
//             ),
//             ChangeNotifierProxyProvider<Auth, ProviderServicesProvider>(
//               create: (context) => ProviderServicesProvider(null),
//               update: (BuildContext context, Auth authProvider,
//                       ProviderServicesProvider? providerServicesProvider) =>
//                   ProviderServicesProvider(authProvider.accessToken),
//             ),
//             ChangeNotifierProvider(create: (_) => DrawerProvider()),
//             ChangeNotifierProxyProvider<Auth, AddressProvider>(
//               create: (context) => AddressProvider(null),
//               update: (BuildContext context, Auth authProvider,
//                       AddressProvider? addressProvider) =>
//                   AddressProvider(authProvider.accessToken),
//             ),
//             ChangeNotifierProxyProvider<Auth, Chat>(
//               create: (context) => Chat(null),
//               update: (BuildContext context, Auth authProvider,
//                       Chat? chatProvider) =>
//                   Chat(authProvider.accessToken),
//             ),
//             ChangeNotifierProxyProvider<Auth, ProviderSubscriptions>(
//               create: (context) => ProviderSubscriptions(null),
//               update: (BuildContext context, Auth authProvider,
//                       ProviderSubscriptions? providerSubscriptions) =>
//                   ProviderSubscriptions(authProvider.accessToken),
//             ),
//             ChangeNotifierProvider(create: (_) => ReviewPass()),
//           ],
//           child: MyApp(
//             appRouter: AppRouter(),
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   MyApp({super.key, required this.appRouter});
//
//   final AppRouter appRouter;
//
//   @override
//   State<MyApp> createState() => _MyAppState();
//
//   static _MyAppState? get instance => _instance;
//   static _MyAppState? _instance;
// }
//
// class _MyAppState extends State<MyApp> {
//   late ConnectivityResult _connectivityResult = ConnectivityResult.wifi;
//   OverlayEntry? _overlayEntry;
//
//   @override
//   void initState() {
//     super.initState();
//     MyApp._instance = this;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return Builder(
//           builder: (context) {
//             var langProvider = Provider.of<LanguageProvider>(context);
//             final isConnected =
//                 context.watch<ConnectivityProvider>().isConnected;
//
//             print('Connection Status: ${_connectivityResult.toString()}');
//             return NoInternetScreen(
//               child: MaterialApp(
//                 navigatorKey: navigatorKey,
//                 title: "Ajeer",
//                 theme: ThemeData(
//                   canvasColor: MyColors.MainGohan,
//                   textTheme:
//                       GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme),
//                   useMaterial3: true,
//                   inputDecorationTheme: const InputDecorationTheme(
//                     focusedBorder: OutlineInputBorder(
//                       borderSide:
//                           BorderSide(color: MyColors.MainBulma, width: 2.0),
//                     ),
//                     labelStyle: TextStyle(color: MyColors.MainBulma),
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                   pageTransitionsTheme: const PageTransitionsTheme(builders: {
//                     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//                     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//                   }),
//                   scaffoldBackgroundColor: Colors.white,
//                 ),
//                 builder: (context, child) {
//                   return MediaQuery(
//                     child: child!,
//                     data: MediaQuery.of(context)
//                         .copyWith(textScaler: TextScaler.linear(1.0)),
//                   );
//                 },
//                 debugShowCheckedModeBanner: false,
//                 locale: langProvider.locale,
//                 supportedLocales: translator.locals(),
//                 localizationsDelegates: translator.delegates,
//                 initialRoute: '/',
//                 routes: {
//                   '/': (context) => Stack(
//                         children: [
//                           if (isConnected) SplashScreen(),
//                           // TabsScreen(),
//                           Container(),
//                         ],
//                       ),
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
