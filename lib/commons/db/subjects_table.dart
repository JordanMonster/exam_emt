import 'package:questionhub/commons/model/subjects_model.dart';
import 'package:sqflite/sqflite.dart';

import 'questions_table.dart';
import 'topic_table.dart';

class SubjectsTable {
  static const String tableName = "subjects";

  Future<SubjectsModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = $id");
    if (map.isNotEmpty) {
      return SubjectsModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<SubjectsModel>> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);
    List<SubjectsModel> list = List.empty(growable: true);
    if (map.isNotEmpty) {
      await Future.forEach(map, (Map element) async {
        SubjectsModel subjectsModel = SubjectsModel.fromJson(element);
        var questionCount = await db.rawQuery(
            "SELECT count(*) FROM ${QuestionsTable.tableName} where subjectId = ${subjectsModel.id}");
        var topicCount = await db.rawQuery(
            "SELECT count(*) FROM ${TopicTable.tableName} where subjectId = ${subjectsModel.id}");
        subjectsModel.questionCount = questionCount.first.values.first as int;
        subjectsModel.subjectCount = topicCount.first.values.first as int;
        list.add(subjectsModel);
      });
    }
    return list;
  }
}
