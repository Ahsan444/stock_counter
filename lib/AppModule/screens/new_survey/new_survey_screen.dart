import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/provider/new_survey_provider.dart';
import 'package:stockcounter/AppModule/screens/new_survey/widgets/bottom_tilewidget.dart';
import 'package:stockcounter/AppModule/screens/new_survey/widgets/counter_inputfield_widget.dart';
import 'package:stockcounter/AppModule/utils/Fonts/AppDimensions.dart';
import 'package:stockcounter/AppModule/utils/Fonts/font_weights.dart';
import 'package:stockcounter/AppModule/utils/app_button.dart';
import 'package:stockcounter/AppModule/utils/app_text.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';
import 'package:stockcounter/AppModule/widgets/icon_btn_widget.dart';

import '../../utils/input_field.dart';
import '../../utils/survey_detailtile_widget.dart';

class NewSurveyScreen extends StatefulWidget {
  final int? index, surveyId;
  final String? surveyName;
  final bool isEdit;

  const NewSurveyScreen(
      {Key? key,
      this.index,
      this.surveyName,
      this.isEdit = false,
      this.surveyId})
      : super(key: key);

  @override
  State<NewSurveyScreen> createState() => _NewSurveyScreenState();
}

class _NewSurveyScreenState extends State<NewSurveyScreen> {
  late NewSurveyProvider newSurveyProvider;
  bool isButtonDisabled = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    newSurveyProvider = Provider.of<NewSurveyProvider>(context, listen: false);
    newSurveyProvider.counterController.text = '1';
    newSurveyProvider.clearLists();
    Future.wait(
      [
        newSurveyProvider.getUniqueCategories(),
      ],
    );
    if (widget.isEdit) {
      newSurveyProvider.editQuantityList.clear();
      newSurveyProvider.editProductNameList.clear();
      log('------ edit Survey ------ ');
      Future.wait(
          [newSurveyProvider.getEditSurveyDetails(widget.surveyId ?? 0)]);
    } else {
      log('------ new survey ------');
      newSurveyProvider.surveyNameController.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: AppText(
          text: widget.isEdit ? "Edit Survey" : 'New Survey',
          color: Constants.whiteColor,
          fontWeight: FontWeights.medium,
          fontSize: AppDimension.fontSize18,
        ),
        iconTheme: IconThemeData(
          color: Constants.whiteColor,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.isEdit
                  ? IconButton(
                      onPressed: () {
                        //export survey to excel
                        newSurveyProvider.exportSurveyToExcelIndex(
                            widget.surveyId!, context);
                      },
                      icon: Image.asset(
                        Constants.excelIcon,
                        scale: 2,
                        width: size.height * 0.035,
                      ),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: IconButton(
                  onPressed: () {
                    newSurveyProvider.changeGrid();
                  },
                  icon: Icon(
                    Icons.grid_view_rounded,
                    color: Constants.whiteColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<NewSurveyProvider>(
              builder: (__, pr, _) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (pr.focusNodeCounter.hasFocus) {
                        pr.focusNodeCounter.unfocus();
                      } else if (pr.focusNodeSName.hasFocus) {
                        pr.focusNodeSName.unfocus();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          pr.isGrid
                              ? Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(2.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.05),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(5.w),
                                  margin: EdgeInsets.only(bottom: 10.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //counter
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconBtnWidget(
                                            onTap: () {
                                              newSurveyProvider
                                                  .counterDecrement();
                                            },
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: CounterInputFieldWidget(
                                              controller: newSurveyProvider
                                                  .counterController,
                                              focusNode: pr.focusNodeCounter,
                                              onChanged: (val) {
                                                //restricting user to enter , . - + e E
                                                if (val.isEmpty) {
                                                  newSurveyProvider
                                                      .counterController
                                                      .text = '0';
                                                } else if (val.contains(',') ||
                                                    val.contains('-') ||
                                                    val.contains('+') ||
                                                    val.contains('e') ||
                                                    val.contains('E')) {
                                                  newSurveyProvider
                                                          .counterController
                                                          .text =
                                                      newSurveyProvider
                                                          .counterController
                                                          .text
                                                          .substring(
                                                              0,
                                                              newSurveyProvider
                                                                      .counterController
                                                                      .text
                                                                      .length - 1);
                                                }
                                              },
                                            ),
                                          ),
                                          IconBtnWidget(
                                            onTap: () {
                                              newSurveyProvider.counterIncrement();
                                            },
                                            icon: Icons.add,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.w),
                                        child: const Align(
                                          alignment: Alignment.topCenter,
                                          child: AppText(
                                            text: 'Categories',
                                            fontWeight: FontWeights.regular,
                                            fontSize: AppDimension.fontSize16,
                                          ),
                                        ),
                                      ),
                                      //categories
                                      Consumer<NewSurveyProvider>(
                                        builder: (__, prv, _) {
                                          return prv.categoriesList.isEmpty
                                              ? const SizedBox.shrink()
                                              : Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Wrap(
                                                    alignment: WrapAlignment.start,
                                                    direction: Axis.horizontal,
                                                    runSpacing: 10.w,
                                                    children: List.generate(prv.categoriesList.length, (index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(right: 8.0),
                                                        child: AppButton1(
                                                          btnText: '',
                                                          onPressed: () async {
                                                            prv.categoriesBoolList[
                                                                    index] =
                                                                !prv.categoriesBoolList[
                                                                    index];
                                                            await prv
                                                                .getUniqueBrand(
                                                                    index,
                                                                    prv.categoriesBoolList[
                                                                        index]);
                                                          },
                                                          color: prv.categoriesBoolList[
                                                                  index]
                                                              ? Constants
                                                                  .greenColor
                                                              : Constants
                                                                  .darkGreyColor,
                                                          textWidget: AppText(
                                                            text:
                                                                prv.categoriesList[
                                                                    index],
                                                            color: Constants
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeights
                                                                    .regular,
                                                            fontSize:
                                                                AppDimension
                                                                    .fontSize14,
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                );
                                        },
                                      ),
                                      //brand
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 25.w, bottom: 20.w),
                                        child: const Align(
                                          alignment: Alignment.topCenter,
                                          child: AppText(
                                            text: 'Brands',
                                            fontWeight: FontWeights.regular,
                                            fontSize: AppDimension.fontSize16,
                                          ),
                                        ),
                                      ),
                                      Consumer<NewSurveyProvider>(
                                        builder: (__, prvB, _) {
                                          return prvB.brandList.isEmpty
                                              ? const SizedBox.shrink()
                                              : Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Wrap(
                                                    alignment: WrapAlignment.start,
                                                    direction: Axis.horizontal,
                                                    runSpacing: 10.w,
                                                    children: List.generate(
                                                        prvB.brandList.length,
                                                        (index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: AppButton1(
                                                          btnText: '',
                                                          onPressed: () async {
                                                            prvB.brandBoolList[
                                                                index] = !prvB
                                                                    .brandBoolList[
                                                                index];
                                                            await prvB
                                                                .getUniqueSegment(
                                                                    index,
                                                                    prvB.brandBoolList[
                                                                        index]);
                                                          },
                                                          color: prvB.brandBoolList[
                                                                  index]
                                                              ? Constants
                                                                  .lightPeachColor
                                                              : Constants
                                                                  .darkGreyColor,
                                                          textWidget: AppText(
                                                            text:
                                                                prvB.brandList[
                                                                    index],
                                                            color: Constants
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeights
                                                                    .regular,
                                                            fontSize:
                                                                AppDimension
                                                                    .fontSize14,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                );
                                        },
                                      ),
                                      //segment
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.w),
                                        child: const Align(
                                          alignment: Alignment.topCenter,
                                          child: AppText(
                                            text: 'Segments',
                                            fontWeight: FontWeights.regular,
                                            fontSize: AppDimension.fontSize16,
                                          ),
                                        ),
                                      ),
                                      Consumer<NewSurveyProvider>(
                                        builder: (__, prv, _) {
                                          return prv.segmentList.isEmpty
                                              ? const SizedBox.shrink()
                                              : Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Wrap(
                                                    alignment: WrapAlignment.start,
                                                    direction: Axis.horizontal,
                                                    runSpacing: 0,
                                                    children: List.generate(
                                                        prv.segmentList.length,
                                                        (index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0,
                                                                bottom: 0.0),
                                                        child: AppButton1(
                                                          btnText: '',
                                                          onPressed: () async {
                                                            prv.segmentBoolList[
                                                                    index] =
                                                                !prv.segmentBoolList[
                                                                    index];
                                                            await prv.getUniqueProduct(
                                                                index,
                                                                prv.segmentBoolList[
                                                                    index],
                                                                segmentName:
                                                                    prv.segmentList[
                                                                        index]);
                                                          },
                                                          color: prv.segmentBoolList[
                                                                  index]
                                                              ? Constants
                                                                  .purpleColor
                                                              : Constants
                                                                  .darkGreyColor,
                                                          textWidget: AppText(
                                                            text:
                                                                prv.segmentList[
                                                                    index],
                                                            color: Constants
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeights
                                                                    .regular,
                                                            fontSize:
                                                                AppDimension
                                                                    .fontSize14,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          //survey name textField
                          Consumer<NewSurveyProvider>(
                            builder: (context, provider, child) {
                              return Container(
                                // height: 50.h,
                                padding: EdgeInsets.symmetric(vertical: 10.w),
                                child: InputField(
                                  controller: provider.surveyNameController,
                                  focusNode: provider.focusNodeSName,
                                  /*validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter Survey Name';
                                    }
                                    return null;
                                  },*/
                                  readOnly: widget.isEdit ? true : false,
                                ),
                              );
                            },
                          ),

                          //products
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
                                Consumer<NewSurveyProvider>(
                                  builder: (context, prv, _) {
                                    return prv.productItemModelList.isEmpty
                                        ? const SizedBox.shrink()
                                        : Align(
                                            alignment: Alignment.centerLeft,
                                            child: ExpansionPanelList(
                                              dividerColor: Constants.greyColor,
                                              materialGapSize: 10.w,
                                              expandedHeaderPadding: EdgeInsets.zero,
                                              expansionCallback: (int index, bool isExpanded) {
                                                prv.expandTileValue(index, isExpanded);
                                              },
                                              elevation: 3,
                                              children: prv.productItemModelList.map<ExpansionPanel>(
                                                      (ItemModel item) {
                                                return ExpansionPanel(
                                                  backgroundColor: Constants.whiteColor,
                                                  headerBuilder: (BuildContext context, bool isExpanded) {
                                                    return ListTile(
                                                      title: AppText(text: item.headerValue),
                                                    );
                                                  },
                                                  canTapOnHeader: true,
                                                  body: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Wrap(
                                                      alignment: WrapAlignment.start,
                                                      direction: Axis.horizontal,
                                                      runSpacing: 0,
                                                      children: List.generate(item.products.length, (index) {
                                                        return Padding( padding: const EdgeInsets.only(
                                                              right: 8.0,
                                                              bottom: 0.0,
                                                              left: 0.0),
                                                          child: ElevatedButton(
                                                            onPressed:prv.isMultiTap ? (){
                                                              debugPrint('-----------waitt----------');
                                                            }: () {
                                                              prv.productTrueList.add(item.products[index]);
                                                              prv.addSurveyDetail(index, item.products[index]);
                                                              // prv.addSurveyDetail(index, prv.productNameList[index]);
                                                              //  prv.productNameBoolList[index] = true;
                                                            },
                                                            onLongPress: () {
                                                              for(var i=0; i< prv.surveyDetailList.length; i++){
                                                                if(prv.surveyDetailList[i] == item.products[index]){
                                                                  debugPrint('counter is ${prv.sDetailCounter[i]}');
                                                                  prv.productCountController.text = '${prv.sDetailCounter[i]}';
                                                                  prv.count1 = prv.sDetailCounter[i];
                                                                }
                                                              }
                                                              prv.count1 ?? (prv.productCountController.text = '0');
                                                              showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                      AppText(text: '${item.products[index]}'),
                                                                      content:
                                                                      Container(
                                                                        height: 40.h,
                                                                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                        child: TextFormField(
                                                                          controller: prv.productCountController,
                                                                          keyboardType: TextInputType.number,
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(color: Constants.blackColor),
                                                                          decoration: InputDecoration(
                                                                            hintText: '0',
                                                                            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(8.r),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      contentPadding:
                                                                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
                                                                      actions: [
                                                                        SizedBox(
                                                                          width: double.infinity,
                                                                          child: ElevatedButton(
                                                                            onPressed: () {
                                                                              debugPrint('---> ${prv.count1}||\n ${prv.productCountController.text}');
                                                                              if(prv.productCountController.text.isEmpty || int.parse(prv.productCountController.text) == prv.count1){
                                                                                debugPrint('empty or number is same');
                                                                                prv.productCountController.clear();
                                                                                context.pop();
                                                                                return;
                                                                              }
                                                                              else{
                                                                                int count = int.tryParse(prv.productCountController.text.trim()) ?? 0;
                                                                                prv.addSurveyDetail(index, item.products[index], count: count);
                                                                                count == 0 ? false : prv.productTrueList.add(item.products[index]);
                                                                                prv.productCountController.clear();
                                                                                context.pop();
                                                                              }
                                                                            },
                                                                            style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.blueAccent,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(8.r),
                                                                              ),
                                                                            ),
                                                                            child: AppText(text: 'Set Quantity', color: Constants.whiteColor),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: prv.productTrueList.contains(item.products[index])
                                                                  ? Constants.greenColor
                                                                  : Constants.darkGreyColor,
                                                              //Constants.darkGreyColor,
                                                              padding: EdgeInsets.zero,
                                                              shape: RoundedRectangleBorder(borderRadius:
                                                                BorderRadius.circular(8.r),
                                                              ),
                                                            ),
                                                            child:
                                                            Padding(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                                                              child: SizedBox(
                                                                child: AppText(
                                                                  text: '${item.products[index]}',
                                                                  color: Constants.whiteColor,
                                                                  softWrap: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                  isExpanded: item.isExpanded,
                                                );
                                              }).toList(),
                                            ),
                                          );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.w),
                                  child: AppText(
                                    text: 'Survey Details',
                                    fontSize: AppDimension.fontSize16,
                                    fontWeight: FontWeights.regular,
                                    color: Constants.blackColor,
                                  ),
                                ),
                                //edit Survey
                                Consumer<NewSurveyProvider>(
                                  builder: (__, provider, _) {
                                    return SizedBox(
                                      child: ListView.builder(
                                          itemCount: provider.surveyDetailList.length,
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return provider.surveyDetailList.isEmpty
                                                ? const SizedBox.shrink()
                                                : SurveyDetailTileWidget(
                                                    title: provider.surveyDetailList[index],
                                                    onTap: () {
                                                      provider.removeSurveyDetail1(index);
                                                      //provider.removeSurveyDetail(index);
                                                    },
                                                    trailing: '${provider.sDetailCounter[index]}',
                                                  );
                                          }),
                                    );
                                  },
                                ),
                                widget.isEdit
                                    ? Consumer<NewSurveyProvider>(
                                        builder: (__, provider, _) {
                                          return SizedBox(
                                            child: ListView.builder(
                                              itemCount:
                                                  provider.tempProductts.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return provider.editQuantityList
                                                        .isEmpty
                                                    ? const SizedBox.shrink()
                                                    : SurveyDetailTileWidget(
                                                        title:
                                                            '${provider.tempProductts[index][0]['productName']}',
                                                        trailing:
                                                            provider.editQuantityList[
                                                                    index] ??
                                                                0,
                                                        onTap: () {
                                                          provider
                                                              .deleteFromEditProduct(
                                                                  index);
                                                        },
                                                      );
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          //add survey button
                          Consumer<NewSurveyProvider>(
                            builder: (context, provider, _) {
                              return AppButton1(
                                btnText: '',
                                onPressed: isButtonDisabled ? null : ()async {
                                  if (isButtonDisabled) return;
                                        if (provider.surveyNameController.text.isNotEmpty) {
                                          if (provider.surveyDetailList.isEmpty) {
                                            Constants.appSnackBar(
                                                'Error', 'Please enter survey details', context);
                                          } else {
                                            setState(() {
                                              isButtonDisabled = true;
                                            });
                                            try {
                                              if (widget.isEdit) {
                                                await provider.saveSurveyDetailToDb(context, isEdit: true);
                                              } else {
                                                await provider.saveSurveyDetailToDb(context);
                                              }
                                            } finally {
                                              setState(() {
                                                isButtonDisabled = false;
                                              });
                                            }
                                          }
                                        } else {
                                          Constants.appSnackBar('Error', 'Please enter survey name', context);
                                          debugPrint('name is empty');
                                        }
                                      },
                                color: Constants.darkGreyColor,
                                height: 40.h,
                                textWidget: AppText(
                                  text: 'Add Surveys',
                                  color: Constants.whiteColor,
                                  fontWeight: FontWeights.medium,
                                  fontSize: AppDimension.fontSize14,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            //bottom tile
            Consumer<NewSurveyProvider>(builder: (__, pro, _) {
              return BottomTile(
                text1: pro.productName == ''
                    ? '(0)'
                    : '${pro.productName}(${newSurveyProvider.counterController.text})',
                text2: '(${pro.detialCounter})',
              );
            }),
          ],
        ),
      ),
    );
  }
}

/*
SurveyDetailTileWidget(
                                            title: widget.surveyDetailList!.keys
                                                .elementAt(index),
                                            trailing:
                                            '${widget.surveyDetailList!.values.elementAt(index)}',
                                            onTap: () {
                                              provider.deleteEditSurveyDetail(index, widget.surveyDetailList!,);
                                            },
                                          );
 */
/* if(widget.isEdit== true  && pr.surveyDetailList.isEmpty){
                              Constants.appSnackBar('Error', 'Already saved...', context);
                              }
                               else if(pr.surveyNameController.text.isEmpty || pr.surveyDetailList.isEmpty){
                                Constants.appSnackBar('Error', 'Something went wrong', context);
                              }
                               else if(widget.isEdit== true  && pr.surveyDetailList.isNotEmpty){
                                 //save after edit
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: AppText(text:'save after edit under process'),
                                    backgroundColor: Colors.yellowAccent,
                                  ),
                                );
                               }
                              else{
                                 newSurveyProvider.saveSurveyDetailToDb(context);
                              }*/
