import 'dart:async';

import 'package:flutter/widgets.dart';

import '../commons/model/question_model.dart';

class UserDataModule extends ChangeNotifier {
  num _practiceProgress = 0;
  int _examTimes = -1;

  num get practiceProgress => _practiceProgress;

  int get examTimes => _examTimes;

  void setPracticeProgress(num practiceProgress, {bool notify = false}) {
    _practiceProgress = practiceProgress;
    if (notify) notifyListeners();
  }

  void setExamTimes(DateTime examTime, {bool notify = false}) {
    _examTimes = examTime.millisecondsSinceEpoch;
    if (notify) notifyListeners();
  }
}

class QuestionDetailModule extends ChangeNotifier {
  int _position = 0;
  final List<QuestionModel> _multiSelectList = [];
  bool isSingleChoices = false;

  var duration = const Duration(hours: 0, minutes: 0, seconds: 0);
  bool isActive = true;

  bool isExpandDescription = false;
  bool needShowPop = false;

  int secondsPassed = 0;
  Timer? timer;

  int answered = 0;

  int get position => _position;

  List<QuestionModel> get multiSelectList => _multiSelectList;

  void setPosition(int position) {
    _position = position;
    notifyListeners();
  }

  void addAll(List<QuestionModel> multiSelectList) {
    _multiSelectList.addAll(multiSelectList);
    notifyListeners();
  }

  void add(QuestionModel questionModel) {
    _multiSelectList.add(questionModel);
    notifyListeners();
  }
}
