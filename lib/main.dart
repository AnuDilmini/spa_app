import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:violet_app/pages/app_language.dart';
import 'package:violet_app/pages/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:violet_app/style/palette.dart';
import 'package:provider/provider.dart';
import 'bloc/get_companyDetails_bloc.dart';
import 'enums/connectivity_status.dart';
import 'notifiers/connectivity_service.dart';
import 'notifiers/dark_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'),Locale('ar', '')],
        path: 'lang', // <-- change patch to your
        fallbackLocale: Locale('en', 'US'),
        startLocale: Locale('en', 'US'),
        // startLocale: Locale('en', 'US'),
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
  VideoPlayerController _controller;
  bool isPlaying = true;

  _MyAppState({this.appLanguage});

  @override
  void initState() {
    super.initState();

    getCurrentAppTheme();
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(false);
        _controller.setVolume(0.0);
        _controller.play();
        _controller.addListener(() {

          if(!_controller.value.isPlaying){
            setState(() {
              isPlaying = false;
            });
          }else{
            setState(() {
              isPlaying = true;
            });
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.devFestPreferences.getTheme();
  }

  navigatoer(){
    return HomePage();
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
                title: 'Spa App',
                theme: Palette.themeData(themeChangeProvider.darkTheme, context),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: isPlaying ?
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: _controller.value.size?.width ?? 0,
                      height: _controller.value.size?.height ?? 0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ):
                HomePage(),
              );
            }
        )
    );
  }

}


