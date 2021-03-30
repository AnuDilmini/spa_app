import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/pages/app_language.dart';
import 'package:violet_app/pages/bottom_nav.dart';
import 'package:violet_app/pages/change_language.dart';
import 'package:violet_app/pages/home.dart';
import 'package:violet_app/pages/info_service.dart';
import 'package:violet_app/pages/location.dart';
import 'package:violet_app/pages/order_complete.dart';
import 'package:violet_app/pages/order_history.dart';
import 'package:violet_app/pages/orders.dart';
import 'package:violet_app/pages/payment.dart';
import 'package:violet_app/pages/profile.dart';
import 'package:violet_app/pages/select_time_date.dart';
import 'package:violet_app/pages/service_find.dart';
import 'package:violet_app/pages/setting.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:violet_app/style/palette.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc/get_companyDetails_bloc.dart';
import 'enums/connectivity_status.dart';
import 'notifiers/connectivity_service.dart';
import 'notifiers/dark_theme_provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(

    EasyLocalization(
        supportedLocales: [Locale('en', 'US'),Locale('ar', '')],
        path: 'lang', // <-- change patch to your
        fallbackLocale: Locale('en', 'US'),
        startLocale: Locale('en', 'US'),
        child: MyApp(appLanguage: appLanguage)
    ),

  );
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  MyApp({this.appLanguage});
  @override
  _MyAppState createState() => _MyAppState(appLanguage: appLanguage);
}

class  _MyAppState extends State<MyApp> {
  final AppLanguage appLanguage;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  CompanyDetailsDataProvider companyDetailsDataProvider = new CompanyDetailsDataProvider();
  final Connectivity _connectivity = Connectivity();

  _MyAppState({this.appLanguage});


  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.devFestPreferences.getTheme();
  }


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CompanyDetailsDataProvider>(
              create: (_) => companyDetailsDataProvider),
          ChangeNotifierProvider<DarkThemeProvider>(
            create: (_) => themeChangeProvider,
          ),
          ChangeNotifierProvider<AppLanguage>(
          create: (_) => appLanguage,
          ),
          StreamProvider<ConnectivityStatus>(
          create: (context) =>
          ConnectivityService().connectionStatusController.stream,
          ),
        ],

        child: Consumer3<DarkThemeProvider, AppLanguage, CompanyDetailsDataProvider>(
          builder: (context, themeChangeProvider,appLanguage,companyDetailsDataProvider, Widget child) {
                return MaterialApp(
        title: 'Flutter Demo',
          theme: Palette.themeData(themeChangeProvider.darkTheme, context),
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
                 home: HomePage()
    );
      }
    )
    );
  }
}


