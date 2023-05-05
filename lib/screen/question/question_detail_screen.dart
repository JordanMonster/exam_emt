import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:questionhub/commons/log/ccy_logs.dart';
import 'package:questionhub/commons/model/score_model.dart';
import 'package:questionhub/commons/routes/route_name.dart';
import 'package:questionhub/main.dart';
import 'package:questionhub/screen/home/home_tab_screen.dart';
import 'package:questionhub/screen/question/question_bottom_bar.dart';
import 'package:questionhub/screen/question/question_select.dart';
import 'package:questionhub/screen/question/question_tool_bar.dart';

import '../../commons/db/db_manager.dart';
import '../../commons/model/list_model.dart';
import '../../commons/model/question_model.dart';
import '../../data/data_manager.dart';

import 'package:provider/provider.dart';

class QuestionDetailPage extends StatefulWidget {
  final ListModel testModel;

  const QuestionDetailPage({Key? key, required this.testModel})
      : super(key: key);

  @override
  _QuestionDetailPage createState() => _QuestionDetailPage();
}

class _QuestionDetailPage extends State<QuestionDetailPage> {
  final QuestionDetailModule _module = QuestionDetailModule();
  final ScrollController _pageController = ScrollController();

  int? timeCount;

  void _initData() async {
    DBManager.getInstance()
        .selectQuestionByListModel(widget.testModel)
        .then((value) {
      if (value != null) {
        _module.multiSelectList.addAll(value);

        _initChoices(_module.question);
        if (_module.question.isRight == null) {
          _module.isExpandDescription = false;
        } else {
          _module.isExpandDescription = true;
        }
      }
    });
    if (widget.testModel.type == ListModel.typeTimeQuick){
      timeCount = widget.testModel.minutes! * 60;
      timeCount = timeCount! + widget.testModel.hour! * 60 * 60;
    }

    _module.timer ??= Timer.periodic(_module.duration, (Timer t) {
      handleTick();
    });
  }

  void handleTick() {
    if(_module.isActive){
      _module.secondsPassed = (_module.secondsPassed + 1);
      if (widget.testModel.type == ListModel.typeTimeQuick &&
          _module.secondsPassed == timeCount) {
        _saveThisTest();
      }
    }
  }

  //单选还是多选
  _initChoices(QuestionModel question) {
    _module.isSingleChoices = (!(question.answers!.length > 1));
    if (null == question.userAnswer) {
      question.setUserAnswer = [];
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => _module,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: QuestionToolBar(
              title: widget.testModel.titleName ?? "test",
              onRestart: () {
                _initChoices(_module.question);
                _pageController.jumpTo(0);
              },
              onSubmit: () {
                _saveThisTest();
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: QuestionSelect(
                controller: _pageController,
              )),
              Container(
                height: 1,
                color: Colors.grey.shade300,
              ),
              QuestionBottomBar(
                onTap: () {
                  _initChoices(_module.question);
                  _pageController.jumpTo(0);
                },
                onNext: () {
                  _initChoices(_module.question);
                },
                onSubmit: () {
                  _saveThisTest();
                },
              )
            ],
          ),
        ));
  }

  _saveThisTest() async {
    ScoreModel score = await DBManager.getInstance().saveScore(
        widget.testModel.titleName!,
        _module.multiSelectList,
        _module.secondsPassed);

    score.setQuestions = _module.multiSelectList;
    score.setMultiSelectListLength = _module.questionTotal;

    _module.timer?.cancel();
    _module.timer = null;

    Navigator.of(context)
        .pushNamed(scoreScreen, arguments: score)
        .then((value) {
      homeTabGlobalKey.currentState?.setState(() {});
      if (value != null) {
        value as bool;
        if (value) {
          // _clearTest();
          Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
        } else {
          Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
        }
      } else {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
      }
    });
  }

  int beginStartClock() {
    _module.secondsPassed =
        ((widget.testModel.count == null ? 0 : widget.testModel.count!) * 60);
    return _module.secondsPassed;
  }

  @override
  void dispose() {
    _module.multiSelectList.clear();
    _module.timer?.cancel();
    _module.timer = null;
    super.dispose();
  }
}
