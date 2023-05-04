import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/commons/res/res_string.dart';
import 'package:questionhub/utils/screen_utils.dart';

class GuideSetYearsWidget extends StatelessWidget {
  final ImageProvider headerImage;
  final GuideStr resStr;
  final List<String> plant;
  final int position;

  const GuideSetYearsWidget(
      {Key? key,
      required this.headerImage,
      required this.resStr,
      required this.plant, required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (plant[position].isEmpty) {
      var date = DateTime.now();
      plant.setAll(position, ["${date.millisecondsSinceEpoch}"]);
    }
    var selectdDate = DateTime.fromMillisecondsSinceEpoch(int.parse(plant[0]));
    return Column(
      children: [
        SizedBox(
          width: HYSizeFit.screenWidth,
          height: HYSizeFit.sethRpx(450),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: headerImage, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top,),
                      Text(resStr.welComeText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: commonColor,
                              fontSize: HYSizeFit.sethRpx(30),
                              fontWeight: FontWeight.w900)),
                      Text(resStr.welComeSmallText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: commonColor,
                              fontSize: HYSizeFit.sethRpx(14)))
                    ],
                  )),
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
        SizedBox(
          height: HYSizeFit.sethRpx(200),
          child: Center(
            child: CupertinoTheme(
              data:  CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: HYSizeFit.sethRpx(18),
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                backgroundColor: Colors.white,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectdDate,
                minimumDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                onDateTimeChanged: (date) {
                  plant.setAll(position, ["${date.millisecondsSinceEpoch}"]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
