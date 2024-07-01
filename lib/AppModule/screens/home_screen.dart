import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/provider/home_provider.dart';

import '../utils/app_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider homeProvider;

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(onPressed: () {
                        homeProvider.createExcelFile(context);
                      },btnText: 'Product Master Data',
                        isIcon: true,
                        iconData: Icons.download_rounded,),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: AppButton(
                          onPressed: () {
                            homeProvider.pickXlFile(context);
                          },
                          btnText: 'Upload File',
                          isIcon: true,
                          iconData: Icons.upload_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AppButton(
                      onPressed: () {
                        context.pushNamed('newSurveyScreen',
                          extra: {
                            'index': 0,
                            'surveyId': 0,
                            'isEdit': false,
                          },);
                        // homeProvider.createExcelFile(context);
                      },
                      btnText: 'New Survey',
                      isIcon: true),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

}
