// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
//
// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:questionbank/commons/global.dart';
// import 'package:questionbank/model/billing/new/ios_verify_new_data.dart';
// import 'package:questionbank/model/list_model.dart';
// import 'package:questionbank/model/mistake_model.dart';
// import 'package:questionbank/model/notes_model.dart';
// import 'package:questionbank/model/question_model.dart';
// import 'package:questionbank/model/score_model.dart';
// import 'package:questionbank/model/subject_progress.dart';
// import 'package:questionbank/model/subjects_model.dart';
// import 'package:questionbank/model/topic_model.dart';
// import 'package:questionbank/res/category_app.dart';
// import 'package:questionbank/res/constant_str.dart';
// import 'package:questionbank/utils/purchase_manager.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DBUtils {
//   static DBUtils? _instance;
//   Database? db;
//
//   factory DBUtils.getInstance() => _getInstance();
//
//   static const String subjectsTable = "subjects";
//   static const String topicTable = "topic";
//   static const String questionTable = "question";
//   static const String freeTable = "free";
//   static const String notesTable = "notes";
//   static const String mistakesTable = "mistake";
//   static const String purchaseTable = "purchase";
//   static const String testTable = "test";
//   static const String scoreTable = "score";
//
//   static _getInstance() {
//     if (_instance == null) {
//       _instance = DBUtils._internal();
//     }
//     return _instance;
//   }
//
//   DBUtils._internal() {
//     // if (db == null) {
//     //   initDB();
//     // }
//   }
//
//   initDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//
//     if (Global.config!.oldDbName.isNotEmpty) {
//       String oldPath = join(documentsDirectory.path, Global.config!.oldDbName);
//       var oldIsExists = await File(oldPath).exists();
//       if (oldIsExists) {
//         await File(oldPath).delete();
//       }
//     }
//
//     String path = join(documentsDirectory.path, Global.config!.dbName);
//     var newIsExists = await File(path).exists();
//     if (!newIsExists) {
//       await _copyAssetDB();
//     }
//     //TODO:ATI version: 9
//     //TODO:ASVAB version: 9
//     //TODO:REAL Estate version: 2
//     //TODO:EMT version: 3
//     //TODO:PPL version: 10
//     //TODO:PMP version: 9
//     //TODO:PN version: 9
//     //TODO:RN version: 9
//     //TODO 下个版本，上线版本升级为: 9
//     db = await openDatabase(path, version: 9,
//         onUpgrade: (Database db, int oldVersion, int newVersion) {
//       _upDataV2DB(db);
//       _upDataV3DB(db);
//
//       if (Global.getSelectAppName() == ASVAB) {
//         _upDataASVABV4DB(db);
//       }
//
//       if (Global.getSelectAppName() == NCLEX_PN) {
//         _upDataV2PN(db);
//       }
//
//       if (Global.getSelectAppName() == REAL_ESTATE) {
//         _upDataRealEstateV4DB(db);
//       }
//
//       if (Global.getSelectAppName() == EMT) {
//         _upDataEMTV4DB(db);
//       }
//
//       if (Global.getSelectAppName() == PPL) {
//         _upDataPPLV4DB(db);
//       }
//     });
//   }
//
//   _upDataV2DB(Database db) {
//     try {
//       db.execute("ALTER TABLE topic ADD COLUMN sec INTEGER");
//     } catch (e) {}
//
//     try {
//       db.execute("ALTER TABLE topic ADD COLUMN smallTopicName INTEGER");
//     } catch (e) {}
//   }
//
//   //todo 设置免费题库
//   _upDataV3DB(Database db) async {
//     var dataList = await db.query(topicTable);
//     await Future.forEach(dataList, (element) async {
//       TopicName topicName = TopicName.fromJson(element);
//       var questionList = await db.rawQuery(
//           "SELECT * from question WHERE topicName = '${topicName.topicName}' and image ISNULL or image = '' and topicName = '${topicName.topicName}' LIMIT 5");
//       await Future.forEach(questionList, (element) async {
//         QuestionModel questionModel = QuestionModel.fromDB(element);
//         int a = await db.rawUpdate(
//             "UPDATE question SET level = -1 where id = ${questionModel.id}");
//       });
//     });
//   }
//
//   _upDataV2PN(Database db) {
//     db.rawDelete("DELETE FROM question where topicName = 'Pediatrics'");
//     db.rawDelete("DELETE FROM question where topicName = 'Maternity'");
//     db.rawDelete("DELETE FROM question where topicName = 'Med & Surg'");
//
//     db.rawUpdate(
//         "UPDATE question set topicName = 'Pharmacology' WHERE topicName = 'Pharmacological Therapies'");
//   }
//
//   _upDataASVABV4DB(Database db) async {
//     try {
//       await db.execute("ALTER TABLE topic ADD COLUMN smallTopicName TEXT");
//     } catch (e) {}
//
//     var batch = db.batch();
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'GS' WHERE topicName = 'Science'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AR' WHERE topicName = 'Arithmetic'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'WK' WHERE topicName = 'Word'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'PC' WHERE topicName = 'Paragraph'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'MK' WHERE topicName = 'Mathematics' or topicName = 'Math'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'EI' WHERE topicName = 'Electronics'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AS' WHERE topicName = 'Auto'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'MC' WHERE topicName = 'Mechanical'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AO' WHERE topicName = 'Assembling'");
//
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'General Science' WHERE topicName = 'Science'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Arithmetic Reasoning' WHERE topicName = 'Arithmetic'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Word Konwledge' WHERE topicName = 'Word'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Paragraph Comprehension' WHERE topicName = 'Paragraph'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Mathematics Knowledge' WHERE topicName = 'Mathematics' or topicName = 'Math'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Electronics Information' WHERE topicName = 'Electronics'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Auto and Shop Information' WHERE topicName = 'Auto'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Mechanical Comprehension' WHERE topicName = 'Mechanical'");
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'Assembling Objects' WHERE topicName = 'Assembling'");
//
//     batch.rawQuery(
//         "UPDATE question set topicName = 'General Science' WHERE topicName = 'Science'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Arithmetic Reasoning' WHERE topicName = 'Arithmetic'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Word Konwledge' WHERE topicName = 'Word'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Paragraph Comprehension' WHERE topicName = 'Paragraph'");
//     db.rawUpdate(
//         "UPDATE question SET topicName = 'Mathematics Knowledge' WHERE topicName = 'Mathematics'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Mathematics Knowledge' WHERE topicName = 'Mathematics' or topicName = 'Math'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Electronics Information' WHERE topicName = 'Electronics'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Auto and Shop Information' WHERE topicName = 'Auto'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Mechanical Comprehension' WHERE topicName = 'Mechanical'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'Assembling Objects' WHERE topicName = 'Assembling'");
//
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'General Science' WHERE topicName = 'Science'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Arithmetic Reasoning' WHERE topicName = 'Arithmetic'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Word Konwledge' WHERE topicName = 'Word'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Paragraph Comprehension' WHERE topicName = 'Paragraph'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Mathematics Knowledge' WHERE topicName = 'Mathematics' or topicName = 'Math'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Electronics Information' WHERE topicName = 'Electronics'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Auto and Shop Information' WHERE topicName = 'Auto'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Mechanical Comprehension' WHERE topicName = 'Mechanical'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'Assembling Objects' WHERE topicName = 'Assembling'");
//
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'General Science' WHERE topicName = 'Science'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Arithmetic Reasoning' WHERE topicName = 'Arithmetic'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Word Konwledge' WHERE topicName = 'Word'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Paragraph Comprehension' WHERE topicName = 'Paragraph'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Mathematics Knowledge' WHERE topicName = 'Mathematics' or topicName = 'Math'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Electronics Information' WHERE topicName = 'Electronics'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Auto and Shop Information' WHERE topicName = 'Auto'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Mechanical Comprehension' WHERE topicName = 'Mechanical'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'Assembling Objects' WHERE topicName = 'Assembling'");
//
//     batch.commit(continueOnError: false);
//   }
//
//   _upDataRealEstateV4DB(Database db) async {
//     try {
//       await db.execute("ALTER TABLE topic ADD COLUMN smallTopicName TEXT");
//     } catch (e) {}
//
//     var batch = db.batch();
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'Jobs' WHERE topicName = 'Real Estate Jobs'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'MB' WHERE topicName = 'Math and Business'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'LI' WHERE topicName = 'Law and Interests'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'OL' WHERE topicName = 'Ownership and Land Description'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'TR' WHERE topicName = 'Transfer and Records'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AC' WHERE topicName = 'Client Representation Agreements and Contracts'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'FI' WHERE topicName = 'Financing'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'PD' WHERE topicName = 'Practice of Real Estate and Disclosures'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AL' WHERE topicName = 'Appraisal and Leases'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'FP' WHERE topicName = 'Fair Housing and Property management'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'PE' WHERE topicName = 'Property Development and Environmental Issues'");
//     batch.commit(continueOnError: false);
//   }
//
//   _upDataEMTV4DB(Database db) async {
//     try {
//       await db.execute("ALTER TABLE topic ADD COLUMN smallTopicName TEXT");
//     } catch (e) {
//       print(e.toString());
//     }
//
//     var batch = db.batch();
//     batch.rawQuery(
//         "UPDATE topic set topicName = 'EMS' WHERE topicName = 'Operations'");
//     batch.rawQuery(
//         "UPDATE question set topicName = 'EMS' WHERE topicName = 'Operations'");
//     batch.rawQuery(
//         "UPDATE mistake set topicName = 'EMS' WHERE topicName = 'Operations'");
//     batch.rawQuery(
//         "UPDATE notes set topicName = 'EMS' WHERE topicName = 'Operations'");
//
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AR' WHERE topicName = 'Airway'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'CR' WHERE topicName = 'Cardiology'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'EMS' WHERE topicName = 'EMS'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'MD' WHERE topicName = 'Medical'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'TU' WHERE topicName = 'Trauma'");
//
//     batch.commit(continueOnError: true);
//   }
//
//   _upDataPPLV4DB(Database db) async {
//     try {
//       await db.execute("ALTER TABLE topic ADD COLUMN smallTopicName TEXT");
//     } catch (e) {}
//
//     var batch = db.batch();
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AR' WHERE topicName = 'Aerodynamics'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'FI' WHERE topicName = 'Flight Instruments'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'SC' WHERE topicName = 'Sectional Charts'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AW' WHERE topicName = 'Airspace and Weather Minimums'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'CR' WHERE topicName = 'Communications and Radar Services'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'EN' WHERE topicName = 'Electronic Navigation'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'FO' WHERE topicName = 'Flight Operations'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'WT' WHERE topicName = 'Weather'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'WB' WHERE topicName = 'Weight and Balance'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'AP' WHERE topicName = 'Aircraft Performance'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'CP' WHERE topicName = 'Cross-Country Planning'");
//     batch.rawQuery(
//         "UPDATE topic set smallTopicName = 'FG' WHERE topicName = 'Federal Aviation Regulations'");
//
//     batch.commit(continueOnError: false);
//   }
//
//   _copyAssetDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, Global.config!.dbName);
//
//     ByteData data =
//         await rootBundle.load(join("assets", Global.config!.dbName));
//     List<int> bytes =
//         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//     await new File(path).writeAsBytes(bytes);
//     // print("db write to local data dir");
//   }
//
//   // _onCreate(Database db, int version) async {
//   //   await db.execute(
//   //       "CREATE TABLE $topicTable (id INTEGER PRIMARY KEY, topicName TEXT)");
//   //   //todo state {0: 未联系， 1： 已联系 ， 2： 已标记}
//   //   await db.execute(
//   //       "CREATE TABLE $questionTable (id TEXT PRIMARY KEY, question TEXT,choices TEXT, answers TEXT, explanation TEXT,level INTEGER, image TEXT, audio TEXT, video TEXT, topicName TEXT,state INTEGER, created INTEGER, updated INTEGER)");
//   //   await db.execute(
//   //       "CREATE TABLE $scoreTable (id INTEGER PRIMARY KEY, typeName TEXT, progress REAL, scoreValue REAL, time INTEGER,created INTEGER, updated INTEGER, answered INTEGER)");
//   //   //todo state {0: 答题正确， -1： 答题错误}
//   //   await db.execute(
//   //       "CREATE TABLE $notesTable (id INTEGER PRIMARY KEY, questionId TEXT, topicName TEXT,scoreId INTEGER, userAnswer TEXT, state INTEGER, created INTEGER, updated INTEGER)");
//   //
//   //   await db.execute(
//   //       "CREATE TABLE $mistakesTable (id INTEGER PRIMARY KEY, questionId TEXT, mistakeNumb INTEGER)");
//   //
//   //   await db.execute(
//   //       "CREATE TABLE $purchaseTable (id INTEGER PRIMARY KEY, transactionId INTEGER, originalTransactionId INTEGER, itemId INTEGER, productId TEXT, purchaseDateMs INTEGER, expiresDate INTEGER)");
//   // }
//
//   selectSubjects() async {
//     if (db == null) {
//       await initDB();
//     }
//     var models = await db!.query(subjectsTable);
//     if (models.length > 0) {
//       List<Subjects> subjectList = List.empty(growable: true);
//       await Future.forEach(models, (element) async {
//         Subjects subject = Subjects.fromJson(element);
//         int countQuestion = await countQuestionBySubjectId(subject.id!);
//         int countTopic = await countTopicBySubjectId(subject.id!);
//         subject.questionCount = countQuestion;
//         subject.subjectCount = countTopic;
//         subjectList.add(subject);
//       });
//       return subjectList;
//     }
//     return null;
//   }
//
//   selectSubjectsByName(String name) async {
//     if (db == null) {
//       await initDB();
//     }
//     var models = await db!.query(subjectsTable, where: "subject = '$name'");
//     if (models.length > 0) {
//       return Subjects.fromJson(models.first);
//     }
//     return null;
//   }
//
//   ///TODO:重制数据
//   resetScore() async {
//     db!.rawQuery("DELETE FROM $notesTable;");
//     db!.rawQuery("DELETE FROM $scoreTable;");
//     db!.rawQuery("DELETE FROM $mistakesTable;");
//     db!.rawQuery(
//         "UPDATE $questionTable SET state = 0 WHERE state = 2 or state = 1;");
//   }
//
//   Batch getBath() {
//     return db!.batch();
//   }
//
//   selectTopicByTopicName(String topicName) async {
//     if (db == null) {
//       await initDB();
//     }
//     var model = await db!.query(topicTable,
//         where:
//             "topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     if (model.length < 1) {
//       return null;
//     }
//     return model;
//   }
//
//   Future<bool> insertTopic(TopicName topicName) async {
//     Map<String, Object> value = {
//       "topicName": topicName.topicName!,
//     };
//
//     var model = await selectTopicByTopicName(topicName.topicName!);
//
//     if (model.length < 1) {
//       int line = await db!.insert(topicTable, value);
//       if (line > 0) {
//         return true;
//       }
//       return false;
//     }
//     return true;
//   }
//
//   selectTopicAll() async {
//     var modelList = await db!.query(topicTable,
//         orderBy: "sec Asc",
//         where: Global.appName == MULTIPLE
//             ? "subjectId = ${Global.subjects!.id!}"
//             : "");
//
//     if (modelList.length > 0) {
//       List<TopicName> topicList = List.empty(growable: true);
//       modelList.forEach((element) {
//         topicList.add(TopicName.fromJson(element));
//       });
//       return topicList;
//     }
//     return null;
//   }
//
//   countTopic() async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $topicTable where ${Global.appName == MULTIPLE ? "subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   countQuestion() async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $questionTable where ${Global.appName == MULTIPLE ? "subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   countQuestionBySubjectId(int subjectId) async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $questionTable where subjectId = $subjectId");
//     return count.first.values.first;
//   }
//
//   selectQuestionCountByState(int state, String topicName) async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $questionTable WHERE state = $state and topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   selectNoteCountByState(int state, String topicName) async {
//     // print("=====_getInstance=====selectNoteCountByState");
//
//     var count = await db!.rawQuery(
//         "SELECT DISTINCT questionId FROM $notesTable WHERE state = $state and topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.length;
//   }
//
//   insertQuestion(QuestionModel questionModel) async {
//     Map<String, Object> value = {
//       "id": questionModel.id!,
//       "question": "${questionModel.question!}",
//       "choices": questionModel.choices!.toString(),
//       "answers": "${questionModel.answer!.toString()}",
//       "explanation": questionModel.explanation!,
//       "level": questionModel.level ?? "0",
//       "image": questionModel.image ?? "",
//       "audio": questionModel.audio ?? "",
//       "video": questionModel.video ?? "",
//       "topicName": questionModel.topicName ?? "",
//       "subjectId": questionModel.subjectId ?? Global.subjects!.id!,
//       "state": "0",
//       "created": DateTime.now().millisecondsSinceEpoch,
//       "updated": DateTime.now().millisecondsSinceEpoch,
//     };
//
//     var model =
//         await db!.query(questionTable, where: "id = \"${questionModel.id}\"");
//
//     if (model.isEmpty) {
//       int line = await db!.insert(questionTable, value);
//       if (line > 0) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   selectQuestionById(String id) async {
//     var modelList = await db!.query(questionTable, where: "id = \"$id\"");
//     if (modelList.length > 0) {
//       return QuestionModel.fromDB(modelList.first);
//     }
//     return null;
//   }
//
//   selectQuestionListForAnswerPager(ListModel listModel) async {
//     var modelList = [];
//     List<QuestionModel> questionList = List.empty(growable: true);
//
//     // print("${listModel.toString()}");
//
//     switch (listModel.type) {
//       case ListModel.typeStudySubjects:
//         modelList = await db!.query(questionTable,
//             where:
//                 "topicName = \"${listModel.topicName}\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//             limit: 20,
//             //TODO:题目顺序、选项顺序都是随机的
//             orderBy: "RANDOM()",
//             offset: listModel.index! * 20);
//         break;
//
//       case ListModel.typeStudyTests:
//         modelList = await db!.query(questionTable,
//             where:
//                 "model = \"${listModel.topicName}\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//             orderBy: "RANDOM()");
//         break;
//
//       case ListModel.typeCust:
//         List<String>? topics = listModel.topicName?.split(",");
//
//         if (topics == null) {
//           modelList = await db!.query(questionTable,
//               orderBy: "RANDOM()", limit: listModel.index);
//         } else {
//           String where =
//               "topicName = \'${topics.first}\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}";
//           topics.forEach((element) {
//             where +=
//                 " or topicName = \'$element\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}";
//           });
//
//           modelList = await db!.query(questionTable,
//               orderBy: "RANDOM()", limit: listModel.index, where: where);
//         }
//         break;
//
//       case ListModel.typeHistory:
//         break;
//
//       case ListModel.typeMistake:
//         var mistakeList = await db!.query(mistakesTable,
//             where:
//                 "mistakeNumb < 2 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//             orderBy: "RANDOM()",
//             limit: listModel.index!);
//
//         await Future.forEach(mistakeList, (element) async {
//           Mistake mistake = Mistake.fromJson(element);
//           QuestionModel question =
//               await selectQuestionById(mistake.questionId!);
//           questionList.add(question);
//         });
//         break;
//
//       case ListModel.typeTimeQuick:
//         if (!PurchaseManage.instance.isSub) {
//           modelList = await db!.query(questionTable,
//               where:
//                   "${Global.appName == MULTIPLE ? "subjectId = ${Global.subjects!.id!}" : "level = -1"} or level = 0 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//               orderBy: "RANDOM()",
//               limit: 60);
//         } else {
//           modelList =
//               await db!.query(questionTable, orderBy: "RANDOM()", limit: 60);
//         }
//         break;
//
//       case ListModel.typeQuick:
//
//         ///TODO:区分订阅非订阅用户
//         if (!PurchaseManage.instance.isSub) {
//           modelList = await db!.query(questionTable,
//               orderBy: "RANDOM()", limit: 10, where: "${Global.appName == MULTIPLE ? "subjectId = ${Global.subjects!.id!}" : "level = -1 "}");
//         } else {
//           modelList =
//               await db!.query(questionTable, orderBy: "RANDOM()", limit: 10);
//         }
//         print("modelList======${modelList.length}");
//         break;
//
//       ///TODO:默认固定20道题目
//       case ListModel.typeQuickForStudy:
//         modelList =
//             await db!.query(questionTable, limit: 20, where: "level = -1 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//         if (modelList.length < 20) {
//           modelList = await db!.query(questionTable, limit: 20);
//         }
//         break;
//
//       case ListModel.typeSimulation:
//         if (Global.getSelectAppName() == NCLEX_PN) {
//           modelList = await db!.query(questionTable,
//               where: "model=\'Full Test ${Random().nextInt(2) + 1}\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//               orderBy: "RANDOM()");
//         } else if (Global.getSelectAppName() == NCLEX_RN) {
//           modelList = await db!.query(questionTable,
//               where: "model=\'Full Test ${Random().nextInt(2) + 1}\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//               orderBy: "RANDOM()");
//         } else if (Global.getSelectAppName() == EMT) {
//           modelList = await db!.query(questionTable,
//               where: "model=\'Full Test ${Random().nextInt(3) + 1}\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//               orderBy: "RANDOM()");
//         } else if (Global.getSelectAppName() != PPL &&
//             Global.getSelectAppName() != ATI) {
//           modelList = await db!.query(questionTable,
//               where: "model=\'Full Test ${Random().nextInt(3) + 1}\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//               orderBy: "RANDOM()");
//         } else if (Global.getSelectAppName() == PPL) {
//           modelList = await db!.query(questionTable,
//               where: "model=\'Full Test ${Random().nextInt(3) + 1}\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//               orderBy: "RANDOM()");
//         } else {
//           modelList = await db!.query(questionTable,
//               where: "model = \"Full Test ${Random().nextInt(4)}\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}",
//               orderBy: "RANDOM()");
//         }
//
//         break;
//
//       case ListModel.typeWeak:
//         modelList = await db!.query(questionTable,
//             orderBy: "RANDOM()",
//             limit: listModel.index,
//             where: "topicName = \"${listModel.topicName}\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//         break;
//     }
//
//     if (modelList.length > 0) {
//       modelList.forEach((element) {
//         questionList.add(QuestionModel.fromDB(element));
//       });
//     }
//
//     return questionList;
//   }
//
//   insertTestModel(QuestionModel questionModel) async {
//     Map<String, Object> value = {
//       "id": questionModel.id!,
//       "question": "${questionModel.question!}",
//       "choices": questionModel.choices!.toString(),
//       "answers": questionModel.answer!.toString(),
//       "explanation": questionModel.explanation!,
//       "level": questionModel.level ?? 0,
//       "image": questionModel.image ?? "",
//       "audio": questionModel.audio ?? "",
//       "video": questionModel.video ?? "",
//       "topicName": questionModel.topicName ?? "",
//       "subjectId": questionModel.subjectId ?? Global.subjects!.id!,
//       "state": 0,
//       "model": questionModel.model ?? "",
//       "created": DateTime.now().millisecondsSinceEpoch,
//       "updated": DateTime.now().millisecondsSinceEpoch,
//     };
//
//     var model =
//         await db!.query(questionTable, where: "id = \"${questionModel.id}\"");
//
//     if (model.isEmpty) {
//       int line = await db!.insert(questionTable, value);
//       if (line > 0) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   selectTestByid(String id) async {
//     var model = await db!.query(questionTable, where: "id = \"$id\"");
//     if (model.length > 0) {
//       return QuestionModel.fromDB(model.first);
//     }
//     return null;
//   }
//
//   selectTestListByModel(String model) async {
//     var modelList = await db!.query(questionTable, where: "model = \"$model\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     if (modelList.length > 0) {
//       List<QuestionModel> questionList = List.empty(growable: true);
//       modelList.forEach((element) {
//         questionList.add(QuestionModel.fromDB(element));
//       });
//       return questionList;
//     }
//     return null;
//   }
//
//   Future<List<ListModel>> selectHomeList(
//       {String? topicName, bool showTest = true}) async {
//     List<ListModel> list = List.empty(growable: true);
//     // print("=====_getInstance=====selectHomeList");
//
//     List<TopicName>? topicList;
//     if (topicName != null) {
//       if (topicName == "ALL") {
//         topicList = await selectTopicAll();
//       } else {
//         topicList = [TopicName(topicName: topicName)];
//       }
//     }
//
//     if (topicList != null) {
//       await Future.forEach(topicList, (TopicName topic) async {
//         int count = await countQuestionTableByTopic(topic.topicName!);
//         int group = (count / 20).round();
//         var index = 0;
//
//         while (index <= group) {
//           var listCount = count - (index * 20);
//
//           if (listCount >= 20) {
//             listCount = 20;
//           } else if (listCount <= 0) {
//             return;
//           }
//
//           list.add(ListModel(
//               count: listCount,
//               topicName: topic.topicName,
//               titleName: "${topic.topicName} ${index + 1}",
//               index: index,
//               type: ListModel.typeStudySubjects));
//
//           index++;
//         }
//       });
//     }
//
//     if (showTest) {
//       var index = 1;
//
//       ///TODO:ppl暂时没有真题先关闭
//       if (Global.getSelectAppName() == ASVAB) {
//         while (index < 4) {
//           String model = "Full Test $index";
//           int testCount = await countTestTable(model);
//           list.add(ListModel(
//               count: testCount,
//               topicName: model,
//               titleName: model,
//               index: index,
//               type: ListModel.typeStudyTests));
//           index++;
//         }
//       } else if (Global.getSelectAppName() == REAL_ESTATE) {
//         while (index < 5) {
//           String model = "Full Test $index";
//           int testCount = await countTestTable(model);
//           list.add(ListModel(
//               count: testCount,
//               topicName: model,
//               titleName: model,
//               index: index,
//               type: ListModel.typeStudyTests));
//           index++;
//         }
//       } else if (Global.getSelectAppName() == PPL) {
//         while (index < 4) {
//           String model = "Full Test $index";
//           int testCount = await countTestTable(model);
//           list.add(ListModel(
//               count: testCount,
//               topicName: model,
//               titleName: model,
//               index: index,
//               type: ListModel.typeStudyTests));
//           index++;
//         }
//       } else if (Global.getSelectAppName() == ATI) {
//         while (index < 5) {
//           String model = "Full Test $index";
//           int testCount = await countTestTable(model);
//           list.add(ListModel(
//               count: testCount,
//               topicName: model,
//               titleName: model,
//               index: index,
//               type: ListModel.typeStudyTests));
//           index++;
//         }
//       } else if (Global.getSelectAppName() == EMT) {
//         while (index < 4) {
//           String model = "Full Test $index";
//           int testCount = await countTestTable(model);
//           list.add(ListModel(
//               count: testCount,
//               topicName: model,
//               titleName: model,
//               index: index,
//               type: ListModel.typeStudyTests));
//           index++;
//         }
//       } else if (Global.getSelectAppName() == NCLEX_PN ||
//           Global.getSelectAppName() == NCLEX_RN) {
//         while (index < 3) {
//           String model = "Full Test $index";
//           int testCount = await countTestTable(model);
//           list.add(ListModel(
//               count: testCount,
//               topicName: model,
//               titleName: model,
//               index: index,
//               type: ListModel.typeStudyTests));
//           index++;
//         }
//       } else if (Global.getSelectAppName() == PMP) {
//         while (index < 4) {
//           String model = "Full Test $index";
//           int testCount = await countTestTable(model);
//           list.add(ListModel(
//               count: testCount,
//               topicName: model,
//               titleName: model,
//               index: index,
//               type: ListModel.typeStudyTests));
//           index++;
//         }
//       }
//     }
//
//     return list;
//   }
//
//   countQuestionTableByTopic(String topicName) async {
//     // print("=====_getInstance=====countQuestionTableByTopic");
//
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $questionTable WHERE topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   countQuestionTableByTopicHome(String topicName) async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $questionTable WHERE topicName = \"$topicName\" and state = 1 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""} or state = 2 and topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   countTopicBySubjectId(int subjectId) async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $topicTable WHERE subjectId = $subjectId;");
//     return count.first.values.first;
//   }
//
//   countTestTable(String model) async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $questionTable WHERE model = \"$model\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   selectTopicProgress() async {
//     int progress = 0;
//     List<SubjectProgress> list = await selectQuestionProgress();
//
//     await Future.forEach(list, (SubjectProgress value) {
//       int subjectsProgress = 0;
//       if (value.count != 0) {
//         subjectsProgress = (value.progress! / value.count! * 100).round();
//       }
//
//       if (subjectsProgress == 100) {
//         progress++;
//       }
//     });
//     return progress;
//   }
//
//   selectQuestionProgress() async {
//     List<SubjectProgress> progressList = List.empty(growable: true);
//
//     List<TopicName>? topicList = await selectTopicAll();
//
//     if (topicList != null) {
//       await Future.forEach(topicList, (TopicName topic) async {
//         int progress = await selectQuestionCountByState(1, topic.topicName!);
//         int count = await countQuestionTableByTopic(topic.topicName!);
//
//         progressList.add(SubjectProgress(
//             topicName: topic.topicName, progress: progress, count: count));
//       });
//     }
//
//     return progressList;
//   }
//
//   selectQuestionProgressHome() async {
//     List<SubjectProgress> progressList = List.empty(growable: true);
//     List<TopicName>? topicList = await selectTopicAll();
//
//     if (topicList != null) {
//       await Future.forEach(topicList, (TopicName topic) async {
//         int progress = await countTopicMistake(topic.topicName!);
//         int count = await countQuestionTableByTopicHome(topic.topicName!);
//
//         progressList.add(SubjectProgress(
//             smallTopicName: topic.smallTopicName,
//             topicName: topic.topicName,
//             progress: count - progress,
//             count: count));
//       });
//     }
//
//     return progressList;
//   }
//
//   Future<double> selectAverageScore() async {
//     double score = 0;
//
//     var list = await db!.query(scoreTable, limit: 10, where: Global.appName == MULTIPLE ? " subjectId = ${Global.subjects!.id!}" : "",orderBy: "created Desc");
//     print("${list.toString()}");
//     if (list.length > 0) {
//       list.forEach((element) {
//         score += Score.fromJson(element).scoreValue ?? 0;
//       });
//     }
//
//     if (score == 0 || list.length == 0) {
//       return 0;
//     }
//
//     var progress = (score / list.length).toStringAsFixed(2);
//
//     // print("progress = ${progress}");
//
//     return double.parse(progress);
//   }
//
//   selectNotesByScoreId(int scoreId) async {
//     var list = await db!.query(notesTable, where: "scoreId = $scoreId ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     if (list.length > 0) {
//       List<Notes> modeList = List.empty(growable: true);
//       list.forEach((element) async {
//         Notes notes = Notes.fromJson(element);
//         QuestionModel question = await selectQuestionById(notes.questionId!);
//         notes.setQuestion = question;
//         modeList.add(notes);
//       });
//       return modeList;
//     }
//     return null;
//   }
//
//   Future<List<Notes>?> selectNotesByQuestionId(String questionId,
//       {int? state}) async {
//     String where = "questionId = \"$questionId\"";
//
//     if (state != null) {
//       where += " and state = $state";
//     }
//     // print(where);
//
//     var list =
//         await db!.query(notesTable, where: where, orderBy: "created Desc");
//
//     if (list.length > 0) {
//       List<Notes> modeList = List.empty(growable: true);
//       list.forEach((element) async {
//         Notes notes = Notes.fromJson(element);
//         modeList.add(notes);
//       });
//       return modeList;
//     }
//     return null;
//   }
//
//   Future<Notes?> selectNotesByQuestionIdDic(String questionId,
//       {int? state}) async {
//     String notesSQL =
//         "select * from $notesTable where questionId = \"$questionId\"";
//     if (state != null) {
//       notesSQL += " and state = $state";
//     }
//     // print(where);
//     notesSQL += " order by created Desc";
//
//     var list = await db!.rawQuery(notesSQL);
//
//     if (list.length > 0) {
//       return Notes.fromJson(list.first);
//     }
//     return null;
//   }
//
//   deleteScoreById(int id) async {
//     await db!.delete(scoreTable, where: "id=$id");
//     await db!.delete(notesTable, where: "scoreId = $id");
//   }
//
//   selectSubjectProgressByScore(int scoreId, String topicName) async {
//     var selectProgress = await db!.rawQuery(
//         "SELECT count(*) FROM $notesTable WHERE scoreId = $scoreId and topicName = \"$topicName\" and state = 0 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//
//     var selectCount = await db!.rawQuery(
//         "SELECT count(*) FROM $notesTable WHERE scoreId = $scoreId and topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//
//     print("$topicName : ${selectProgress.toString()}");
//     print("$topicName : ${selectCount.toString()}");
//
//     int progres = int.parse(selectProgress.first.values.first.toString());
//     int count = int.parse(selectCount.first.values.first.toString());
//
//     print("progres==========$progres");
//
//     return SubjectProgress(
//         topicName: topicName, progress: progres, count: count);
//   }
//
//   selectNotesByTopicName(String topicName) async {
//     var list = await db!.query(notesTable, where: "topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     if (list.length > 0) {
//       List<Notes> modeList = List.empty(growable: true);
//       list.forEach((element) async {
//         Notes notes = Notes.fromJson(element);
//         QuestionModel question = await selectQuestionById(notes.questionId!);
//         notes.setQuestion = question;
//       });
//       return modeList;
//     }
//
//     return null;
//   }
//
//   selectScoreId() async {
//     var id = await db!.rawQuery("SELECT count(*) FROM $scoreTable ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//     return id.first.values.first ?? 0 + 1;
//   }
//
//   updateQuestionState(String id, int state) async {
//     QuestionModel question = await selectQuestionById(id);
//     // print("question = ${question.toString()}");
//     if (question.state != 2) {
//       Map<String, Object> values = {"state": state};
//       int line = await db!.update(questionTable, values, where: "id = \"$id\"");
//       // print("update :$line");
//     }
//   }
//
//   insertScore(String topicName, List<QuestionModel> questions, int time,
//       double scoreValue) async {
//     var batch = DBUtils.getInstance().getBath();
//     int id = await DBUtils.getInstance().selectScoreId();
//     print("scoreId = $id");
//
//     int c = questions.length;
//     int p = 0;
//     questions.forEach((element) {
//       if (element.userAnswer != null) {
//         p++;
//         insertMistake(element);
//       }
//     });
//
//     Map<String, Object?> score = {
//       "id": id,
//       "typeName": topicName,
//       "time": time,
//       "scoreValue": scoreValue,
//       "subjectId": Global.subjects!.id!,
//       "created": DateTime.now().millisecondsSinceEpoch,
//       "updated": DateTime.now().millisecondsSinceEpoch,
//       "answered": (p / c).round(),
//     };
//
//     int count = questions.length;
//     int right = 0;
//
//     questions.forEach((element) {
//       if (element.isRight != null) {
//         print("save question : = ${element.toString()}");
//
//         updateQuestionState(element.id!, 1);
//
//         Map<String, Object> value = {
//           "questionId": element.id!,
//           "topicName": element.topicName!,
//           "userAnswer": jsonEncode(element.userAnswer),
//           "state": element.isRight!,
//           "scoreId": id,
//           "subjectId": element.subjectId?? Global.subjects!.id!,
//           "created": DateTime.now().millisecondsSinceEpoch,
//           "updated": DateTime.now().millisecondsSinceEpoch
//         };
//
//         if (element.isRight! == 0) {
//           right++;
//         }
//
//         batch.insert(notesTable, value);
//       }
//     });
//
//     score["progress"] = right / count;
//
//     batch.insert(scoreTable, score);
//     batch.commit(continueOnError: false);
//
//     return Score.fromJson(score);
//   }
//
//   insertMistake(QuestionModel element) async {
//     var mistake =
//         await db!.query(mistakesTable, where: "questionId = \"${element.id}\"");
//     if (mistake.isNotEmpty) {
//       Mistake mistakeModel = Mistake.fromJson(mistake.first);
//       if (element.isRight! == 0) {
//         if (mistakeModel.mistakeNumb! + 1 > 2) {
//           db!.delete(mistakesTable, where: "id = ${mistakeModel.id}");
//         } else {
//           Map<String, Object> mistakeValue = {
//             "questionId": element.id!,
//             "subjectId": element.subjectId?? Global.subjects!.id!,
//             "topicName": element.topicName!
//           };
//           mistakeValue["mistakeNumb"] = mistakeModel.mistakeNumb! + 1;
//           await db!.update(mistakesTable, mistakeValue,
//               where: "id = ${mistakeModel.id}");
//         }
//       } else {
//         Map<String, Object> mistakeValue = {
//           "questionId": element.id!,
//           "subjectId": element.subjectId?? Global.subjects!.id!,
//           "topicName": element.topicName!
//         };
//         mistakeValue["mistakeNumb"] = 0;
//         await db!.update(mistakesTable, mistakeValue,
//             where: "id = ${mistakeModel.id}");
//       }
//     } else {
//       if (element.isRight! != 0) {
//         Map<String, Object> mistakeValue = {
//           "questionId": element.id!,
//           "subjectId": element.subjectId?? Global.subjects!.id!,
//           "topicName": element.topicName!
//         };
//         mistakeValue["mistakeNumb"] = 0;
//         await db!.insert(mistakesTable, mistakeValue);
//       }
//     }
//   }
//
//   countNotes() async {
//     var count = await db!.rawQuery("SELECT count(*) FROM $notesTable where ${Global.appName == MULTIPLE ? "subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   //===============review:-1:错误；0：正确；1：标记===============
//   selectReviewAll(int? state) async {
//     // print("=====_getInstance=====selectReviewAll");
//     List<Notes> noteList = List.empty(growable: true);
//     //-1
//     if (state == null) {
//       var mistakdList = await db!.query(questionTable);
//
//       mistakdList.forEach((element) async {
//         var noteList = await db!.query(notesTable,
//             where: "questionId = \"${element["id"]}\"",
//             orderBy: "updated Desc");
//         if (noteList.isNotEmpty) {
//           // noteList.add(noteList.first);
//         }
//       });
//     } else {
//       var mistakdList = await db!.query(questionTable, where: "state = $state ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//
//       mistakdList.forEach((element) async {
//         var noteList = await db!.query(notesTable,
//             where: "questionId = \"${element["id"]}\"",
//             orderBy: "updated Desc");
//
//         noteList.add(noteList.first);
//       });
//     }
//
//     return noteList;
//   }
//
//   countQuestionTableByNotes(String topicName) async {
//     var count = await db!.rawQuery(
//         "SELECT count(*) FROM $notesTable WHERE topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""};");
//     return count.first.values.first;
//   }
//
//   selectAllQuestionProgress() async {
//     // print("=====_getInstance=====selectAllQuestionProgress");
//     var list = await selectHomeList(topicName: "ALL");
//
//     var score = await db!.rawQuery(
//         "SELECT DISTINCT typeName FROM $scoreTable WHERE answered = 1 and typeName != \"$Quick_10_Test\" and typeName != \"$Missed_Questions_Test\" and typeName != \"$Weak_Subjects_Test\" and typeName != \"$Simulation_Test\" and typeName != \"$Customized_Test\" and typeName != \"$Timed_Test\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//
//     return SubjectProgress(
//         topicName: "ALL", progress: score.length, count: list.length + 1);
//   }
//
//   countAllMistake() async {
//     var count = await db!
//         .rawQuery("SELECT * FROM $mistakesTable where mistakeNumb < 2 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     return count.length;
//   }
//
//   countTopicMistake(String topicName) async {
//     var count = await db!.rawQuery(
//         "SELECT * FROM $mistakesTable where mistakeNumb < 2 and topicName = \'$topicName\' ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     return count.length;
//   }
//
//   countAllAnswerQuestion() async {
//     var count =
//         await db!.query(questionTable, where: "state != 0 and state NOT NULL ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     return count.length;
//   }
//
//   countAllRight() async {
//     var count = await db!.rawQuery(
//         "SELECT DISTINCT questionId,count(*) FROM $notesTable WHERE state = 0 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     print("=======count=======${count.first["count(*)"]}");
//     return count.first["count(*)"];
//   }
//
//   selectAllScoreProgress() async {
//     // print("=====_getInstance=====selectAllQuestionProgress");
//     var list = await db!.rawQuery(
//         "SELECT DISTINCT typeName , id, progress, scoreValue, time, created, updated FROM $scoreTable where ${Global.appName == MULTIPLE ? "subjectId = ${Global.subjects!.id!} " : ""} ORDER BY created DESC");
//     // print("!!!!!!!!!!!!!!! ${list.toString()}");
//
//     if (list.length > 0) {
//       List<Score> modeList = List.empty(growable: true);
//
//       list.forEach((element) async {
//         Score score = Score.fromJson(element);
//         modeList.add(score);
//       });
//       return modeList;
//     }
//
//     return;
//   }
//
//   selectAllScoreProgressForStudyItem(String typeName) async {
//     var list = await db!.rawQuery(
//         "select * from $scoreTable where typeName = '$typeName' order by created desc limit  1");
//     // print("!!!!!!!!!!!$typeName!!!! ${list.toString()}");
//
//     if (list.length > 0) {
//       Score score = Score.fromJson(list.first);
//       return score;
//     }
//
//     return Score();
//   }
//
//   selectScoreByTopicName(String topicName, int limit) async {
//     var list = await db!.query(scoreTable,
//         where: "typeName like \"$topicName%\"",
//         orderBy: "created Desc",
//         limit: limit);
//     print("=====study list topicName=====${topicName}");
//     if (list.length > 0) {
//       List<Score> modeList = List.empty(growable: true);
//
//       list.forEach((element) async {
//         Score score = Score.fromJson(element);
//         modeList.add(score);
//       });
//       print("==========${modeList.toString()}");
//
//       return modeList;
//     }
//     print("=====study list =====null");
//
//     return null;
//   }
//
//   selectMistTakeByQuestionId(questionId) async {
//     var mistake =
//         await db!.query(mistakesTable, where: "questionId = \"$questionId\"");
//     if (mistake.length > 0) {
//       return Mistake.fromJson(mistake.first);
//     }
//     return null;
//   }
//
//   selectAllMistakeQuestion() async {
//     String where = "state = 2 or state = 1";
//
//     var questionList = await db!.query(questionTable, where: where);
//
//     if (questionList.length > 0) {
//       List<QuestionModel> questions = List.empty(growable: true);
//
//       await Future.forEach(questionList, (element) async {
//         QuestionModel question = QuestionModel.fromDB(element);
//
//         Notes? notes =
//             await selectNotesByQuestionIdDic(question.id!, state: null);
//
//         if (notes != null) {
//           List<dynamic> userAnswer = jsonDecode(notes.userAnswer!);
//           question.setUserAnswer = userAnswer;
//           question.setIsRight = notes.state!;
//           questions.add(question);
//         }
//       });
//
//       return questions;
//     }
//   }
//
//   selectScroeQuestion(String scoreId) async {
//     var notes = await db!.query(notesTable, where: "scoreId = $scoreId");
//     List<QuestionModel> list = List.empty(growable: true);
//
//     if (notes.length > 0) {
//       await Future.forEach(notes, (Map note) async {
//         QuestionModel model = await selectQuestionById(note["questionId"]);
//         list.add(model);
//       });
//     }
//     return list;
//   }
//
//   selectHistoryQuestion(String topicName,
//       {bool isFlag = false, int? state}) async {
//     String where = "topicName = \"$topicName\" and state = 2 ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}";
//     if (!isFlag) {
//       where += " or state = 1 and topicName = \"$topicName\" ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}";
//     }
//
//     var questionList = await db!.query(questionTable, where: where);
//
//     if (questionList.length > 0) {
//       List<QuestionModel> questions = List.empty(growable: true);
//
//       await Future.forEach(questionList, (element) async {
//         QuestionModel question = QuestionModel.fromDB(element);
//
//         Notes? notes =
//             await selectNotesByQuestionIdDic(question.id!, state: state);
//
//         if (state != 0) {
//           if (notes != null) {
//             if (notes.state! == 0) {
//               Mistake? mistake = await selectMistTakeByQuestionId(question.id!);
//
//               if (mistake != null) {
//                 question.setIsRight = -1;
//               } else {
//                 question.setIsRight = notes.state!;
//               }
//             } else {
//               question.setIsRight = notes.state!;
//             }
//
//             List<dynamic> userAnswer = jsonDecode(notes.userAnswer!);
//             question.setUserAnswer = userAnswer;
//             questions.add(question);
//           }
//         } else {
//           Mistake? mistake = await selectMistTakeByQuestionId(question.id!);
//           if (mistake == null) {
//             if (notes != null) {
//               List<dynamic> userAnswer = jsonDecode(notes.userAnswer!);
//               question.setIsRight = 0;
//               question.setUserAnswer = userAnswer;
//               questions.add(question);
//             }
//           }
//         }
//       });
//
//       return questions;
//     }
//   }
//
//   selectQuestionByScoreId(int scoreId) async {
//     var notes = await db!.query(notesTable, where: "scoreId = $scoreId ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     if (notes.length > 0) {
//       List<QuestionModel> questions = List.empty(growable: true);
//       await Future.forEach(notes, (element) async {
//         Notes note = Notes.fromJson(element);
//         var question = await selectQuestionById(note.questionId!);
//         if (question != null && notes.isNotEmpty) {
//           questions.add(question);
//         }
//       });
//
//       return questions;
//     }
//   }
//
//   selectHistoryQuestionByScoreId(int scoreId) async {
//     var notes = await db!.query(notesTable, where: "scoreId = $scoreId ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//     if (notes.length > 0) {
//       List<QuestionModel> questions = List.empty(growable: true);
//       await Future.forEach(notes, (element) async {
//         Notes note = Notes.fromJson(element);
//         var question = await selectQuestionById(note.questionId!);
//         if (question != null && notes.isNotEmpty) {
//           List<dynamic> userAnswer = jsonDecode(note.userAnswer!);
//           question.setUserAnswer = userAnswer;
//           question.setIsRight = note.state!;
//           questions.add(question);
//         }
//       });
//
//       return questions;
//     }
//   }
//
//   Future<List<TopicName>?> selectHistorySubjectByScoreId(int scoreId) async {
//     List<TopicName> topicList = [];
//     var list = await db!.rawQuery(
//         "SELECT DISTINCT topicName FROM $notesTable WHERE scoreId = $scoreId");
//     await Future.forEach(list, (Map element) async {
//       print("topicName = ${element["topicName"]}");
//       List<Map<String, Object?>> topic =
//           await selectTopicByTopicName(element["topicName"]);
//       topicList.add(TopicName.fromJson(topic.first));
//     });
//     return topicList;
//   }
//
//   selectPurchaseById(int transactionId) async {
//     var purchase =
//         await db?.query(purchaseTable, where: "transactionId = $transactionId ${Global.appName == MULTIPLE ? "and subjectId = ${Global.subjects!.id!}" : ""}");
//
//     if (purchase == null || purchase.isEmpty) {
//       return null;
//     }
//     return purchase.first;
//   }
//
//   insertAndUpdatePurchase(IOSVerifyNewData purchaseInfo) async {
//     Map<String, Object> values = {
//       "transactionId": int.parse(purchaseInfo.transaction_id == null
//           ? "0"
//           : purchaseInfo.transaction_id!),
//       "originalTransactionId": int.parse(
//           purchaseInfo.original_transaction_id == null
//               ? "0"
//               : purchaseInfo.original_transaction_id!),
//       "itemId": int.parse(purchaseInfo.web_order_line_item_id == null
//           ? "0"
//           : purchaseInfo.web_order_line_item_id!),
//       "productId":
//           purchaseInfo.product_id == null ? "0" : purchaseInfo.product_id!,
//       "purchaseDateMs": int.parse(purchaseInfo.purchase_date_ms == null
//           ? "0"
//           : purchaseInfo.purchase_date_ms!),
//       "expiresDate": int.parse(purchaseInfo.expires_date_ms == null
//           ? "-1"
//           : purchaseInfo.expires_date_ms!),
//     };
//
//     await db?.insert(purchaseTable, values);
//   }
// }
