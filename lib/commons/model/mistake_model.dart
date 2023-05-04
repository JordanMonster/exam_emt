
class MistakeModel {
  MistakeModel({int? id, String? questionId, int? mistakeNumb, int? subjectId}) {
    _id = id;
    _questionId = questionId;
    _mistakeNumb = mistakeNumb;
    _subjectId = subjectId;
  }

  int? _id;
  String? _questionId;
  int? _mistakeNumb;
  int? _subjectId;

  int? get id => _id;

  String? get questionId => _questionId;

  int? get mistakeNumb => _mistakeNumb;

  int? get subjectId => _subjectId;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['questionId'] = _questionId;
    map['mistakeNumb'] = _mistakeNumb;
    map['subjectId'] = _subjectId;
    return map;
  }

  MistakeModel.fromJson(dynamic json) {
    _id = json['id'];
    _questionId = json['questionId'];
    _mistakeNumb = json['mistakeNumb'];
    _subjectId = json['subjectId'];
  }
}
