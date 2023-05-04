import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:questionhub/commons/db/db_manager.dart';
import 'package:questionhub/commons/res/constant_str.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'model/subjects_model.dart';

const bool isMultiple = false;
bool? isDark = false;
const imageUrl = "";
const defaultSelectSubjects = "EMT";
const purchaseKey = "";

class Global {
  static const String subjectNameKey = "sn";
  static const String uidKey = "uid";

  static String? dbName;
  static SharedPreferences? _prefs;
  static SubjectsModel? subjectsModel;
  static int? questionCount;

  static initialize() async {}

  static initializeAppConfig() async {
    _prefs = await SharedPreferences.getInstance();
    await DBManager.getInstance().initialize();
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness:Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  static bool isSelectSubjects() {
    return _prefs?.containsKey(subjectNameKey) ?? false;
  }

  static String getSelectSubject() {
    if (isMultiple) {
      String app = _prefs!.getString(subjectNameKey) ?? defaultSelectSubjects;
      return app;
    }
    return defaultSelectSubjects;
  }

  static String getUserId() {
    return _prefs?.getString(uidKey) ?? "";
  }

  static Future<bool> selectSubjects(String appName) async {
    _prefs?.setString(subjectNameKey, appName);
    subjectsModel = await DBManager.getInstance().selectSubjectsByName(appName);
    questionCount = await DBManager.getInstance().countQuestions();
    if (subjectsModel != null) {
      return true;
    } else {
      return false;
    }
  }

  static bool isFirstStart() {
    return !(_prefs?.containsKey("first") ?? false);
  }

  static startFirst() async {
    return await _prefs?.setBool("first", false);
  }

  static Future<bool?> setExamTime(DateTime time) async {
    return await _prefs?.setInt(
        "${getSelectSubject()}_$userExamTimeKey", time.millisecondsSinceEpoch);
  }

  static int getExamTime() {
    return _prefs?.getInt("${getSelectSubject()}_$userExamTimeKey") ?? -1;
  }

  //判断是否为Debug模式
  static bool isDebug() {
    bool inDebug = false;
    assert(inDebug = true);
    return inDebug;
  }

  //判断编译模式
  static String getCompileMode() {
    const bool isProfile = bool.fromEnvironment("dart.vm.profile");
    const bool isReleaseMode = bool.fromEnvironment("dart.vm.product");
    if (isDebug()) {
      return "debug";
    } else if (isProfile) {
      return "profile";
    } else if (isReleaseMode) {
      return "release";
    } else {
      return "Unknown type";
    }
  }
}
