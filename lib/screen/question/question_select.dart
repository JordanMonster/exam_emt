
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:questionhub/screen/question/widget/question_choice_card.dart';
import '../../data/data_manager.dart';
import '../../utils/screen_utils.dart';
import '../widget/rich_string.dart';

class QuestionSelect extends StatefulWidget{
  final ScrollController controller;
  
  const QuestionSelect({Key? key, required this.controller}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _QuestionSelectState();
  
}

class _QuestionSelectState extends State<QuestionSelect>{
  
  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionDetailModule>(
        builder: (context, module, child) => SingleChildScrollView(
      controller: widget.controller,
      child: Container(
        padding: EdgeInsets.only(
            left: HYSizeFit.sethRpx(20),
            right: HYSizeFit.sethRpx(20)),
        child: Column(
          children: [
            SizedBox(
              height: HYSizeFit.sethRpx(8),
            ),
            RichString(
              text: module.multiSelectList.isNotEmpty
                  ? module
                  .multiSelectList[module.position].question!
                  : "",
              style: TextStyle(
                  fontSize: HYSizeFit.sethRpx(18),
                  height: 1.2,
                  fontWeight: FontWeight.w500),
            ),
            module.isExpandDescription
                ? _showExpandDescription(module)
                : SizedBox(
              height: HYSizeFit.sethRpx(200),
            ),
            module.multiSelectList.isNotEmpty
                ? QuestionChoiceListScreen(
              questionModel: module.question,
              choices: module.question.choices!,
              isSingleChoices: module.isSingleChoices,
              callback: (int value) {
                if (value == 0) {
                  module.setIsExpand(true);
                  module.setAnswered(module.answered + 1);
                }
              },
            )
                : Container()
          ],
        ),
      ),
    ));
  }


  _showExpandDescription(QuestionDetailModule module) {
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
              module.question.isRight == 0
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
                    color: module.question.isRight == 0
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: HYSizeFit.sethRpx(16)),
              ),
              const Expanded(child: SizedBox()),
              module.question.isRight == 0
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
              text: module.question.explanation!,
              style: TextStyle(
                height: 1.5,
                color:
                module.question.isRight == 0 ? Colors.green : Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}