import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:questionhub/commons/model/score_model.dart';
import 'package:questionhub/commons/routes/route_name.dart';
import 'package:questionhub/main.dart';
import 'package:questionhub/screen/home/home_tab_screen.dart';
import 'package:questionhub/screen/question/widget/question_choice_card.dart';
import 'package:questionhub/screen/question/widget/question_indicator.dart';
import 'package:questionhub/screen/widget/rich_string.dart';

import '../../commons/db/db_manager.dart';
import '../../commons/model/list_model.dart';
import '../../commons/model/question_model.dart';
import '../../utils/screen_utils.dart';

class QuestionDetailPage extends StatefulWidget {
  final ListModel testModel;

  const QuestionDetailPage({Key? key, required this.testModel})
      : super(key: key);

  @override
  _QuestionDetailPage createState() => _QuestionDetailPage();
}

class _QuestionDetailPage extends State<QuestionDetailPage> {
  int position = 0;
  List<QuestionModel> multiSelectList = [];
  bool isSingleChoices = false;

  var duration = const Duration(hours: 0, minutes: 0, seconds: 0);
  bool isActive = true;

  bool isExpandDescription = false;
  bool needShowPop = false;

  int secondsPassed = 0;
  Timer? timer;

  int answered = 0;

  final ScrollController _controller = ScrollController();
  final ScrollController _pageController = ScrollController();

  void _initData() async {
    DBManager.getInstance()
        .selectQuestionByListModel(widget.testModel)
        .then((value) {
      if (value != null) {
        multiSelectList = value;
        _initChoices(multiSelectList[position]);
        if (multiSelectList[position].isRight == null) {
          isExpandDescription = false;
        } else {
          isExpandDescription = true;
        }

        setState(() {});
      }
    });

    if (widget.testModel.type == ListModel.typeTimeQuick) {
      secondsPassed = widget.testModel.count! * 60;
    }

    timer ??= Timer.periodic(duration, (Timer t) {
      handleTick();
    });
  }

  //单选还是多选
  _initChoices(QuestionModel question) {
    isSingleChoices = !(question.answers!.length > 1);
    if (null == question.userAnswer) {
      question.setUserAnswer = [];
    }

    setState(() {});
  }


  @override
  void initState() {
    _initData();

    super.initState();
  }

  void handleTick() {
    if (isActive) {
      secondsPassed++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            closeButton,
            Expanded(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "${position + 1}/${multiSelectList.length}",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF587183),
                            fontSize: HYSizeFit.setRpx(16)),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        multiSelectList.isEmpty
                            ? widget.testModel.titleName!
                            : multiSelectList[position].topicName ??
                            widget.testModel.titleName!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF587183),
                            fontSize: HYSizeFit.sethRpx(12)),
                      ),
                    )
                  ],
                )),
            _moreButton()
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                controller: _pageController,
                child: Container(
                  padding: EdgeInsets.only(
                      left: HYSizeFit.sethRpx(20), right: HYSizeFit.sethRpx(20)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: HYSizeFit.sethRpx(8),
                      ),
                      RichString(
                        text: multiSelectList.isNotEmpty
                            ? multiSelectList[position].question!
                            : "",
                        style: TextStyle(
                            fontSize: HYSizeFit.sethRpx(18),
                            height: 1.2,
                            fontWeight: FontWeight.w500),
                      ),
                      isExpandDescription
                          ? _showExpandDescription()
                          : SizedBox(
                        height: HYSizeFit.sethRpx(200),
                      ),
                      multiSelectList.isNotEmpty
                          ? QuestionChoiceListScreen(
                        questionModel: multiSelectList[position],
                        choices: multiSelectList[position].choices!,
                        isSingleChoices: isSingleChoices,
                        callback: (int value) {
                          if (value == 0) {
                            setState(() {
                              isExpandDescription = true;
                              answered++;
                            });
                          }
                        },
                      )
                          : Container()
                    ],
                  ),
                ),
              )),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          Container(
            height: HYSizeFit.sethRpx(60),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (multiSelectList[position].state != 2) {
                          setState(() {
                            multiSelectList[position].setState = 2;
                          });
                        } else {
                          setState(() {
                            multiSelectList[position].setState = -1;
                          });
                        }
                      },
                      child: Center(
                        child: Icon(
                          multiSelectList.isNotEmpty &&
                              2 == (multiSelectList[position].state ?? -1)
                              ? Icons.star
                              : Icons.stars_rounded,
                          color: multiSelectList.isNotEmpty &&
                              2 == (multiSelectList[position].state ?? -1)
                              ? Colors.blue
                              : Colors.grey,
                          size: 30,
                        ),
                      ),
                    )),
                Expanded(flex: 4, child: _initQuestionIndicator()),
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(HYSizeFit.sethRpx(12)),
                      child: Material(
                        color: Colors.blue,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(16)),
                        child: InkWell(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(16)),
                          onTap: () {
                            if (position < multiSelectList.length - 1) {
                              setState(() {
                                position++;
                                _initChoices(multiSelectList[position]);
                                isExpandDescription =
                                    multiSelectList[position].isRight != null;
                              });

                              _controller.jumpTo(((HYSizeFit.setRpx(26) +
                                  HYSizeFit.setRpx(18)) *
                                  (position - 2))
                                  .toDouble());
                            } else {
                              if (answered == 0) {
                                return;
                              }
                              timer?.cancel();
                              _saveThisTest();
                            }
                          },
                          child: Center(
                            child: Text(
                              position == multiSelectList.length - 1
                                  ? "Submit"
                                  : "NEXT",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }


  _initQuestionIndicator() {
    return Container(
      margin: EdgeInsets.only(
          top: HYSizeFit.setRpx(3),
          left: HYSizeFit.setRpx(26),
          right: HYSizeFit.setRpx(26)),
      height: HYSizeFit.setRpx(26),
      width: HYSizeFit.setRpx(44),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: multiSelectList.length,
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return QuestionIndicator(
              position: position,
              index: index,
              state: multiSelectList[index].isRight,
              onTap: () {
                position = index;
                _initChoices(multiSelectList[index]);
                if (multiSelectList[position].isRight == null) {
                  isExpandDescription = false;
                } else {
                  isExpandDescription = true;
                }
                _pageController.jumpTo(0);
                setState(() {});
              },
            );
          }),
    );
  }

  _showExpandDescription() {
    return Container(
      margin: EdgeInsets.only(
        top: HYSizeFit.sethRpx(20),
        bottom: HYSizeFit.sethRpx(20),
      ),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Row(
            children: [
              multiSelectList[position].isRight == 0
                  ? Icon(Icons.lightbulb_outline,
                  color: Colors.green, size: HYSizeFit.sethRpx(18))
                  : Icon(Icons.lightbulb_outline,
                  color: Colors.red, size: HYSizeFit.sethRpx(18)),
              SizedBox(
                width: HYSizeFit.sethRpx(8),
              ),
              Text(
                "Explanation",
                style: TextStyle(
                    color: multiSelectList[position].isRight == 0
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: HYSizeFit.sethRpx(16)),
              ),
              const Expanded(child: SizedBox()),
              multiSelectList[position].isRight == 0
                  ? Icon(
                Icons.check_circle,
                color: Colors.green,
                size: HYSizeFit.sethRpx(18),
              )
                  : Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: HYSizeFit.sethRpx(18),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: HYSizeFit.sethRpx(11)),
            child: RichString(
              text: multiSelectList[position].explanation!,
              style: TextStyle(
                height: 1.5,
                color: multiSelectList[position].isRight == 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  _saveThisTest() async {
    ScoreModel score = await DBManager.getInstance()
        .saveScore(widget.testModel.titleName!, multiSelectList, secondsPassed);

    score.setQuestions = multiSelectList;
    score.setMultiSelectListLength = multiSelectList.length;

    Navigator.of(context)
        .pushNamed(scoreScreen, arguments: score)
        .then((value) {
      homeTabGlobalKey.currentState?.setState(() {});
      if (value != null) {
        value as bool;
        if (value) {
          // _clearTest();
        } else {
          Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
        }
      } else {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
      }
    });
  }

  int beginStartClock() {
    secondsPassed =
        (widget.testModel.count == null ? 0 : widget.testModel.count!) * 60;
    return secondsPassed;
  }

  Widget closeButton = Center(
    child: Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(90)),
        onTap: () {
          Navigator.of(navigatorKey.currentState!.context).pop();
        },
        child: Container(
          width: HYSizeFit.setRpx(30),
          height: HYSizeFit.setRpx(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90.0),
            color: const Color(0x10000000),
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 22,
            color: Color(0xFF587183),
          ),
        ),
      ),
    ),
  );

  Widget _moreButton() {
    return Center(
      child: Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(90)),
          onTap: () {
            _showMoreDialog();
          },
          child: const Icon(
            Icons.more_horiz_sharp,
            size: 26,
            color: Color(0xFF587183),
          ),
        ),
      ),
    );
  }

  _showMoreDialog() {
    showDialog(
        context: navigatorKey.currentState!.context,
        barrierDismissible: true,
        builder: (_) => Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: HYSizeFit.sethRpx(12), right: HYSizeFit.sethRpx(12)),
              width: HYSizeFit.sethRpx(240),
              height: HYSizeFit.sethRpx(240),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Container(
                  padding: EdgeInsets.all(HYSizeFit.sethRpx(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.testModel.titleName!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: HYSizeFit.sethRpx(18)),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _dialogButton(
                          Icons.home_outlined, "Main Menu", () {}),
                      _dialogButton(Icons.refresh, "Restart", () {}),
                      _dialogButton(Icons.subdirectory_arrow_right,
                          "Submit Test", () {}),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  _dialogButton(IconData iconData, String text, onTap) {
    return Container(
      height: HYSizeFit.sethRpx(40),
      margin: EdgeInsets.only(bottom: HYSizeFit.sethRpx(8)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(HYSizeFit.sethRpx(8)),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0x09000000)),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: HYSizeFit.sethRpx(16), color: Colors.blueAccent),
                  )),
              const SizedBox(
                width: 8,
              ),
              Icon(
                iconData,
                size: HYSizeFit.sethRpx(24),
                color: Colors.blueAccent,
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    multiSelectList.clear();
    timer?.cancel();
    timer = null;
    super.dispose();
  }
}
