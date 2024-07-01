import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../provider/dashboard_provider.dart';
import '../provider/edit_survey_provider.dart';
import '../provider/home_provider.dart';
import '../provider/new_survey_provider.dart';
import '../provider/product_provider.dart';
import '../provider/splash_provider.dart';
import '../provider/survey_provider.dart';

class ProvidersList{
  static List<SingleChildWidget> providersList = [
    ChangeNotifierProvider(
      create: (_) => SplashProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => HomeProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => SurveyProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => NewSurveyProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => EditSurveyProvider(),
    ),
  ];
}