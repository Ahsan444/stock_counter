import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';

import '../db/db_helper.dart';
import '../model/survey_model.dart';
import 'new_survey_provider.dart';

class SurveyProvider extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper();
  late NewSurveyProvider newSurveyProvider;
  List<SurveyModel> surveysList = [];
  List productNameList = [];
  List quantityList = [];
  List surveyIdList = [];

  Future<List<SurveyModel>> getAllSurvey(BuildContext context) async {
    productNameList.clear();
    quantityList.clear();
    surveysList.clear();
    try {
      Database? database = await dbHelper.db;
      await database!.query('surveyDetail').then((value) async {
        surveyIdList = value.map((e) => e['surveyId']).toSet().toList();
        // debugPrint(' ----> surveyId <---- \n$surveyIdList');
        for (var i = 0; i < surveyIdList.length; i++) {
          await database.query('survey',
              where: 'surveyId = ?',
              whereArgs: [surveyIdList[i]]).then((surVal) {
            if (surVal.isNotEmpty) {
              var surveyData = surVal.first;
              SurveyModel survey = SurveyModel(
                surveyName: '${surveyData['surveyName']}',
                createdAt: '${surveyData['createdDate']}',
                surveyId: int.parse('${surveyData['surveyId']}'),
              );
              // Add the SurveyModel instance to the list
              surveysList.add(survey);
              notifyListeners();
            } else{
              debugPrint('survey is empty');
            }
            // debugPrint(' ----> Survey Name <---- \n${surVal.first['surveyName']}');
          }).onError((error, stackTrace) {
            debugPrint('error in getting AllSurvey ---> $error\n$stackTrace');
            Constants.snackBar(context,'error-01 in getting survey');
          });
        }
      });
      return surveysList;
    } catch (e, stackTrace) {
      if(context.mounted){
        Constants.snackBar(context,'error-02 in getting survey');
      }
      debugPrint('error in getting AllSurvey ---> $e\n$stackTrace');
      return [];
    }
  }
  Future<void> exportExcelMethod(BuildContext context,int surveyId,String surName)async{
    newSurveyProvider = Provider.of<NewSurveyProvider>(context, listen: false);
   await newSurveyProvider.exportSurveyToExcelIndex(surveyId,context,getSingleResult: true,surveyName: surName);
  }


/*  Future<void> getProducts() async {
    try {
      Database? database = await dbHelper.db;
      await database!.query('surveyDetail').then((surDetail) async{
         // List prodID = surDetail.map((e) => e['productId']).toSet().toList();
      });
    } catch (e, stackTrace) {
      debugPrint('error in getting Products ---> $e\n$stackTrace');
    }
  }*/
}

//old
/*
 Future<List<SurveyModel>> getAllSurvey() async {
    try {
      Database? database = await dbHelper.db;
      List<Map<String, dynamic>> surveysListMap =
      await database!.query('savedSurvey').then((value) {
        debugPrint('value in getting AllSurvey ---> $value');
        return value;
      });

      surveysList = surveysListMap
          .map((surveyMap) => SurveyModel(
        surveyName: surveyMap['surveyName'],
        surveyDetailMap: Map<String, dynamic>.from(
            json.decode(surveyMap['surveyDetailMap'])),
        createdAt: surveyMap['createdDate'],
      ))
          .toList();
      //createdDate
      debugPrint('survey one name: ---> ${surveysList.first.surveyName}');
      notifyListeners();
      return surveysList;
    } catch (e,stackTrace) {
      debugPrint('error in getting AllSurvey ---> $e\n$stackTrace');
      return [];
    }
  }
 */
