import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weather_flutter_app/constants/routes.dart';
import 'package:weather_flutter_app/utils/printWhenDebug.dart';
import 'package:weather_flutter_app/view_model/app_locale.vm.dart';
import 'package:weather_flutter_app/view_model/weather.vm.dart';
import 'package:weather_flutter_app/views/widgets/custom_app_bar.dart';
import 'package:weather_flutter_app/views/widgets/custom_button.dart';
import 'package:weather_flutter_app/views/widgets/custom_pop_up.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  late final AppLocaleViewModel  _appLocaleViewModel = Provider.of<AppLocaleViewModel>(context);
  late final WeatherViewModel  _weatherViewModel = WeatherViewModel( _appLocaleViewModel);
  final TextEditingController  _textEditingController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<WeatherViewModel>(create: (_) =>  _weatherViewModel),
        ],
      builder: (context,_){
        String githubUrl = "https://github.com/${_appLocaleViewModel.credentials?.user.nickname ?? ""}";
        return Scaffold(
          appBar: CustomAppBar.buildDefaultAppBar(context,
            logout: ()async{
              await popUpLogout();
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .7,
                  width: MediaQuery.of(context).size.width * .7,
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Card(
                        child: InkWell(
                          onTap: ()async{
                            if (await canLaunchUrlString(githubUrl)) {
                              launchUrlString(githubUrl);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${_appLocaleViewModel.credentials?.user.nickname ?? ""}"),
                                SizedBox(height: 6,),
                                Text(githubUrl),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28,),
                      TextField(
                        controller:  _textEditingController,
                        decoration: InputDecoration(
                          hintText: "Search City",
                          prefixIcon: const Icon(Icons.search),
                          errorText: errorMessage
                        ),
                      ),
                      const SizedBox(height: 24,),
                      Consumer<WeatherViewModel>(
                        builder: (context, provider, child) {
                            return PrimaryButton(
                              width: MediaQuery.of(context).size.width * .5,
                              text: "Display Weather",
                              isLoading:  _weatherViewModel.loadingWeatherForecast,
                              onPressed: ()async{
                                var isRedirected = await getWeatherForecastByCityName( _textEditingController.text);
                                if(isRedirected){
                                   _textEditingController.clear();
                                }
                                setState(() {});
                              }
                            );
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future popUpLogout()async{
    await CustomAlertDialog(
      "Are you sure you want to logout?",
      CustomAlertType.WARNING,
      buttonNeutral: ButtonBuilder(
        "Cancel", () {
        Navigator.pop(context);
      },
        ButtonType.link,
      ),
      buttonPositive: ButtonBuilder(
        "Logout", () async {
        await _appLocaleViewModel.logout();
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, AppRoutes.LANDING_PAGE);
      },
        ButtonType.secondary,
        // bgColor: ColorUtil.instance.secondary,
        // bgColor: Colors.black,
        textColor: Colors.black,
      ),
    ).show(context);
  }

  String? errorMessage;
  Future<bool> getWeatherForecastByCityName(String cityName)async{
    errorMessage = null;
    setState((){});
    try{
      var weatherForecast = await  _weatherViewModel.getWeatherForecastByCityName(cityName);
      if(weatherForecast != null){
        await Navigator.pushNamed(context, AppRoutes.WEATHER_PAGE,
            arguments: {
              "forecast": weatherForecast,
              "cityName": cityName,
            }
        );
        return true;
      }
    }catch(e,trace){
      if(e is DioError){
        errorMessage = e.response?.data["message"] ?? "";
        setState((){});
      }
      printWhenDebug([e,trace]);
    }
    return false;
  }

}
