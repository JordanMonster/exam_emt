import 'dart:convert';

import 'package:questionhub/commons/model/choices_model.dart';
import 'package:questionhub/commons/model/topic_model.dart';

class QuestionModel {
  String? _id;
  String? _question;
  String? _explanation;
  int? _level;
  String? _image;
  String? _video;
  String? _audio;
  int? _topicId;
  String? _topicName;
  String? _model;
  int? _state;
  int? _subjectId;
  int? _flag;
  int? _type;

  List<ChoicesModel>? _choices;
  List<ChoicesModel>? _answers;

  List<dynamic>? _userAnswer;

  set setUserAnswer(List<dynamic>? userAnswer) {
    _userAnswer = userAnswer;
  }

  int? _isRight;

  String? get topicName => _topicName;

  set setIsRight(int? isRight) {
    _isRight = isRight;
  }

  int? get isRight => _isRight;

  int? get subjectId => _subjectId;

  String? get id => _id;

  String? get question => _question;

  String? get explanation => _explanation;

  int? get level => _level;

  int? get state => _state;

  set setState(int? state) {
    _state = state;
  }

  List<ChoicesModel>? get choices => _choices;

  set choices(List<ChoicesModel>? value) {
    _choices = value;
  }

  String? get image => _image;

  String? get video => _video;

  String? get audio => _audio;

  int? get topicId => _topicId;

  String? get model => _model;

  int? get type => _type;

  int? get flag => _flag;

  List<dynamic>? get userAnswer => _userAnswer;

  QuestionModel(
      {String? id,
      String? question,
      String? explanation,
      int? level,
      int? state,
      String? image,
      String? video,
      String? audio,
      String? model,
      int? topicId,
      int? subjectId,
      int? flag,
      int? type}) {
    _id = id;
    _question = question;
    _state = state;
    _explanation = explanation;
    _level = level;
    _image = image;
    _video = video;
    _audio = audio;
    _topicId = topicId;
    _model = model;
    _subjectId = subjectId;
    _flag = flag;
    _type = type;
  }

  QuestionModel.fromJson(dynamic json) {
    _id = json['id'];
    _question = json['question'];
    _explanation = json['explanation'];
    _level = json['level'];
    _image = json['image'];
    _state = json['state'];
    _video = json['video'];
    _audio = json['audio'];
    _topicId = json['topicId'];
    _topicName = json['topicName'];
    _model = json['model'];
    _state = json['state'];
    _subjectId = json['subjectId'];
    _flag = json['flag'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['question'] = _question;
    map['explanation'] = _explanation;
    map['level'] = _level;
    map['image'] = _image;
    map['video'] = _video;
    map['audio'] = _audio;
    map['state'] = _state;
    map['topicId'] = _topicId;
    map['model'] = _model;
    map['topicName'] = _topicName;
    map['state'] = _state;
    map['subjectId'] = _subjectId;
    map['flag'] = _flag;
    map['type'] = _type;
    return map;
  }

  List<ChoicesModel>? get answers => _answers;

  set answers(List<ChoicesModel>? value) {
    _answers = value;
  }
}
