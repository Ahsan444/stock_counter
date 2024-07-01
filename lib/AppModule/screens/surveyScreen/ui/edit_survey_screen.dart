import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/utils/Fonts/font_weights.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';

import '../../../provider/edit_survey_provider.dart';
import '../../../provider/new_survey_provider.dart';
import '../../../utils/Fonts/AppDimensions.dart';
import '../../../utils/app_text.dart';
import '../../../utils/input_field.dart';
import '../../../utils/survey_detailtile_widget.dart';

class EditSurveyScreen extends StatefulWidget {
  final int? index;
  final String? surveyName;
  final Map<String, dynamic>? surveyDetailList;

  const EditSurveyScreen(
      {Key? key, this.index, this.surveyName, this.surveyDetailList})
      : super(key: key);

  @override
  State<EditSurveyScreen> createState() => _EditSurveyScreenState();
}

class _EditSurveyScreenState extends State<EditSurveyScreen> {
  late EditSurveyProvider editSurveyProvider;
  late NewSurveyProvider newSurveyProvider;

  @override
  void initState() {
    editSurveyProvider =
        Provider.of<EditSurveyProvider>(context, listen: false);
    newSurveyProvider = Provider.of<NewSurveyProvider>(context, listen: false);
    editSurveyProvider.surveyNameController.text = widget.surveyName!;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Edit Survey',
          color: Constants.whiteColor,
          fontWeight: FontWeights.semiBold,
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Constants.whiteColor),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.grid_view_rounded,
              color: Constants.whiteColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: GestureDetector(
        onTap: () {
          editSurveyProvider.surveyNameFocusNode.unfocus();
        },
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  InputField(
                    controller: editSurveyProvider.surveyNameController,
                    labelText: '',
                    hintText: widget.surveyName,
                    focusNode: editSurveyProvider.surveyNameFocusNode,
                    readOnly: true,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          child: AppText(
                            text: 'Products',
                            fontSize: AppDimension.fontSize16,
                            fontWeight: FontWeights.regular,
                            color: Constants.blackColor,
                          ),
                        ),
                        AppText(
                          text: 'Survey Details',
                          fontSize: AppDimension.fontSize16,
                          fontWeight: FontWeights.regular,
                          color: Constants.blackColor,
                        ),
                        Consumer<EditSurveyProvider>(
                          builder: (__, provider, _) {
                            return SizedBox(
                              child: ListView.builder(
                                itemCount: widget.surveyDetailList!.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return widget.surveyDetailList!.isEmpty ? const SizedBox.shrink() : SurveyDetailTileWidget(
                                    title: widget.surveyDetailList!.keys
                                        .elementAt(index),
                                    trailing:
                                        '${widget.surveyDetailList!.values.elementAt(index)}',
                                    onTap: () {
                                      provider.deleteEditSurveyDetail(index, widget.surveyDetailList!,);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }
}
