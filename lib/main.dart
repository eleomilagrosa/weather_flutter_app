import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:weather_flutter_app/constants/font_family.dart';
import 'package:weather_flutter_app/constants/routes.dart';
import 'package:weather_flutter_app/model/weather_forecast.dart';
import 'package:weather_flutter_app/view_model/app_locale.vm.dart';
import 'package:weather_flutter_app/views/screens/home/home_page.v.dart';
import 'package:weather_flutter_app/views/screens/landing/landing_page.v.dart';
import 'package:weather_flutter_app/views/screens/weather/weather_page.v.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await setPreferredOrientations();
  runApp(MyApp());
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppLocaleViewModel appLocaleViewModel = AppLocaleViewModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLocaleViewModel>(create: (_) => appLocaleViewModel),
      ],
      builder: (context, _){
        return MaterialApp(
            title: 'Flutter Weather App Demo',
            debugShowCheckedModeBanner: false,
            theme: FlexThemeData.light(
              fontFamily: AppFontFamily.inter,
              scheme: FlexScheme.indigo,
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 20,
              appBarOpacity: 0.95,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                blendOnColors: false,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
            ),
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.indigo,
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 15,
              appBarStyle: FlexAppBarStyle.background,
              appBarOpacity: 0.90,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 30,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
            ),
            initialRoute: AppRoutes.LANDING_PAGE,
            onGenerateRoute: (RouteSettings settings) {
              final arg = settings.arguments;
              switch (settings.name) {
                case AppRoutes.HOME_PAGE:
                  return PageTransition(child: const HomePageView(), type: PageTransitionType.rightToLeft);
                case AppRoutes.WEATHER_PAGE:
                  return MaterialPageRoute(builder: (_) => WeatherPageView((arg as Map)["cityName"], arg["forecast"] as WeatherForecast));
                case AppRoutes.LANDING_PAGE:
                default:
                 return PageTransition(child: const LandingPageView(), type: PageTransitionType.rightToLeft);
              }
            }
        );
      },
    );
  }
}

