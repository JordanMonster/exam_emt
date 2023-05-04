import 'package:flutter/material.dart';
import 'package:questionhub/utils/screen_utils.dart';

class QuestionIndicator extends StatelessWidget {
  final int position;
  final int index;
  final int? state;
  final GestureTapCallback? onTap;

  const QuestionIndicator(
      {Key? key,
      required this.position,
      required this.index,
      this.state,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color textColor = Colors.black;
    Border? side;

    if (position == index) {
      side = Border.all(color: Colors.blueAccent, width: 2);
      textColor = Colors.black;
    }
    if (state == -2 && position != index) {
      bgColor = Colors.white;
      textColor = Colors.black;
    }
    if (state == 0 && position != index) {
      bgColor = Colors.green;
      textColor = Colors.white;
    }
    if (state == -1 && position != index) {
      bgColor = Colors.red;
      textColor = Colors.white;
    }

    return Container(
      height: HYSizeFit.setRpx(26),
      width: HYSizeFit.setRpx(26),
      margin: EdgeInsets.only(right: HYSizeFit.setRpx(18)),
      decoration: BoxDecoration(
          border: side,
          borderRadius: const BorderRadius.all(Radius.circular(90)),
          color: bgColor),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            (index + 1).toString(),
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
