
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_text.dart';

class Constants {
  //theme colors
  static Color redColor = const Color(0xffc4262f);
  static Color whiteColor = const Color(0xffffffff);
  static Color blackColor = const Color(0xff000000);
  static Color greyColor = const Color(0xffC5C5C5);
  static Color darkGreyColor = const Color(0xff5A5A5A);
  static Color greenColor = const Color(0xff21BE54);
  static Color purpleColor = const Color(0xff660066);
  static Color lightPeachColor = const Color(0xffeea782);
  static Color lightPurpleColor = const Color(0xff9B30FF);

  //images
  static const splashAnimation = 'assets/anim/splash_anim.json';
  static const excelIcon = 'assets/images/excel_icon2.png';

  //dialog
  static Flushbar appSnackBar(String? title,subtitle,BuildContext context,
      {Color? color}){
    return Flushbar(
      title: title?? "Hi there!",
      message: subtitle?? "Add your message here",
      duration:  const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color?? redColor,
    )..show(context);
  }
 static showPermissionDialog(BuildContext context) {
    if(context.mounted){
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const AppText(text:'Permission Required'),
          content: const AppText(text:'Please grant storage permission in app settings to proceed.',softWrap: true,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const AppText(text:'Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const AppText(text:'Open Settings'),
            ),
          ],
        ),
      );
    }
  }
 static void snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(text:message,color: whiteColor,),
        duration: const Duration(seconds: 1),
        backgroundColor: redColor,
      ),
    );
  }
}