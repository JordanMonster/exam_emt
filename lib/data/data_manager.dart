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
  bool _isSingleChoices = false;

  var _duration = const Duration(hours: 0, minutes: 0, seconds: 0);
  bool _isActive = true;

  bool _isExpandDescription = false;
  bool needShowPop = false;

  int _secondsPassed = 0;
  Timer? timer;

  int _answered = 0;

  int get position => _position;

  bool get isSingleChoices => _isSingleChoices;

  bool get isActive => _isActive;

  bool get isExpandDescription => _isExpandDescription;

  int get secondsPassed => _secondsPassed;

  int get answered => _answered;

  Duration get duration => _duration;

  List<QuestionModel> get multiSelectList => _multiSelectList;

  int get questionTotal => _multiSelectList.length;

  QuestionModel get question => _multiSelectList[position];

  void setPosition(int position) {
    _position = position;
    notifyListeners();
  }

  void setAnswered(int answered) {
    _answered = answered;
    notifyListeners();
  }

  void setSecondsPassed(int secondsPassed) {
    _secondsPassed = secondsPassed;
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  void setIsSingleChoices(bool isSingle) {
    _isSingleChoices = isSingle;
    notifyListeners();
  }

  void setIsActive(bool isActive) {
    _isActive = isActive;
    notifyListeners();
  }

  void setIsExpand(bool isExpandDescription) {
    _isExpandDescription = isExpandDescription;
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
