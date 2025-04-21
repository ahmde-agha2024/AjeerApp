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
