import 'package:go_router/go_router.dart';
import 'package:stockcounter/AppModule/screens/home_screen.dart';
import 'package:stockcounter/AppModule/screens/new_survey/new_survey_screen.dart';
import 'package:stockcounter/AppModule/screens/product_screen.dart';
import 'package:stockcounter/AppModule/screens/surveyScreen/ui/survey_screen.dart';

import '../screens/dashboard_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: false,
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'splashScreen',
        builder: (context, state) {
          return const SplashScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'dashboardScreen',
            name: 'dashboardScreen',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'homeScreen',
                name: 'homeScreen',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: 'productScreen',
                name: 'productScreen',
                builder: (context, state) => const ProductScreen(),
              ),
              GoRoute(
                path: 'surveyScreen',
                name: 'surveyScreen',
                //  redirect: (context, state) => '/editSurveyScreen',
                builder: (context, state) => const SurveyScreen(),
              ),
              GoRoute(
                path: 'newSurveyScreen',
                name: 'newSurveyScreen',
                builder: (context, state) {
                  Map<String, dynamic> data = state.extra as Map<String, dynamic>;
                  int index = data['index'] as int;
                  int surveyId = data['surveyId'] as int;
                  bool isEdit = data['isEdit'] as bool;
                  // SurveyProvider surveyProvider = Provider.of<SurveyProvider>(context);
                  // Uri uri = Uri.parse('${state.uri}');
                  // bool isEdit = uri.queryParameters['isEdit'] == 'true';
                  if (isEdit) {
                    return NewSurveyScreen(
                      index: index,
                      surveyId: surveyId,
                      isEdit: isEdit,
                    );
                  } else {
                    return const NewSurveyScreen();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRouter get routes => _router;
}
/*routes: [
                  GoRoute(
                    path: 'surveyDetailScreen/:index',
                    name: 'surveyDetailScreen',
                    builder: (context, state) {
                      int index = int.parse(state.pathParameters['index']!);
                      SurveyModel survey = Provider.of<SurveyProvider>(context).surveysList[index];
                      return EditSurveyScreen(
                          index: index,
                          surveyName: survey.surveyName,
                          surveyDetailList: survey.surveyDetailMap);
                    },
                  ),
                ],*/