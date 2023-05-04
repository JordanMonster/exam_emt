import 'package:flutter/material.dart';
import 'package:questionhub/commons/global.dart';
import 'package:questionhub/commons/res/constant_str.dart';
import 'package:questionhub/utils/screen_utils.dart';

class GuidePlanWidget extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final List<String> plants;

  const GuidePlanWidget(
      {Key? key,
      required this.text,
      required this.colors,
      required this.plants})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: plants.length,
                        itemBuilder: (BuildContext context, int index) {
                          String imageAssets = "assets/images/icon_years.png";
                          String title = plantTitles[index];
                          String text = "";

                          switch (index) {
                            case 0:
                              imageAssets = "assets/images/icon_years.png";
                              var date = DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(plants[index]));
                              text = "${date.day} ${monthStr[date.month]} ${date.year}";
                              break;
                            case 1:
                              imageAssets = "assets/images/icon_days.png";
                              List<String> list = plants[2].split(":");
                              list.sort((a, b) => (a).compareTo(b));
                              for (var element in list) {
                                text += "${weeks[int.parse(element)]},";
                              }
                              break;
                            case 2:
                              imageAssets = "assets/images/icon_time.png";
                              text = howLong[int.parse(plants[4])];
                              break;
                            case 3:
                              imageAssets = "assets/images/icon_point.png";
                              text = "${Global.questionCount}";
                              break;
                            case 4:
                              imageAssets = "assets/images/icon_sub.png";
                              text = subscribeNow;
                              break;
                          }
                          return Container(
                              height: HYSizeFit.sethRpx(68),
                              margin: EdgeInsets.only(
                                  bottom: HYSizeFit.sethRpx(16),
                                  left: HYSizeFit.sethRpx(16),
                                  right: HYSizeFit.sethRpx(16)),
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: HYSizeFit.sethRpx(16)),
                                      child: Image(
                                          image: AssetImage(imageAssets))),
                                  SizedBox(width: HYSizeFit.sethRpx(16)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                              color: Colors.grey)),
                                      Container(
                                        width:HYSizeFit.sethRpx(260),
                                        margin: EdgeInsets.only(
                                            right: HYSizeFit.sethRpx(16)),
                                        child: Text(text,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 9,
                                    offset: const Offset(-0.2, 1),
                                  ),
                                ],
                              ));
                        }),
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
