import 'package:questionhub/commons/model/choices_model.dart';
import 'package:questionhub/commons/model/question_model.dart';
import 'package:sqflite/sqflite.dart';

class ChoiceTable {
  static const String tableName = "choices";

  Future<ChoicesModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = '$id'");
    if (map.isNotEmpty) {
      return ChoicesModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<ChoicesModel>> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);
    List<ChoicesModel> list = List.empty(growable: true);
    if (map.isNotEmpty) {
      await Future.forEach(map, (Map element) {
        list.add(ChoicesModel.fromJson(element));
      });
    }
    return list;
  }

  Future<int?> updateById(Database db, String id, int state) async{
    Map<String, Object> values = {"state": state};
    int line = await db.update(tableName, values, where: "id = \"$id\"");
    return line;
  }

}
