import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_flutter_app/view_model/auth.vm.dart';
import 'package:weather_flutter_app/views/widgets/custom_app_bar.dart';
import 'package:weather_flutter_app/views/widgets/custom_button.dart';

import '../../../constants/routes.dart';

class LandingPageView extends StatefulWidget {
  const LandingPageView({Key? key}) : super(key: key);

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  late final AuthViewModel  _authViewModel = Provider.of<AuthViewModel>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
        builder: (context, _, __){
          return Scaffold(
            appBar: CustomAppBar.buildDefaultAppBar(context),
            body: SafeArea(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .7,
                  width: MediaQuery.of(context).size.width * .7,
                  child: Column(
                    children: [
                      const Text("Welcome to the weather forecast mobile application. Please login with your Github user to use the application and view the weather in your city"),
                      const SizedBox(height: 24,),
                      PrimaryButton(
                        text: "Login",
                        onPressed: ()async{
                          var isSuccess = await _authViewModel.initiateLogin();
                          if(isSuccess){
                            Navigator.pushReplacementNamed(context, AppRoutes.HOME_PAGE);
                          }
                        },
                        isLoading: _authViewModel.loadingLogin,
                        width: MediaQuery.of(context).size.width * .4,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
