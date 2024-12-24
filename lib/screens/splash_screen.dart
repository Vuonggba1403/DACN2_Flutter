import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:travelapp_flutter/screens/Authentication/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Center(
              child: LottieBuilder.asset(
                  "assets/Lottie/Animation - 1730554156084.json"),
            ),
          )
        ],
      ),
      nextScreen: const LoginScreen(),
      splashIconSize: 400,
      animationDuration: const Duration(seconds: 1), // 2 seconds
      splashTransition:
          SplashTransition.decoratedBoxTransition, //Hieu ung chuyen
      // backgroundColor: const Color.fromARGB(255, 104, 196, 246),
    );
  }
}
