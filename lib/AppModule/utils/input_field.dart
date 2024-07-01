import 'package:flutter/material.dart';

import 'Fonts/AppDimensions.dart';
import 'Fonts/font_weights.dart';
import 'constants.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? labelText,hintText;
  final void Function(String)? onChanged;
  final bool readOnly;
  final String? Function(String?)? validator;
  const InputField({Key? key,required this.controller,this.focusNode,this.labelText,this.onChanged,this.hintText,this.readOnly = false,this.validator}) : super(key: key);
//focusNodeSName
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      cursorColor: Colors.blueAccent,
      readOnly: readOnly,
      style: TextStyle(
        color: Constants.blackColor,
        fontSize: AppDimension.fontSize16,
        fontWeight: FontWeights.regular,
      ),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText??'Survey Name',
        hintText: hintText??'',
        labelStyle: TextStyle(
          color: Constants.darkGreyColor,
          fontSize: AppDimension.fontSize16,
          fontWeight: FontWeights.regular,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Constants.darkGreyColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Constants.redColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Constants.darkGreyColor,
          ),
        ),
      ),
    );
  }
}
