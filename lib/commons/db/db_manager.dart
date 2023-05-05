import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:questionhub/commons/db/mistake_table.dart';
import 'package:questionhub/commons/db/questions_table.dart';
import 'package:questionhub/commons/db/score_table.dart';
import 'package:questionhub/commons/db/subjects_table.dart';
import 'package:questionhub/commons/db/topic_table.dart';
import 'package:questionhub/commons/model/mistake_model.dart';
import 'package:questionhub/commons/model/score_model.dart';
import 'package:questionhub/commons/model/subjects_model.dart';
import 'package:questionhub/commons/model/topic_model.dart';
import 'package:questionhub/purchase/purchase_manager.dart';
import 'package:sqflite/sqflite.dart';

import '../global.dart';
import '../model/list_model.dart';
import '../model/progress_model.dart';
import '../model/question_model.dart';
import 'note_table.dart';

class DBManager {
  static DBManager? _instance;
  Database? _db;

  factory DBManager.getInstance() => _getInstance();

  static _getInstance() {
    _instance ??= DBManager._internal();
    return _instance;
  }

  static SubjectsTable? subjectsTable = SubjectsTable();
  static QuestionsTable? questionTable = QuestionsTable();

  static ScoreTable? scoreTable = ScoreTable();
  static MistakeTable? mistakesTable = MistakeTable();
  static TopicTable? topicTable = TopicTable();
  static NoteTable? notesTable = NoteTable();

  static const String purchaseTable = "purchase";
  static const String testTable = "test";
  static const String dbName = "questionhub.db";

  DBManager._internal();

  initialize() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, dbName);
    var isExists = await File(path).exists();
    if (!isExists) {
      await _copyAssetDB();
    }

    _db = await openDatabase(path,
        version: 1,
        singleInstance: true,
        onUpgrade: (Database db, int oldVersion, int newVersion) {});
  }

  _copyAssetDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    ByteData data = await rootBundle.load(join("assets", dbName));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }

  Future<List<SubjectsModel>?> selectAllSubjects() async {
    return subjectsTable?.selectList(_db!);
  }

  Future<SubjectsModel?> selectSubjectsByName(String subjects) async {
    var modelList =
        await subjectsTable?.selectList(_db!, where: "subject = '$subjects'");
    return modelList?.first;
  }

  Future<ProgressModel> countQuestionProgress() async {
    int? progress = await questionTable?.count(_db!,
        where: _subjectsWhere(where: "state != 0 and state NOTNULL"));
    int? count = await questionTable?.count(_db!, where: _subjectsWhere());
    return ProgressModel(progress: progress, count: count);
  }

  _subjectsWhere({String? where}) {
    return isMultiple
        ? "subjectId = ${Global.subjectsModel?.id} ${where != null ? "and $where" : ""}"
        : where;
  }

  Future<int> countDailyPractice(DateTime star, DateTime end) async {
    return await scoreTable?.count(_db!,
            where: _subjectsWhere(
                where:
                    "created > ${star.millisecondsSinceEpoch} and created < ${end.millisecondsSinceEpoch} and typeName = 'DailyPractice'")) ??
        0;
  }

  Future<ScoreModel> saveScore(
      String topicName, List<QuestionModel> questions, int time) async {
    var batch = _db!.batch();
    int id = await scoreTable?.selectScoreId(_db!);

    int count = 0;

    for (var element in questions) {
      if (element.isRight != null) {
        count++;
        insertMistake(element);
      }
    }

    Map<String, Object?> score = {
      "id": id,
      "typeName": topicName,
      "time": time,
      "created": DateTime.now().microsecondsSinceEpoch,
      "updated": DateTime.now().microsecondsSinceEpoch,
      "subjectId": Global.subjectsModel!.id!,
      "answered": count,
    };

    int right = 0;

    for (var element in questions) {
      if (element.isRight != null) {
        updateQuestionState(element.id!, 1);

        Map<String, Object> value = {
          "questionId": element.id!,
          "topicName": element.topicName!,
          "userAnswer": jsonEncode(element.userAnswer),
          "state": element.isRight!,
          "scoreId": id,
          "subjectId": Global.subjectsModel!.id!,
          "created": DateTime.now().microsecondsSinceEpoch,
          "updated": DateTime.now().microsecondsSinceEpoch
        };

        if (element.isRight! == 0) {
          right++;
        }

        batch.insert(NoteTable.tableName, value);
      }
    }

    score["progress"] = right / count;
    score["scoreValue"] = right.toDouble();

    batch.insert(ScoreTable.tableName, score);
    await batch.commit(continueOnError: false);
    return ScoreModel.fromJson(score);
  }

  insertMistake(QuestionModel element) async {
    var mistake = await _db!
        .query(MistakeTable.tableName, where: "questionId = \"${element.id}\"");

    if (mistake.isNotEmpty) {
      MistakeModel mistakeModel = MistakeModel.fromJson(mistake.first);
      if (element.isRight! == 0) {
        Map<String, Object> mistakeValue = {
          "questionId": element.id!,
          "subjectId": Global.subjectsModel!.id!,
          "topicName": element.topicName!
        };

        mistakeValue["mistakeNumb"] = mistakeModel.mistakeNumb! + 1;
        await _db!.update(MistakeTable.tableName, mistakeValue,
            where: "id = ${mistakeModel.id}");
      } else {
        Map<String, Object> mistakeValue = {
          "questionId": element.id!,
          "subjectId": Global.subjectsModel!.id!,
          "topicName": element.topicName!
        };
        mistakeValue["mistakeNumb"] = 0;
        await _db!.update(MistakeTable.tableName, mistakeValue,
            where: "id = ${mistakeModel.id}");
      }
    } else {
      if (element.isRight! != 0) {
        Map<String, Object> mistakeValue = {
          "questionId": element.id!,
          "subjectId": Global.subjectsModel!.id!,
          "topicName": element.topicName!
        };

        mistakeValue["mistakeNumb"] = 0;
        await _db!.insert(MistakeTable.tableName, mistakeValue);
      } else {
        Map<String, Object> mistakeValue = {
          "questionId": element.id!,
          "subjectId": Global.subjectsModel!.id!,
          "topicName": element.topicName!
        };

        mistakeValue["mistakeNumb"] = 1;
        await _db!.insert(MistakeTable.tableName, mistakeValue);
      }
    }
  }

  updateQuestionState(String id, int state) async {
    QuestionModel? question = await questionTable!.selectById(_db!, id);
    if (question!.state != 2) {
      Map<String, Object> values = {"state": state};
      questionTable?.updateById(_db!, id, state);
    }
  }

  Future<List<QuestionModel>?> selectQuestionByListModel(
      ListModel model) async {
    switch (model.type) {
      case ListModel.typeStudySubjects:
        return await questionTable?.selectList(_db!,
            where: _subjectsWhere(where: "topicName = '${model.topicName}'"),
            limit: model.count,
            orderBy: "RANDOM()",
            offset: model.index! * model.count!);

      case ListModel.typeStudyTests:
        return await questionTable?.selectList(_db!,
            where: _subjectsWhere(where: "model = \"${model.topicName}\""),
            orderBy: "RANDOM()");

      case ListModel.typeCust:
        List<String>? topics = model.topicName?.split(",");
        String where;
        if (topics == null) {
          where = _subjectsWhere();
        } else {
          where = _subjectsWhere(where: "topicName = '${topics.first}'");
          for (var element in topics) {
            where += " or ${_subjectsWhere(where: "topicName = '$element'")}";
          }
        }
        return await questionTable?.selectList(_db!,
            where: where, limit: model.count, orderBy: "RANDOM()");

      case ListModel.typeMistake:
        var mistakeList = await mistakesTable?.selectList(_db!,
            where: _subjectsWhere(where: "mistakeNumb < 2"),
            orderBy: "RANDOM()",
            limit: model.count!);

        List<QuestionModel> questionList = List.empty(growable: true);
        await Future.forEach(mistakeList!, (element) async {
          MistakeModel mistake = MistakeModel.fromJson(element);
          QuestionModel? question =
              await questionTable?.selectById(_db!, mistake.questionId!);
          if (question != null) {
            questionList.add(question);
          }
        });
        return questionList;

      case ListModel.typeQuickForStudy:
      case ListModel.typeQuick:
      case ListModel.typeTimeQuick:
        String? where = _subjectsWhere(
            where: PurchaseManager.instance.isPurchased() ? null : "level = 0");
        return await questionTable?.selectList(_db!,
            where: where, orderBy: "RANDOM()", limit: model.count);

      case ListModel.typeSimulation:
        return await questionTable?.selectList(_db!,
            where: _subjectsWhere(where: "model = 'Full Test '"),
            orderBy: "RANDOM()");

      case ListModel.typeWeak:
        return await questionTable?.selectList(_db!,
            orderBy: "RANDOM()",
            limit: model.count,
            where: _subjectsWhere(where: "topicName = \"${model.topicName}\""));
      default:
        return List.empty();
    }
  }

  Future<List<TopicModel>?> selectAllTopicList() async {
    return await topicTable!.selectList(_db!, where: _subjectsWhere());
  }

  Future<List<ListModel>?> selectAllTopicListModel() async {
    return await topicTable!.selectToListModel(_db!, where: _subjectsWhere());
  }

  Future<ProgressModel?> selectSubjectProgressByScore(
      int scoreId, String topicName) async {
    int progres = await notesTable!.count(_db!,
        where: _subjectsWhere(
            where:
                "scoreId = $scoreId and topicName = \"$topicName\" and state = 0;"));
    int count = await notesTable!.count(_db!,
        where: _subjectsWhere(
            where: "scoreId = $scoreId and topicName = \"$topicName\";"));
    return ProgressModel(topicName: topicName, progress: progres, count: count);
  }

  Future<int?> countQuestions() async {
    return await questionTable!.count(_db!, where: _subjectsWhere());
  }
}
