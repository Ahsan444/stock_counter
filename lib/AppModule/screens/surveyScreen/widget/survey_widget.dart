import 'package:flutter/material.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';

import '../../../utils/Fonts/AppDimensions.dart';
import '../../../utils/app_text.dart';


class SurveyWidget extends StatelessWidget {
  final String? surveyName, surveyDate;
  final VoidCallback? onTap,onTapExcel;


  const SurveyWidget({super.key, this.surveyName, this.surveyDate,this.onTap,this.onTapExcel});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return ListTile(
      onTap: onTap,
      title: AppText(
        text: surveyName ?? 'surveyName',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: surveyDate ?? 'surveyDate',
            fontSize: AppDimension.fontSize14,
            color: Colors.grey,
          ),
          Divider(
            color: Colors.grey.shade200,
          )
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
        onPressed: onTapExcel,
        icon: Image.asset(Constants.excelIcon,scale: 2,width: size.height * 0.035,),
      ) ,
    );
  }
}