import 'package:flutter/material.dart';
import 'package:questionhub/utils/screen_utils.dart';

class SingleSubjectItem extends StatelessWidget {
  final String text;
  final int count;
  final GestureTapCallback? onTap;

  const SingleSubjectItem(
      {Key? key, required this.text, required this.count, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: HYSizeFit.sethRpx(8),
        right: HYSizeFit.sethRpx(8),
        top: HYSizeFit.sethRpx(4),
        bottom: HYSizeFit.sethRpx(4),
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: InkWell(
          borderRadius:
          const BorderRadius.all(Radius.circular(8)),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(HYSizeFit.sethRpx(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: HYSizeFit.sethRpx(16)),
                ),
                SizedBox(
                  height: HYSizeFit.sethRpx(4),
                ),
                Text(
                  "$count Exam Questions",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: HYSizeFit.sethRpx(12),
                      color: Colors.blue),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
