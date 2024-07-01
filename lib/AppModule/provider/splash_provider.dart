import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockcounter/AppModule/screens/test_screen.dart';

class SplashProvider extends ChangeNotifier{
  // late AnimationController controller;

  void moveToHomeScreen(BuildContext context){
  //  Navigator.push(context, MaterialPageRoute(builder: (context) => const TestScreen()));
    GoRouter.of(context).pushReplacement('/dashboardScreen',);
  }
}