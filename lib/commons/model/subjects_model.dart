class SubjectsModel {
  SubjectsModel({int? id, String? subject, String? textSubject, String? des}) {
    _id = id;
    _subject = subject;
    _textSubject = textSubject;
    _des = des;
  }

  int? _id;
  String? _subject;
  String? _textSubject;
  String? _des;
  int? _questionCount;
  int? _subjectCount;
  bool isSelect = false;

  int? get id => _id;

  String? get subject => _subject;

  String? get textSubject => _textSubject;

  String? get des => _des;

  int get questionCount => _questionCount ?? 0;

  int get subjectCount => _subjectCount ?? 0;

  set subjectCount(int value) {
    _subjectCount = value;
  }

  set questionCount(int value) {
    _questionCount = value;
  }

  SubjectsModel.fromJson(dynamic json) {
    _id = json['id'];
    _subject = json['subject'];
    _textSubject = json['textSubject'];
    _des = json['des'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['subject'] = _subject;
    map['textSubject'] = _textSubject;
    map['des'] = _des;
    return map;
  }
}
