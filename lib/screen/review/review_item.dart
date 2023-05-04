import 'package:flutter/material.dart';
import 'package:questionhub/commons/model/choices_model.dart';
import 'package:questionhub/commons/model/question_model.dart';
import 'package:questionhub/utils/screen_utils.dart';

class ReviewItem extends StatelessWidget {
  final QuestionModel questionModel;

  const ReviewItem({Key? key, required this.questionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        child: Container(
          margin: EdgeInsets.all(HYSizeFit.sethRpx(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _initQuestion(),
          ),
        ),
      ),
    );
  }

  List<Widget> _initQuestion() {
    List<Widget> widgets = List.empty(growable: true);

    Widget q = Container(
      margin: EdgeInsets.only(bottom: HYSizeFit.sethRpx(4)),
      child: Text(
        "Q: " + (questionModel.question ?? ""),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    widgets.add(q);

    for (ChoicesModel choice in questionModel.choices!) {
      widgets.add(_setChoice(choice, choice.right == 1 ? true : false,
          questionModel.userAnswer?.contains(choice) ?? false));
    }

    return widgets;
  }

  _setChoice(ChoicesModel choice, bool isAnswer, bool isUserAnswer) {
    Color color = isAnswer
        ? Colors.green
        : isUserAnswer && !isAnswer
            ? Colors.red
            : Colors.black;

    return Container(
      margin: EdgeInsets.all(HYSizeFit.sethRpx(4)),
      child: Row(
        children: [
          isAnswer
              ? Icon(
                  Icons.check,
                  color: Colors.green,
                  size: HYSizeFit.sethRpx(14),
                )
              : isUserAnswer && !isAnswer
                  ? Icon(
                      Icons.close,
                      color: Colors.red,
                      size: HYSizeFit.sethRpx(14),
                    )
                  : const SizedBox(width: 14),
          Expanded(
            child: Text(
              choice.text ?? "",
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
