import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockcounter/AppModule/provider/survey_provider.dart';

import '../db/db_helper.dart';
import '../utils/Fonts/AppDimensions.dart';
import '../utils/Fonts/font_weights.dart';
import '../utils/app_text.dart';
import '../utils/constants.dart';
import 'home_provider.dart';
import 'new_survey_provider.dart';

class ProductProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List categoryList = [];
  List brandList = [];
  List segmentList = [];
  List productNameList = [];
  List deleteList = [];
  int currentMin = 0;
  int currentMax = 26;
  bool isLoading = false;
  late HomeProvider homeProvider;
  late SurveyProvider surveyProvider;
  late NewSurveyProvider newSurveyProvider;
  List tempProducts = [];
  DatabaseHelper dbHelper = DatabaseHelper();

  void initScroll(context) {
    emptyLists();
    //homeProvider = Provider.of<HomeProvider>(context, listen: false);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentMax < categoryList.length) {
          isLoading = true;
          currentMax += 26;
          currentMin += 26;
          notifyListeners();
          Future.delayed(const Duration(seconds: 1), () {
            isLoading = false;
            notifyListeners();
          });
        }
      }
    });
  }

  Future<void> getDataFromDb() async {

    Database? database = await dbHelper.db;
    database?.rawQuery('select * from products').then((productValue) {
      categoryList = productValue.map((e) => e['category']).toList();
      brandList = productValue.map((e) => e['brand']).toList();
      segmentList = productValue.map((e) => e['segment']).toList();
      productNameList =
          productValue.map((e) => e['productName']).toList();
      notifyListeners();
      // debugPrint('categoryList ---> $categoryList\n brandList ---> $brandList\n segmentList ---> $segmentList\n productNameList ---> $productNameList');
    });
  }
  void emptyLists(){
    categoryList.clear();
    brandList.clear();
    segmentList.clear();
    productNameList.clear();
  }

  Future<void> checkProductExists(int index,BuildContext context,var pName)async{
    surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
   var modelDetails = await surveyProvider.getAllSurvey(context);
    if(modelDetails.isEmpty){
      if(context.mounted){
        context.pop();
      }
      debugPrint('modelDetails is empty');
      return;
    }
   var surveyId = modelDetails.first.surveyId;
    if(surveyId==null || surveyId==0){
      debugPrint('surveyId is null');
    }
    else{
      var database = await dbHelper.db;
      //survey Table
      var survey = await database!.rawQuery('Select * from survey where surveyId = $surveyId');
      // get surveyDetails
      var details = await database.rawQuery('Select * from surveyDetail where surveyId = ${survey[0]['surveyId']}');

      for(var detail in details){
        tempProducts.add(await database.rawQuery('select * from products where productId = ${detail['productId']}'));
      }
      for(var product in tempProducts){
        if(product[0]['productName'] == pName) {
          if(context.mounted){
            Constants.snackBar(context, 'Product already exists in survey');
            context.pop();
          }
          debugPrint('product exists');
          // debugPrint('product name ---> ${product[0]['productName']}');
          return;
        }
      }
      //delete the category
      await database.delete('products',where: 'productName = ?',whereArgs: [pName]).then((value) {
        categoryList.removeAt(index);
        brandList.removeAt(index);
        segmentList.removeAt(index);
        productNameList.removeAt(index);
        notifyListeners();
        if(context.mounted){
          Navigator.of(context).pop();
        }
      });
      debugPrint('product does not exists');
    }

  }
  void showAlertDialog(
      BuildContext context, VoidCallback onTap) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const AppText(
            text: 'Are you sure you want to delete this product',
            softWrap: true,
            fontSize: AppDimension.fontSize16,
            fontWeight: FontWeights.regular,
          ),
          actions: [
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return provider.isLoading
                    ? Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      color: Constants.darkGreyColor,
                    ),
                  ),
                )
                    : TextButton(
                  onPressed: onTap,
                  child: const AppText(text: 'Yes'),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const AppText(text: 'No'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
