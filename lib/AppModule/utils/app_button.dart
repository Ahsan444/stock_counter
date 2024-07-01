import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Fonts/AppDimensions.dart';
import 'Fonts/font_weights.dart';
import 'app_text.dart';
import 'constants.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? btnText;
  final bool isIcon;
  final Widget? iconWidget;
  final IconData? iconData;

  const AppButton(
      {super.key, this.onPressed, this.btnText, this.isIcon = false,this.iconWidget,this.iconData});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: isIcon ? 20.h : 30.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          AppText(
            text: btnText ?? 'Total Product',
            fontSize: AppDimension.fontSize16,
            color: Constants.whiteColor,
            fontWeight: FontWeights.medium,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: isIcon,
            child: iconWidget?? Column(
              children: [
                SizedBox(
                  height: 10.w,
                ),
                Icon(
                  iconData?? Icons.add_circle_rounded,
                  color: Constants.whiteColor,
                  size: 25.w,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AppButton1 extends StatelessWidget {
  final String btnText;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? textWidget;

  const AppButton1(
      {Key? key,
      required this.btnText,
      this.onPressed,
      this.height,
      this.width,
      this.color,
      this.textWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ,
     // width: width ?? 250.w,
      height: height,
     // height: height ?? 35.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(color ?? Constants.redColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: textWidget ??
            AppText(
              text: btnText,
              fontSize: AppDimension.fontSize18,
              fontWeight: FontWeights.bold,
              color: Constants.whiteColor,
            ),
      ),
    );
  }
}
