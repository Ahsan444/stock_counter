import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stockcounter/AppModule/utils/app_text.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';


class SurveyDetailTileWidget extends StatelessWidget {
  final String? title, trailing;
  final VoidCallback? onTap;
  const SurveyDetailTileWidget({super.key,this.title,this.trailing,this.onTap});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: Constants.redColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: IconButton(
          onPressed: onTap,
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      title:  AppText(text: title??'Item1'),
      trailing: AppText(text:trailing?? '1'),
    );
  }
}