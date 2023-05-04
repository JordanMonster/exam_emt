
import 'package:questionhub/commons/model/question_model.dart';

class ScoreModel{
  int? _id;
  String? _typeName;
  double? _progress;
  double? _scoreValue;
  int? _created;
  int? _updated;
  int? _time;
  int? _answered;
  int? _multiSelectListLength;
  int? _subjectId;

  int? get subjectId => _subjectId;

  List<QuestionModel>? _questionList;

  int? get id => _id;

  int? get multiSelectListLength => _multiSelectListLength;

  set setMultiSelectListLength(int multiSelectListLength) {
    _multiSelectListLength = multiSelectListLength;
  }

  String? get typeName => _typeName;

  set setTypeName(String typeName) {
    _typeName = typeName;
  }

  double? get progress => _progress;

  double? get scoreValue => _scoreValue;

  set setProgress(double progress) {
    _progress = progress;
  }

  set seScoreValue(double scoreValue) {
    _scoreValue = scoreValue;
  }

  int? get created => _created;

  int? get updated => _updated;

  int? get time => _time;

  int? get answered => _answered;

  List<QuestionModel>? get questionList => _questionList;

  set setQuestions(List<QuestionModel> questionList) {
    _questionList = questionList;
  }

  ScoreModel(
      {int? id,
      String? typeName,
      double? progress,
      double? scoreValue,
      int? created,
      int? updated,
      int? answered,
      int? time,
      int? subjectId}) {
    _id = id;
    _typeName = typeName;
    _progress = progress;
    _scoreValue = scoreValue;
    _created = created;
    _updated = updated;
    _time = time;
    _answered = answered;
    _subjectId = subjectId;
  }

  ScoreModel.fromJson(dynamic json) {
    _id = json['id'];
    _typeName = json['typeName'];
    _progress = json['progress'];
    _scoreValue = json['scoreValue'];
    _time = json['time'];
    _created = json['created'];
    _updated = json['updated'];
    _answered = json['answered'];
    _subjectId = json['subjectId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['typeName'] = _typeName;
    map['progress'] = _progress;
    map['scoreValue'] = _scoreValue;
    map['time'] = _time;
    map['created'] = _created;
    map['updated'] = _updated;
    map['answered'] = _answered;
    map['subjectId'] = _subjectId;
    return map;
  }
}
