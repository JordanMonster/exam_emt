/// id : 1
/// text : "asdas"
/// number : 1
/// remark : "asdads"
/// sec : 1
/// created : 123123123
/// updated : 123312

class SystemModel {
  SystemModel({
      int? id, 
      String? text, 
      int? number, 
      String? remark, 
      int? sec, 
      int? created, 
      int? updated,}){
    _id = id;
    _text = text;
    _number = number;
    _remark = remark;
    _sec = sec;
    _created = created;
    _updated = updated;
}

  SystemModel.fromJson(dynamic json) {
    _id = json['id'];
    _text = json['text'];
    _number = json['number'];
    _remark = json['remark'];
    _sec = json['sec'];
    _created = json['created'];
    _updated = json['updated'];
  }
  int? _id;
  String? _text;
  int? _number;
  String? _remark;
  int? _sec;
  int? _created;
  int? _updated;

  int? get id => _id;
  String? get text => _text;
  int? get number => _number;
  String? get remark => _remark;
  int? get sec => _sec;
  int? get created => _created;
  int? get updated => _updated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['text'] = _text;
    map['number'] = _number;
    map['remark'] = _remark;
    map['sec'] = _sec;
    map['created'] = _created;
    map['updated'] = _updated;
    return map;
  }

}