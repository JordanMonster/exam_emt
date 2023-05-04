class ProgressModel {
  String? _topicName;
  String? _smallTopicName = "";
  int? _progress;
  int? _count;

  String? get topicName => _topicName;

  String? get smallTopicName => _smallTopicName;

  int? get progress => _progress ?? 0;

  int? get count => _count ?? 1;

  ProgressModel(
      {String? topicName, String? smallTopicName, int? progress, int? count}) {
    _topicName = topicName;
    _smallTopicName = smallTopicName;
    _progress = progress;
    _count = count;
  }

  ProgressModel.fromJson(dynamic json) {
    _topicName = json['topicName'];
    _progress = json['progress'];
    _count = json['count'];
    _smallTopicName = json['smallTopicName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['topicName'] = _topicName;
    map['progress'] = _progress;
    map['count'] = _count;
    map['smallTopicName'] = _smallTopicName;
    return map;
  }
}
