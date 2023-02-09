import 'package:flutter/material.dart';

class CustomAppBar{
  static AppBar buildDefaultAppBar(BuildContext context,
    {
      bool hasOnBackPress = false,
      Function()? logout,
      String title = "Weather Forecast"
    }){
    return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 32, width: 32,),
            Container(width: 12,),
            Text(title,
              // style: FontUtil.instance.appBarFont,
            ),
          ],
        ),
        actions: [
          if(hasOnBackPress) IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ))
          ),
          if(logout != null) IconButton(
              onPressed: logout,
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: const Icon(
                    Icons.logout,
                    size: 20,
                  ))
          )
        ],
    );
  }
}