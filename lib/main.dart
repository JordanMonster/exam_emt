import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/purchase/purchase_manager.dart';

import 'commons/global.dart';
import 'commons/routes/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RouteManager manager = RouteManager();

void main() => Global.initialize().then((e) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    Global.initializeAppConfig();
    _initLoading();
    PurchaseManager.initialize(purchaseKey);
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QuestionHub",
      theme: ThemeData(
        canvasColor: Colors.white,
        primaryColor: commonColor,
        primaryColorDark: commonColor,
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        return manager.routeWithSetting(settings);
      },
      builder: EasyLoading.init(),
      onUnknownRoute: (settings) {
        return manager.unknowRouteWithSetting(settings);
      },
    );
  }

  _initLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 3000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..boxShadow = [
        const BoxShadow(color: Colors.transparent),
        const BoxShadow(color: Colors.transparent)
      ]
      ..backgroundColor = Colors.transparent
      ..contentPadding = EdgeInsets.zero
      ..indicatorSize = 45.0
      ..radius = 20.0
      ..indicatorColor = Colors.black
      ..textColor = Colors.black
      ..maskColor = Colors.black.withOpacity(0.8)
      ..progressWidth = 10
      ..progressColor = commonColor;
  }
}
