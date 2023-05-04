import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionhub/utils/screen_utils.dart';

class HomeItemWidget extends StatelessWidget {
  final IconData? icon;
  final double? size;
  final Color? color;
  final String text;
  final TextStyle? style;
  final GestureTapCallback? onTap;

  const HomeItemWidget(
      {Key? key,
      this.icon,
      this.size,
      this.color,
      required this.text,
      this.style,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(HYSizeFit.sethRpx(12)),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: size,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                text,
                style: style,
              )
            ],
          ),
        ),
      ),
    );
  }
}
