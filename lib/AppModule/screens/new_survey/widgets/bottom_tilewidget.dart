import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stockcounter/AppModule/utils/Fonts/AppDimensions.dart';
import 'package:stockcounter/AppModule/utils/Fonts/font_weights.dart';
import 'package:stockcounter/AppModule/utils/app_text.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';


class BottomTile extends StatelessWidget {
  final String? text1, text2;

  const BottomTile({super.key, this.text1, this.text2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            text: text1 ?? '(0)',
            fontSize: AppDimension.fontSize16,
            fontWeight: FontWeights.medium,
            color: Constants.whiteColor,
          ),
          AppText(
            text: ' - ',
            fontSize: AppDimension.fontSize16,
            fontWeight: FontWeights.medium,
            color: Constants.whiteColor,
          ),
          AppText(
            text: text2 ?? '(0)',
            fontSize: AppDimension.fontSize16,
            fontWeight: FontWeights.medium,
            color: Constants.whiteColor,
          )
        ],
      ),
    );
  }
}