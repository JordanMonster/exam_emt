import 'package:questionhub/commons/model/score_model.dart';
import 'package:sqflite/sqflite.dart';

class ScoreTable {
  static const String tableName = "score";

  selectScoreId(Database db) async {
    var id = await db.rawQuery("SELECT count(*) FROM $tableName;");
    return ((id.first.values.first ?? 0) as int) + 1;
  }

  Future<ScoreModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = $id");
    if (map.isNotEmpty) {
      return ScoreModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<ScoreModel>?> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);
    List<ScoreModel> list = List.empty(growable: true);
    if (map.isNotEmpty) {
      await Future.forEach(map, (Map element) {
        list.add(ScoreModel.fromJson(element));
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
