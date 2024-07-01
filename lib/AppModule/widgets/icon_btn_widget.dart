import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';


class IconBtnWidget extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;

  const IconBtnWidget({super.key, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.w,
      decoration:
      const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon ?? Icons.remove,
          color: Constants.whiteColor,
        ),
      ),
    );
  }
}