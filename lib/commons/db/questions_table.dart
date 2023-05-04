import 'package:questionhub/commons/db/choices_table.dart';
import 'package:questionhub/commons/model/choices_model.dart';
import 'package:questionhub/commons/model/question_model.dart';
import 'package:sqflite/sqflite.dart';

class QuestionsTable {
  static const String tableName = "question";

  Future<QuestionModel?> selectById(Database db, String id) async {
    var map = await db.query(tableName, where: "id = '$id'");
    if (map.isNotEmpty) {
      return QuestionModel.fromJson(map.first);
    }
    return null;
  }

  Future<List<QuestionModel>> selectList(Database db,
      {String? where, int? limit, String? orderBy, int? offset}) async {

    var map = await db.query(tableName,
        where: where, limit: limit, orderBy: orderBy, offset: offset);

    List<QuestionModel> list = List.empty(growable: true);

    if (map.isNotEmpty) {
      await Future.forEach(map, (Map element) async {
        QuestionModel questionModel = QuestionModel.fromJson(element);

        var choiceMap = await db.query(ChoiceTable.tableName,where: "qId = ?",whereArgs: [questionModel.id],orderBy: "RANDOM()");
        List<ChoicesModel> choices = List.empty(growable: true);
        List<ChoicesModel> answers = List.empty(growable: true);
        await Future.forEach(choiceMap, (Map element) async {
          ChoicesModel choicesModel = ChoicesModel.fromJson(element);
          choices.add(choicesModel);
          if(choicesModel.right == 1){
            answers.add(choicesModel);
          }
        });
        questionModel.answers = answers;
        questionModel.choices = choices;
        list.add(questionModel);
      });
    }
    return list;
  }

  Future<int?> count(Database db, {String? where}) async {
    var map = await db.rawQuery(
        "SELECT count(*) FROM $tableName ${where != null
            ? "where $where"
            : ""}");
    return map.first.values.first as int;
  }

  Future<int?> updateById(Database db, String id, int state) async{
    Map<String, Object> values = {"state": state};
    int line = await db.update(tableName, values, where: "id = \"$id\"");
    return line;
  }
}
