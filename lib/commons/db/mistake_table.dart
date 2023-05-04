import 'package:sqflite/sqflite.dart';
import '../model/mistake_model.dart';

class MistakeTable {
  static const String tableName = "mistake";

  Future<MistakeModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = $id");
    if (map.isNotEmpty) {
      return MistakeModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<MistakeModel>> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);
    List<MistakeModel> list = List.empty(growable: true);
    if (map.isNotEmpty) {
      await Future.forEach(map, (Map element) {
        list.add(MistakeModel.fromJson(element));
      });
    }
    return list;
  }

  Future<int?> count(Database db, {String? where}) async {
    var map = await db.rawQuery(
        "SELECT count(*) FROM $tableName ${where != null ? "where $where" : ""}");
    return map.first.values.first as int;
  }
}
