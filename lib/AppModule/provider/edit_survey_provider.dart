import 'package:flutter/material.dart';

import '../db/db_helper.dart';

class EditSurveyProvider extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> surveyDetailList = [];
  final TextEditingController surveyNameController = TextEditingController();
  final FocusNode surveyNameFocusNode = FocusNode();

  void deleteEditSurveyDetail(int index,Map<String, dynamic> surveyDetailList) {
    // Check if the index is within the bounds of the list
    if (index >= 0 && index < surveyDetailList.length) {
      // Convert the map keys to a list to access the key to be removed
      List<String> keys = surveyDetailList.keys.toList();

      // Remove the key at the specified index
      String keyToRemove = keys[index];
      surveyDetailList.remove(keyToRemove);
      notifyListeners();
    } else {
      debugPrint('Index out of bounds');
    }
  }

}