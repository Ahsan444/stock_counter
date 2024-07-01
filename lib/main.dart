import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/res/providers.dart';

import 'AppModule/res/app_routes.dart';
import 'AppModule/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: ProvidersList.providersList,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'A Stock Counter Application',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              useMaterial3: true,
            ),
            routerConfig: AppRouter.routes,
            //home: child,
            // initialRoute: RouteName.splashScreen,
            // routes: AppRoutes.appRoutes(),
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}
