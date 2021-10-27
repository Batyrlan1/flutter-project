import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:Tau/Sign/Sign.dart';

class Startpage extends StatelessWidget {
  const Startpage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(
          "assets/logo.png",
        ),
        splashIconSize: 80,
        nextScreen: SignPage(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
