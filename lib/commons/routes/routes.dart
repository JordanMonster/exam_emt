import 'package:flutter/material.dart';
import 'package:questionhub/commons/model/score_model.dart';
import 'package:questionhub/commons/routes/route_name.dart';
import 'package:questionhub/screen/guide/guide_screen.dart';
import 'package:questionhub/screen/home_screen.dart';
import 'package:questionhub/screen/launcher_screen.dart';
import 'package:questionhub/screen/score/score_screen.dart';
import 'package:questionhub/screen/single/single_subject_screen.dart';
import 'package:questionhub/screen/subjects/subjects_screen.dart';
import 'package:questionhub/screen/subscribe/subscribe_screen.dart';

import '../../screen/question/question_detail_screen.dart';
import '../model/list_model.dart';

class RouteManager {
  // 路由总表
  final Map<String, WidgetBuilder> _routeMap = {};

  // 拦截参数，用来拦截路由表，进行不同操作
  final _isLogin = true;
  final _otherJudge = true;

  RouteManager() {
    _routeMap.addAll(mapForApp());
  }

  // 自定义路由
  MaterialPageRoute routeWithSetting(RouteSettings setting) {
    // 拦截未登录路由
    if (!_isLogin) {
      return loginRoute(setting);
    }

    // 拦截其他情况路由
    if (!_otherJudge) {
      return ohterRoute(setting);
    }

    WidgetBuilder? builder = _routeMap[setting.name];

    if (setting.name == questionScreen) {
      var testModel = setting.arguments as ListModel;
      return MaterialPageRoute(
          builder: (context) => QuestionDetailPage(testModel: testModel));
    }

    if (setting.name == singleSubjectScreen) {
      return MaterialPageRoute(
          builder: (context) =>
              SingleSubjectScreen(list: setting.arguments as List<ListModel>));
    }

    if (setting.name == scoreScreen) {
      var scoreModel = setting.arguments as ScoreModel;
      return MaterialPageRoute(
          builder: (context) => ScorePage(score: scoreModel));
    }

    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }
    return MaterialPageRoute(builder: (context) => const LauncherScreen());
  }

  // 未知路由
  MaterialPageRoute unknowRouteWithSetting(RouteSettings setting) {
    return MaterialPageRoute(builder: (context) => const LauncherScreen());
  }

  // 登录路由
  MaterialPageRoute loginRoute(RouteSettings setting) {
    return MaterialPageRoute(builder: (context) => const LauncherScreen());
  }

  // 拦截其他情况路由
  MaterialPageRoute ohterRoute(RouteSettings setting) {
    return MaterialPageRoute(builder: (context) => const LauncherScreen());
  }

  // 主表
  Map<String, WidgetBuilder> mapForApp() {
    return {
      guideScreen: (BuildContext context) => const GuideScreen(),
      subscribeScreen: (BuildContext context) => const SubscribeScreen(),
      homeScreen: (BuildContext context) => HomeScreen(key: homeGlobalKey),
      subjectsSelectScreen: (BuildContext context) => const SubjectsSelectPage(
            isSetting: false,
          ),
      settingSubjectsSelectScreen: (BuildContext context) => const SubjectsSelectPage(
            isSetting: true,
          ),
    };
  }

  // 首页
  Map<String, WidgetBuilder> mapForHome() {
    return {homeScreen: (BuildContext context) => LauncherScreen()};
  }
}
