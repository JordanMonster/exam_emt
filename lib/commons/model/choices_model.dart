
class ChoicesModel {
  ChoicesModel({
      int? id, 
      String? qId, 
      String? text, 
      int? right,}){
    _id = id;
    _qId = qId;
    _text = text;
    _right = right;
}

  ChoicesModel.fromJson(dynamic json) {
    _id = json['id'];
    _qId = json['qId'];
    _text = json['text'];
    _right = json['right'];
  }
  int? _id;
  String? _qId;
  String? _text;
  int? _right;

  int? get id => _id;
  String? get qId => _qId;
  String? get text => _text;
  int? get right => _right;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['qId'] = _qId;
    map['text'] = _text;
    map['right'] = _right;
    return map;
  }

}