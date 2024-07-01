import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stockcounter/AppModule/utils/Fonts/AppDimensions.dart';
import 'package:stockcounter/AppModule/utils/Fonts/font_weights.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';


class CounterInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  const CounterInputFieldWidget(
      {super.key,
        required this.controller,
        required this.focusNode,
        this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Constants.darkGreyColor.withOpacity(0.5),
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        cursorColor: Colors.blueAccent,
        focusNode: focusNode,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: TextStyle(
          color: Constants.blackColor,
          fontSize: AppDimension.fontSize18,
          fontWeight: FontWeights.regular,
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(5),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}