import 'package:questionhub/commons/db/questions_table.dart';
import 'package:questionhub/commons/model/list_model.dart';
import 'package:questionhub/commons/model/question_model.dart';
import 'package:questionhub/commons/model/subjects_model.dart';
import 'package:questionhub/commons/model/topic_model.dart';
import 'package:sqflite/sqflite.dart';

class TopicTable {
  static const String tableName = "topic";

  Future<TopicModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = $id");
    if (map.isNotEmpty) {
      return TopicModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<TopicModel>?> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);

    if (map.isNotEmpty) {
      List<TopicModel> list = List.empty(growable: true);
      await Future.forEach(map, (Map element) {
        list.add(TopicModel.fromJson(element));
      });

      return list;
    }
    return null;
  }

  Future<List<ListModel>?> selectToListModel(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {
    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);

    if (map.isNotEmpty) {
      List<ListModel> list = List.empty(growable: true);
      var questionTable = QuestionsTable();
      await Future.forEach(map, (Map element) async {
        ListModel listModel = ListModel();
        var topic = TopicModel.fromJson(element);
        int? count = await questionTable.count(db,
            where: "topicName = '${topic.topicName}'");
        listModel.titleName = topic.topicName;
        listModel.topicName = topic.topicName;
        listModel.type = ListModel.typeMenu;
        listModel.count = count;
        list.add(listModel);
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
