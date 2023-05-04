import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/constant_str.dart';
import 'package:questionhub/utils/screen_utils.dart';

import 'guide_select_list_widget.dart';

class GuideLevelWidget extends StatelessWidget {
  final List<Color> colors;
  final String text;
  final String smallText;
  final Color activeColor;
  final List<String> plant;
  final int position;
  int selectIndex = 0;

  GuideLevelWidget(
      {Key? key,
      required this.colors,
      required this.text,
      required this.activeColor,
      required this.smallText,
      required this.position,
      required this.plant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    plant[position].isNotEmpty
        ? selectIndex = int.parse(plant[position])
        : plant.setAll(position, ["$selectIndex"]);
    return Material(
      child: Stack(
        children: [
          Container(
            width: HYSizeFit.screenWidth,
            height: HYSizeFit.sethRpx(400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(55),
                  bottomLeft: Radius.circular(55)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Center(
              child: Column(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: HYSizeFit.sethRpx(26),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: HYSizeFit.sethRpx(16)),
                  Text(
                    smallText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: HYSizeFit.sethRpx(15)),
                  ),
              Expanded(
                child: SingleChildScrollView(
                  child: GuideSelectListWidget(
                    list: levels,
                    activeColor: activeColor,
                    selectIndex: "$selectIndex",
                    selectListIndex: (String value) {
                      selectIndex = int.parse(value);
                      plant.setAll(position, ["$selectIndex"]);
                    },
                  ),
                ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
