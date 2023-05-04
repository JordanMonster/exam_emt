import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/constant_str.dart';
import 'package:questionhub/screen/guide/plants/guide_select_list_widget.dart';
import 'package:questionhub/utils/screen_utils.dart';

class GuideSetDayWidget extends StatelessWidget {
  final List<Color> colors;
  final String text;
  final Color activeColor;
  final List<String> plant;
  final int position;
  String selectIndex = "0";

  GuideSetDayWidget(
      {Key? key,
      required this.colors,
      required this.text,
      required this.activeColor,
      required this.plant,
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    plant[position].isNotEmpty
        ? selectIndex = plant[position]
        : plant.setAll(position, [selectIndex]);
    return Material(
      child: Stack(
        children: [
          Container(
            width: HYSizeFit.screenWidth,
            height: HYSizeFit.sethRpx(450),
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
                  Expanded(
                      child: SingleChildScrollView(
                    child: GuideSelectListWidget(
                      list: weeks,
                      activeColor: activeColor,
                      selectIndex: selectIndex,
                      isMutil: true,
                      selectListIndex: (String value) {
                        plant.setAll(position, [value]);
                      },
                    ),
                  )),
                  SizedBox(
                    height: HYSizeFit.sethRpx(26),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
