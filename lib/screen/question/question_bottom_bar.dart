import 'package:flutter/material.dart';
import 'package:questionhub/screen/question/widget/question_indicator.dart';

import '../../data/data_manager.dart';
import '../../utils/screen_utils.dart';

import 'package:provider/provider.dart';

class QuestionBottomBar extends StatefulWidget {
  final GestureTapCallback? onTap;
  final GestureTapCallback? onNext;
  final GestureTapCallback? onSubmit;

  const QuestionBottomBar({Key? key, this.onTap, this.onNext, this.onSubmit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuestionBottomBarState();
}

class _QuestionBottomBarState extends State<QuestionBottomBar> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionDetailModule>(
        builder: (context, module, child) => SizedBox(
              height: HYSizeFit.sethRpx(60),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          if (module.question.state != 2) {
                            module.question.setState = 2;
                          } else {
                            module.question.setState = -1;
                          }
                        },
                        child: Center(
                          child: Icon(
                            module.multiSelectList.isNotEmpty &&
                                    2 == (module.question.state ?? -1)
                                ? Icons.star
                                : Icons.stars_rounded,
                            color: module.multiSelectList.isNotEmpty &&
                                    2 == (module.question.state ?? -1)
                                ? Colors.blue
                                : Colors.grey,
                            size: 30,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: HYSizeFit.setRpx(3),
                            left: HYSizeFit.setRpx(26),
                            right: HYSizeFit.setRpx(26)),
                        height: HYSizeFit.setRpx(26),
                        width: HYSizeFit.setRpx(44),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: module.questionTotal,
                            controller: _controller,
                            itemBuilder: (BuildContext context, int index) {
                              return QuestionIndicator(
                                position: module.position,
                                index: index,
                                state: module.multiSelectList[index].isRight,
                                onTap: () {
                                  module.position = index;

                                  widget.onTap?.call();

                                  if (module.question.isRight == null) {
                                    module.isExpandDescription = false;
                                  } else {
                                    module.isExpandDescription = true;
                                  }
                                },
                              );
                            }),
                      )),
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
                              if (module.position < module.questionTotal - 1) {
                                module.position = (module.position + 1);

                                widget.onNext?.call();

                                module.isExpandDescription = (
                                    module.question.isRight != null);

                                _controller.jumpTo(((HYSizeFit.setRpx(26) +
                                            HYSizeFit.setRpx(18)) *
                                        (module.position - 2))
                                    .toDouble());
                              } else {
                                if (module.answered == 0) {
                                  return;
                                }
                                module.timer?.cancel();
                                widget.onSubmit?.call();
                              }
                            },
                            child: Center(
                              child: Text(
                                module.position == module.questionTotal - 1
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
            ));
  }

  _initQuestionIndicator() {
    return;
  }
}
