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

  var _duration = const Duration(hours: 0, minutes: 0, seconds: 1);
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

  void clear(){
    _answered = 0;
    _position = 0;
    _isActive = true;
    _isExpandDescription = false;
    needShowPop = false;
    timer?.cancel();
    timer = null;
    _secondsPassed = 0;
    _multiSelectList.where((element) => element.userAnswer != null).forEach((element) {
      element.setState = 0;
      element.setIsRight = null;
      element.setUserAnswer = null;
    });
    notifyListeners();
  }

  set position(int position) {
    _position = position;
    notifyListeners();
  }

  set answered(int answered) {
    _answered = answered;
    notifyListeners();
  }

  set secondsPassed(int secondsPassed) {
    _secondsPassed = secondsPassed;
    notifyListeners();
  }

  set duration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  set isSingleChoices(bool isSingleChoices) {
    _isSingleChoices = isSingleChoices;
    notifyListeners();
  }

  set isActive(bool isActive) {
    _isActive = isActive;
    notifyListeners();
  }

  set isExpandDescription(bool isExpandDescription) {
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
