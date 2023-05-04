import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/commons/res/res_string.dart';
import 'package:questionhub/commons/routes/route_name.dart';
import 'package:questionhub/screen/guide/plants/guide_howlong_widget.dart';
import 'package:questionhub/screen/guide/plants/guide_level_widget.dart';
import 'package:questionhub/screen/guide/guide_plan_widget.dart';
import 'package:questionhub/screen/guide/plants/guide_setday_widget.dart';
import 'package:questionhub/screen/guide/plants/guide_settime_widget.dart';
import 'package:questionhub/screen/guide/plants/guide_setyears_widget.dart';
import 'package:questionhub/screen/guide/guide_welcome_widget.dart';
import 'package:questionhub/utils/screen_utils.dart';

import '../../commons/global.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _selectPosition = 0;
  final GuideStr resStr = GuideStr();
  final GuideColor resColor = GuideColor();
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget> guideWidgets = List.empty(growable: true);

  List<String> plants = List.filled(5, "");

  @override
  void initState() {
    super.initState();
    guideWidgets.add(GuideWelComeWidget(
        headerImage: const AssetImage("assets/images/guide_welcome.png"),
        resStr: resStr));
    guideWidgets.add(GuideSetYearsWidget(
        headerImage: const AssetImage("assets/images/guide_exam_time.png"),
        resStr: resStr,
        position: 0,
        plant: plants));
    guideWidgets.add(GuideSetTimesWidget(
        headerImage: const AssetImage("assets/images/guide_time.png"),
        resStr: resStr,
        position: 1,
        plant: plants));
    guideWidgets.add(GuideSetDayWidget(
        colors: [resColor.backgroundTopColor, resColor.backgroundBottomColor],
        text: resStr.setDayText,
        activeColor: resColor.checkActiveColor,
        position: 2,
        plant: plants));
    guideWidgets.add(GuideLevelWidget(
        colors: [resColor.backgroundTopColor, resColor.backgroundBottomColor],
        text: resStr.setLevelText,
        smallText: resStr.setLevelSmallText,
        position: 3,
        activeColor: resColor.checkActiveColor,
        plant: plants));
    guideWidgets.add(GuideHowLongWidget(
        colors: [resColor.backgroundTopColor, resColor.backgroundBottomColor],
        text: resStr.setHowLongText,
        smallText: resStr.setHowLongSmallText,
        position: 4,
        activeColor: resColor.checkActiveColor,
        plant: plants));
    guideWidgets.add(GuidePlanWidget(
        colors: [resColor.backgroundTopColor, resColor.backgroundBottomColor],
        text: resStr.plantText,
        plants: plants));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: guideWidgets.length,
                onPageChanged: (index) {
                  setState(() {
                    _selectPosition = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return guideWidgets[index];
                },
              ),
            ),
            SizedBox(height: HYSizeFit.sethRpx(120), child: _nextScreen()),
            SizedBox(height: HYSizeFit.sethRpx(16))
          ],
        ),
      ),
    );
  }

  _nextScreen() {
    return Column(
      children: [
        MaterialButton(
          minWidth: HYSizeFit.sethRpx(301),
          height: HYSizeFit.sethRpx(54),
          color: commonColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: () {
            if (_selectPosition == guideWidgets.length - 1) {
              // Navigator.of(context)
              //     .pushNamedAndRemoveUntil(subscribeScreen, (route) => false);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homeScreen, (route) => false);
            } else {
              _selectPosition++;
              _pageController.jumpToPage(_selectPosition);
            }
          },
          child: Text(
            resStr.startButtonText,
            style:
                TextStyle(color: Colors.white, fontSize: HYSizeFit.setRpx(18)),
          ),
        ),
        _selectPosition == guideWidgets.length - 1
            ? Container(
                margin: EdgeInsets.only(top: HYSizeFit.sethRpx(6)),
                child: Column(
                  children: [
                    SizedBox(
                      width: HYSizeFit.screenWidth! - 48,
                      child: Center(
                        child: Text(
                          resStr.privacyPolicyText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: HYSizeFit.sethRpx(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: HYSizeFit.screenWidth! - 48,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Text(resStr.restoreText,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: HYSizeFit.sethRpx(10)),
                                  textAlign: TextAlign.left),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                resStr.privacyText,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: HYSizeFit.sethRpx(10)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     subscribeScreen, (route) => false);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeScreen, (route) => false);
                },
                child: Container(
                  margin: EdgeInsets.only(top: HYSizeFit.setRpx(25)),
                  width: HYSizeFit.sethRpx(301),
                  child: Center(
                    child: Text(
                      resStr.skipButtonText,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: HYSizeFit.setRpx(18),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
