import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/provider/splash_provider.dart';

import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashProvider splashProvider;

  @override
  void initState() {
    splashProvider = Provider.of<SplashProvider>(context, listen: false);
    Timer(
      const Duration(seconds: 3),
      () => splashProvider.moveToHomeScreen(context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          Constants.splashAnimation,
          fit: BoxFit.cover,
          height: 150.w,
        ),
      ),
    );
  }
}
