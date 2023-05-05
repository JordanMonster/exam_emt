import 'package:questionhub/commons/model/score_model.dart';

class ListModel {
  static const typeMenu = -1;

  static const typeHomeSubjects = 0;

  static const typeStudySubjects = 1;

  static const typeStudyTests = 2;

  static const typeHistory = 3;

  static const typeQuick = 4;

  static const typeQuickForStudy = 9;

  static const typeMistake = 5;

  static const typeWeak = 6;

  static const typeSimulation = 7;

  static const typeCust = 8;

  static const typeTimeQuick = 10;

  String? _topicName;
  String? _titleName;
  int? _index;
  int? _count;
  int? _type;
  int? _hour;
  int? _minutes;
  ScoreModel? _score;

  ScoreModel? get score => _score;

  set score(ScoreModel? value) {
    _score = value;
  }

  String? get topicName => _topicName;

  String? get titleName => _titleName;

  int? get index => _index;

  int? get count => _count;

  int? get type => _type;

  int? get hour => _hour;

  int? get minutes => _minutes;

  set topicName(String? value) {
    _topicName = value;
  } //1:Study ；2：test

  ListModel(
      {String? topicName,
      String? titleName,
      int? index,
      int? count,
      int? type,
      ScoreModel? score}) {
    _topicName = topicName;
    _titleName = titleName;
    _index = index;
    _count = count;
    _type = type;
    _score = score;
  }

  ListModel.getDailyPractice() {
    _topicName = "Daily Practice";
    _titleName = "Daily Practice";
    _type = typeQuick;
    _count = 5;
  }

  ListModel.getTimeQuiz(int hour,int minutes) {
    _topicName = "Time Quiz";
    _titleName = "Time Quiz";
    _type = typeTimeQuick;
    _hour = hour;
    _minutes = minutes;
    _count = 10;
  }

  ListModel.getQuickForStudy() {
    _topicName = "QuickForStudy";
    _titleName = "QuickForStudy";
    _type = typeQuickForStudy;
    _count = 10;
  }

  ListModel.getCustomer({
    int count = 20,
  }) {
    _topicName = "Customer";
    _titleName = "Customer";
    _type = typeCust;
    _count = count;
  }

  ListModel.getWrong({
    int count = 10,
  }) {
    _topicName = "Wrong Quiz";
    _titleName = "Wrong Quiz";
    _type = typeMistake;
    _count = count;
  }

  ListModel.fromJson(dynamic json) {
    _topicName = json['topicName'];
    _titleName = json['titleName'];
    _index = json['index'];
    _count = json['count'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['topicName'] = _topicName;
    map['titleName'] = _titleName;
    map['index'] = _index;
    map['count'] = _count;
    map['type'] = _type;
    return map;
  }

  @override
  String toString() {
    return 'ListModel{_topicName: $_topicName, _titleName: $_titleName, _index: $_index, _count: $_count, _type: $_type, _hour: $_hour, _minutes: $_minutes, _score: $_score}';
  }

  set titleName(String? value) {
    _titleName = value;
  }

  set index(int? value) {
    _index = value;
  }

  set count(int? value) {
    _count = value;
  }

  set type(int? value) {
    _type = value;
  }

  set hour(int? value) {
    _hour = value;
  }

  set minutes(int? value) {
    _minutes = value;
  }
}
