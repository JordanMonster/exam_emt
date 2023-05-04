import 'package:questionhub/commons/model/system_model.dart';
import 'package:sqflite/sqflite.dart';

class SystemTable {
  static const String tableName = "system";

  Future<SystemModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = $id");
    if (map.isNotEmpty) {
      return SystemModel.fromJson(map.first);
    }
    return null;
  }

  Future<SystemModel?> selectOneByFirst(Database db,String? where) async {
    var map = await db.query(tableName, where: where);
    if (map.isNotEmpty) {
      return SystemModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<SystemModel>?> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);
    if (map.isNotEmpty) {
      List<SystemModel> list = List.empty(growable: true);
      await Future.forEach(map, (Map element) {
        list.add(SystemModel.fromJson(element));
      });
      return list;
    }
    return null;
  }

  Future<Object?> count(Database db, {String? where}) async {
    var map = await db.rawQuery(
        "SELECT count(*) FROM $tableName ${where != null ? "where $where" : ""}");
    return map.first.values.first;
  }
}
