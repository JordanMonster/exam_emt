import 'package:questionhub/commons/model/question_model.dart';

class NotesModel {
  int? _id;
  String? _questionId;
  String? _topicName;
  int? _number;
  String? _userAnswer;
  int? _state;
  int? _scoreId;
  int? _created;
  int? _updated;
  int? _subjectId;

  QuestionModel? _question;

  set setQuestion(QuestionModel question) {
    _question = question;
  }

  int? get id => _id;

  String? get questionId => _questionId;

  String? get topicName => _topicName;

  String? get userAnswer => _userAnswer;

  int? get number => _number;

  int? get state => _state;

  int? get scoreId => _scoreId;

  int? get created => _created;

  int? get updated => _updated;

  int? get subjectId => _subjectId;

  QuestionModel? get question => _question;

  NotesModel(
      {int? id,
      String? questionId,
      String? topicName,
      String? userAnswer,
      int? number,
      int? state,
      int? scoreId,
      int? created,
      int? updated,
      QuestionModel? question}) {
    _id = id;
    _questionId = questionId;
    _userAnswer = userAnswer;
    _topicName = topicName;
    _number = number;
    _state = state;
    _scoreId = scoreId;
    _created = created;
    _updated = updated;
    _question = question;
  }

  NotesModel.fromJson(dynamic json) {
    _id = json['id'];
    _questionId = json['questionId'];
    _userAnswer = json['userAnswer'];
    _topicName = json['topicName'];
    _number = json['number'];
    _state = json['state'];
    _scoreId = json['scoreId'];
    _created = json['created'];
    _updated = json['updated'];
    _subjectId = json['subjectId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['questionId'] = _questionId;
    map['topicName'] = _topicName;
    map['userAnswer'] = _userAnswer;
    map['number'] = _number;
    map['state'] = _state;
    map['scoreId'] = _scoreId;
    map['created'] = _created;
    map['updated'] = _updated;
    map['subjectId'] = _subjectId;
    return map;
  }

  @override
  String toString() {
    return 'Notes{_id: $_id, _questionId: $_questionId, _topicName: $_topicName, _number: $_number, _userAnswer: $_userAnswer, _state: $_state, _scoreId: $_scoreId, _created: $_created, _updated: $_updated, _question: $_question}';
  }
}
