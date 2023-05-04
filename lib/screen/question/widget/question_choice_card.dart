import 'dart:math';

import 'package:flutter/material.dart';
import 'package:questionhub/commons/model/choices_model.dart';
import 'package:questionhub/commons/model/question_model.dart';
import 'package:questionhub/screen/widget/rich_string.dart';
import 'package:questionhub/utils/screen_utils.dart';

const choiceHeader = ["A.", "B.", "C.", "D.", "E.", "F.", "G."];

typedef Callback = void Function(int value);

class QuestionChoiceListScreen extends StatefulWidget {
  final QuestionModel questionModel;
  final List<ChoicesModel> choices;
  final bool isSingleChoices;
  final Callback? callback;

  const QuestionChoiceListScreen(
      {Key? key,
      required this.questionModel,
      required this.choices,
      required this.isSingleChoices,
      this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuestionChoiceListScreenState();
}

class _QuestionChoiceListScreenState extends State<QuestionChoiceListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.isSingleChoices
            ? widget.choices.length
            : widget.choices.length + 1,
        itemBuilder: (BuildContext context, int index) {
          int cardIndex = index;
          if (!widget.isSingleChoices) {
            if (index == 0) {
              return _isAnswered()
                  ? Container()
                  : InkWell(
                      onTap: () {
                        if (widget.questionModel.userAnswer!.isNotEmpty) {
                          if (widget.questionModel.userAnswer!.length ==
                              widget.questionModel.answers!.length) {
                            int isRight = 0;

                            widget.questionModel.userAnswer?.forEach((element) {
                              if (!widget.questionModel.answers!
                                  .contains(element)) {
                                isRight = -1;
                              }
                            });
                            widget.questionModel.setIsRight = isRight;
                          } else {
                            widget.questionModel.setIsRight = -1;
                          }
                          setState(() {
                            widget.callback?.call(0);
                          });
                        }
                      },
                      child: Container(
                        height: HYSizeFit.sethRpx(45),
                        margin: EdgeInsets.only(bottom: HYSizeFit.sethRpx(20)),
                        padding: EdgeInsets.only(
                            right: HYSizeFit.sethRpx(53),
                            left: HYSizeFit.sethRpx(53),
                            top: HYSizeFit.sethRpx(8),
                            bottom: HYSizeFit.sethRpx(8)),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [Color(0xFF5D78EE), Color(0xFF4D4DDF)],
                            begin: Alignment.topRight,
                            end: Alignment.topLeft,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Check Answer",
                            style: TextStyle(
                              fontSize: HYSizeFit.sethRpx(13),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
            }
            cardIndex = cardIndex - 1;
          }

          return QuestionChoiceCard(
            isSingleChoices: widget.isSingleChoices,
            isAnswered: _isAnswered(),
            isTrueChoice: _isTrueChoice(widget.choices[cardIndex]),
            isUserSelected: _isUserSelected(widget.choices[cardIndex]),
            choiceText: widget.choices[cardIndex].text ?? "",
            index: cardIndex,
            onTap: () {
              if (widget.isSingleChoices) {
                if (widget.questionModel.userAnswer == null) {
                  widget.questionModel.setUserAnswer = [];
                }
                if (!_isAnswered()) {
                  widget.questionModel.userAnswer!
                      .add(widget.choices[cardIndex]);
                  if (_isTrueChoice(widget.choices[cardIndex])) {
                    widget.questionModel.setIsRight = 0;
                  } else {
                    widget.questionModel.setIsRight = -1;
                  }
                  setState(() {
                    widget.callback?.call(0);
                  });
                }
              } else {
                if (widget.questionModel.userAnswer == null) {
                  widget.questionModel.setUserAnswer = [];
                }
                if (!widget.questionModel.userAnswer!
                    .contains(widget.choices[cardIndex])) {
                  widget.questionModel.userAnswer!
                      .add(widget.choices[cardIndex]);
                  setState(() {});
                } else {
                  widget.questionModel.userAnswer!
                      .remove(widget.choices[cardIndex]);
                  setState(() {});
                }
              }
            },
          );
        });
  }

  bool _isAnswered() {
    if (widget.questionModel.userAnswer == null) {
      widget.questionModel.setUserAnswer = [];
    }
    return widget.questionModel.isRight != null;
  }

  _isUserSelected(ChoicesModel choices) {
    bool isUserSelected = false;
    if (widget.questionModel.userAnswer != null) {
      isUserSelected = widget.questionModel.userAnswer!.contains(choices);
    }
    return isUserSelected;
  }

  _isTrueChoice(ChoicesModel choices) {
    return widget.questionModel.answers!.contains(choices);
  }
}

class QuestionChoiceCard extends StatelessWidget {
  final String choiceText;
  final bool isSingleChoices;
  final bool isAnswered;
  final bool isTrueChoice;
  final bool isUserSelected;
  final int index;
  final GestureTapCallback? onTap;

  const QuestionChoiceCard({
    Key? key,
    required this.isSingleChoices,
    required this.isAnswered,
    required this.isTrueChoice,
    required this.isUserSelected,
    required this.choiceText,
    required this.index,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color choiceBgColor = Colors.grey.shade100;
    Color choiceTextColor = Colors.black;
    Color checkBoxColor = Colors.white;
    Color activeCheckBoxColor = const Color(0xFF022241);
    Color checkBoxSideColor = const Color(0xFF022241);
    bool isCheck = false;

    if (isUserSelected && isTrueChoice && isAnswered) {
      //选择正确
      choiceTextColor = Colors.green;
      choiceBgColor =
          isSingleChoices ? Colors.greenAccent.shade100 : Colors.grey.shade100;
      activeCheckBoxColor = Colors.green;
      checkBoxColor = Colors.white;
      checkBoxSideColor = Colors.transparent;
    } else if (isUserSelected && !isTrueChoice && isAnswered) {
      //选择错误
      choiceTextColor = isSingleChoices ? Colors.red : Colors.red;
      choiceBgColor =
          isSingleChoices ? Colors.red.shade100 : Colors.grey.shade100;
      activeCheckBoxColor = Colors.red;
      checkBoxColor = Colors.white;
      checkBoxSideColor = Colors.transparent;
    } else if (!isUserSelected && isTrueChoice && isAnswered) {
      //未选择的正确答案
      choiceTextColor = isSingleChoices ? Colors.green : Colors.red;
      choiceBgColor =
          isSingleChoices ? Colors.greenAccent.shade100 : Colors.grey.shade100;
      checkBoxColor = Colors.green;
      activeCheckBoxColor = Colors.white;
    }

    TextStyle style = TextStyle(
        color: choiceTextColor,
        fontSize: HYSizeFit.sethRpx(16),
        height: 1.2,
        fontWeight: FontWeight.w400);

    if (!isTrueChoice && isAnswered && !isSingleChoices) {
      style = const TextStyle(
          decoration: TextDecoration.lineThrough, color: Colors.grey);
    }

    if (!isSingleChoices) {
      if (isAnswered) {
        isCheck = isUserSelected | isTrueChoice;
      } else {
        isCheck = isUserSelected;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: HYSizeFit.sethRpx(20)),
      child: Material(
        color: choiceBgColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(HYSizeFit.sethRpx(16)),
            child: Row(
              children: [
                isSingleChoices
                    ? Container(
                        child: Text(
                          choiceHeader[index],
                          style: TextStyle(
                              color: choiceTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: HYSizeFit.sethRpx(16)),
                        ),
                      )
                    : Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: checkBoxSideColor, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(1))),
                        child: IgnorePointer(
                          child: Checkbox(
                              checkColor: checkBoxColor,
                              activeColor: activeCheckBoxColor,
                              side: const BorderSide(color: Colors.transparent),
                              value: isCheck,
                              onChanged: (value) {}),
                        ),
                      ),
                Container(
                  width: 1,
                  height: 20,
                  color: choiceTextColor,
                  margin: EdgeInsets.only(
                      left: HYSizeFit.setRpx(12), right: HYSizeFit.setRpx(12)),
                ),
                Expanded(
                    child: RichString(
                  text: choiceText,
                  style: style,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
