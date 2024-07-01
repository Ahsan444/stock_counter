import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/provider/survey_provider.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';

import '../widget/survey_widget.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  late SurveyProvider surveyProvider;

  @override
  void initState() {
    surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    Future.wait([surveyProvider.getAllSurvey(context)]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('newSurveyScreen',
            extra: {
              'index': 0,
              'surveyId': 0,
              'isEdit': false,
            },);
          /*context.pushNamed(
            'newSurveyScreen',
            pathParameters: {
              'index': '0',
            },
            queryParameters: {
              'isEdit': 'false',
            },
          );*/
          // context.go(context.namedLocation('newSurveyScreen'));
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
          color: Constants.whiteColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<SurveyProvider>(
                  builder: (context, provider, child) {
                    return provider.surveysList.isEmpty
                        ? const SizedBox.shrink()
                        : ListView(
                            children: [
                              SizedBox(
                                child: ListView.builder(
                                  itemCount: provider.surveysList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return SurveyWidget(
                                      surveyName: provider.surveysList[index].surveyName,
                                      surveyDate: provider.surveysList[index].createdAt,
                                      onTap: () {
                                        // debugPrint("surveyName: ${provider.surveysList[index].surveyId}");
                                          context.pushNamed('newSurveyScreen',
                                              extra: {
                                                'index': index,
                                                'surveyId': provider.surveysList[index].surveyId,
                                                'isEdit': true,
                                              },);
                                      },
                                      onTapExcel: (){
                                      provider.exportExcelMethod(context,provider.surveysList[index].surveyId!,provider.surveysList[index].surveyName);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*provider.getAllSurvey().then((value) {
                                          context.pushNamed('newSurveyScreen',
                                              pathParameters: {
                                                'index': '$index',
                                              },
                                              queryParameters: {
                                                'isEdit': 'true',
                                              });
                                        }).onError((error, stackTrace) {
                                          debugPrint(
                                              'error in getting AllSurvey ---> $error\n$stackTrace');
                                        });*/
