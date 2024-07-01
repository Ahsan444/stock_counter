import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/provider/dashboard_provider.dart';
import 'package:stockcounter/AppModule/utils/Fonts/AppDimensions.dart';
import 'package:stockcounter/AppModule/utils/Fonts/font_weights.dart';
import 'package:stockcounter/AppModule/utils/app_text.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardProvider dashboardProvider;

  @override
  void initState() {
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<DashboardProvider>(
          builder: (context, pr, _) {
            return AppText(
              text: pr.screenNameList[dashboardProvider.selectedIndex],
              fontWeight: FontWeights.medium,
              fontSize: AppDimension.fontSize18,
              color: Constants.whiteColor,
            );
          },
        ),
        iconTheme: IconThemeData(color: Constants.whiteColor),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              curve: Curves.bounceIn,
              child: Center(
                child: AppText(
                    text: 'Stock Counter', fontSize: 20, color: Colors.white),
              ),
            ),
            ListTile(
              title: const AppText(text: 'Home'),
              selected: dashboardProvider.selectedIndex == 0,
              onTap: () {
                dashboardProvider.selectedIndex = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const AppText(text: 'Product'),
              selected: dashboardProvider.selectedIndex == 1,
              onTap: () {
                dashboardProvider.selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const AppText(text: 'Survey'),
              selected: dashboardProvider.selectedIndex == 2,
              onTap: () {
                dashboardProvider.selectedIndex = 2;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Center(
              child: provider.widgetOptions,
            ),
          );
        },
      ),
    );
  }
}
