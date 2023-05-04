class TopicModel {
  int? _id;
  int? _sec;
  String? _topicName;
  String? _smallTopicName;
  int? _subjectId;

  int? get id => _id;

  int? get sec => _sec;

  String? get topicName => _topicName;

  String? get smallTopicName => _smallTopicName;

  int? get subjectId => _subjectId;

  TopicModel(
      {int? id,
      String? topicName,
      int? sec,
      String? smallTopicName,
      int? subjectId}) {
    _id = id;
    _topicName = topicName;
    _sec = sec;
    _smallTopicName = smallTopicName;
    _subjectId = subjectId;
  }

  TopicModel.fromJson(dynamic json) {
    _id = json['id'];
    _topicName = json['topicName'];
    _smallTopicName = json['smallTopicName'];
    _sec = json['sec'];
    _subjectId = json['subjectId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['topicName'] = _topicName;
    map['smallTopicName'] = _smallTopicName;
    map['sec'] = _sec;
    map['subjectId'] = _subjectId;
    return map;
  }

  @override
  String toString() {
    return 'TopicModel{_topicName: $_topicName}';
  }
}
