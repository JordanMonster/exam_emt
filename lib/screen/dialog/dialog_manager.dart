import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/utils/screen_utils.dart';

import '../../commons/global.dart';
import '../../commons/model/list_model.dart';
import '../../commons/routes/route_name.dart';
import '../../main.dart';
import '../home/home_tab_screen.dart';
import '../home/user_tab_screen.dart';
import '../home_screen.dart';

showExamDialog(BuildContext context) {
  showDatePicker(
          context: context,
          initialDate: examTime != null ? examTime! : DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2080))
      .then((value) {
    if (value != null) {
      examTime = value;
      Global.setExamTime(value).then((value) {
        if (value!) {
          userGlobalKey.currentState?.setState(() {});
          homeTabGlobalKey.currentState?.setState(() {});
        }
      });
    }
  });
}

showSetProgressDialog(BuildContext context, String centerTitle, String title) {
  int hour = 0;
  int minutes = 5;
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    right: HYSizeFit.sethRpx(12), left: HYSizeFit.sethRpx(12)),
                height: HYSizeFit.sethRpx(350),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                    padding: EdgeInsets.all(HYSizeFit.sethRpx(20)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Material(
                              color: Colors.white,
                              child: InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(90)),
                                onTap: () {
                                  Navigator.of(
                                          navigatorKey.currentState!.context)
                                      .pop();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  size: HYSizeFit.sethRpx(22),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Center(
                              child: Text(
                                centerTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                            SizedBox(
                              width: HYSizeFit.sethRpx(22),
                            ),
                          ],
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: HYSizeFit.sethRpx(18)),
                        ),
                        Expanded(
                          child: CupertinoDatePicker(
                            backgroundColor: Colors.white,
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: true,
                            initialDateTime: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                hour,
                                minutes),
                            onDateTimeChanged: (date) {
                              hour = date.hour;
                              minutes = date.minute;
                            },
                          ),
                        ),
                        MaterialButton(
                          minWidth: HYSizeFit.setRpx(300),
                          height: HYSizeFit.setRpx(40),
                          color: commonColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          onPressed: () {
                            Navigator.of(navigatorKey.currentState!.context)
                              ..pop()
                              ..pushNamed(questionScreen,
                                  arguments:
                                      ListModel.getTimeQuiz(hour, minutes));
                          },
                          child: Text(
                            "Start Quiz",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: HYSizeFit.setRpx(14)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ));
}
