import 'package:flutter/material.dart';
import 'package:stockcounter/AppModule/screens/home_screen.dart';
import 'package:stockcounter/AppModule/screens/product_screen.dart';
import 'package:stockcounter/AppModule/screens/surveyScreen/ui/survey_screen.dart';

class DashboardProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  final List _screenNameList = [
    'Home',
    'Product',
    'Survey',
  ];
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ProductScreen(),
    SurveyScreen(),
  ];
  void changeScreenName(int index, String name) {
    _screenNameList[index] = name;
  }

  List get screenNameList => _screenNameList;

  Widget get widgetOptions => _widgetOptions[_selectedIndex];

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    changeScreenName(value, _screenNameList[value]);
    notifyListeners();
  }
}
