import 'package:flutter/material.dart';

import '../../commons/global.dart';
import '../../utils/screen_utils.dart';
import 'package:octo_image/octo_image.dart';

class RichString extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const RichString({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HYSizeFit.initialize(context);
    List<String> strs = text.split(".png\$");

    if (strs.length > 1) {
      var index = 0;

      var content = TextSpan(style: style, children: []);

      while (index < strs.length - 1) {
        List questions = strs[index].split("\$");
        String png = "${questions.last}.png";

        content.children!.add(TextSpan(text: questions[0]));

        content.children!.add(WidgetSpan(
          child: OctoImage(
            image: NetworkImage("$imageUrl$png"),
            progressIndicatorBuilder: (context, progress) {
          double value = 0;
          if (progress != null && progress.expectedTotalBytes != null) {
            value = progress.cumulativeBytesLoaded /
            progress.expectedTotalBytes!;
          }
          return Container(
            height: HYSizeFit.setRpx(30),
            width: HYSizeFit.setRpx(30),
            child: Center(child: CircularProgressIndicator(value: value)),
          );
            },
            errorBuilder: OctoError.icon(color: Colors.grey),
            fit: BoxFit.cover,
          ),
        ));
        if (index == strs.length - 2) {
          content.children!.add(TextSpan(text: strs[index + 1]));
        }
        index++;
      }

      return Column(
        children: [
          RichText(text: content),
        ],
      );
    }

    return Text(text, style: style);
  }
}
