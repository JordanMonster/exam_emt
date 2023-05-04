import 'package:questionhub/commons/model/notes_model.dart';
import 'package:sqflite/sqflite.dart';

class NoteTable {
  static const String tableName = "notes";

  Future<NotesModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = $id");
    if (map.isNotEmpty) {
      return NotesModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<NotesModel>?> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);
    if (map.isNotEmpty) {
      List<NotesModel> list = List.empty(growable: true);
      await Future.forEach(map, (Map element) {
        list.add(NotesModel.fromJson(element));
      });
      return list;
    }
    return null;
  }

  Future<int> count(Database db, {String? where}) async {
    var map = await db.rawQuery(
        "SELECT count(*) FROM $tableName ${where != null ? "where $where" : ""}");
    return (map.first.values.first as int?) ?? 0;
  }
}
