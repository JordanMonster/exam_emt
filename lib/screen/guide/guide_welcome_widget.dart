import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/res_string.dart';
import 'package:questionhub/utils/screen_utils.dart';

class GuideWelComeWidget extends StatelessWidget {
  final ImageProvider headerImage;
  final GuideStr resStr;

  const GuideWelComeWidget(
      {Key? key, required this.headerImage, required this.resStr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: HYSizeFit.screenWidth,
          height: HYSizeFit.sethRpx(450),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: headerImage, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: HYSizeFit.screenWidth,
                    height: HYSizeFit.sethRpx(40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(36)),
                    ),
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: HYSizeFit.sethRpx(40)),
          child: Center(
            child: Text(resStr.welComeText,
                style: const TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w900)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: HYSizeFit.sethRpx(16)),
          child: Center(
            child: Text(resStr.welComeSmallText),
          ),
        ),
      ],
    );
  }
}
