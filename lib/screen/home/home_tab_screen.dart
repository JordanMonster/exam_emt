import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:questionhub/commons/db/db_manager.dart';
import 'package:questionhub/commons/global.dart';
import 'package:questionhub/commons/model/calender_events.dart';
import 'package:questionhub/commons/model/list_model.dart';
import 'package:questionhub/commons/model/progress_model.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/screen/home_screen.dart';
import 'package:questionhub/screen/widget/home_item_widget.dart';
import 'package:questionhub/utils/screen_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../commons/res/res_string.dart';
import '../../commons/routes/route_name.dart';
import '../../main.dart';
import '../dialog/dialog_manager.dart';

GlobalKey<_HomeTabScreenState> homeTabGlobalKey = GlobalKey();

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen(Key? key) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final HomeColor resColor = HomeColor();
  final HomeStr resStr = HomeStr();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    int time = Global.getExamTime();
    if (time != -1) {
      examTime = DateTime.fromMillisecondsSinceEpoch(time);
    } else {
      examTime = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: resColor.backGroundColor,
      child: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            height: HYSizeFit.sethRpx(300) + MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [resColor.homeTopColor, resColor.homeBottomColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          Container(
            padding: EdgeInsets.all(HYSizeFit.sethRpx(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Text(
                  Global.subjectsModel!.textSubject!,
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                _topProgressCard(),
                _topExamTimeCard(),
                _bottomCard(),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _topProgressCard() {
    var data = homeTabData ?? ProgressModel();
    double percent = data.progress == 0 ? 0 : (data.progress! / data.count!);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(HYSizeFit.sethRpx(8)),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: resStr.headerProgressText,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: HYSizeFit.sethRpx(20),
                  ),
                ),
                TextSpan(
                  text: "${data.progress} of ${data.count} Test Completed",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade100,
                    fontSize: 12,
                  ),
                )
              ], style: const TextStyle(height: 1.5))),
            ),
            const Expanded(child: SizedBox()),
            Container(
              margin: EdgeInsets.all(HYSizeFit.sethRpx(8)),
              child: CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 5.0,
                animation: true,
                percent: percent,
                center: Text(
                  "${(percent * 100).round()}%",
                  style: TextStyle(
                      color: Colors.grey.shade100,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: commonColor,
                backgroundColor: Colors.grey.shade100,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _topExamTimeCard() {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          _setExamButton(),
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2080, 12, 31),
            focusedDay: _selectDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (CalendarFormat format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarBuilders: CalendarBuilders(markerBuilder:
                (BuildContext context, DateTime day,
                    List<CalenderEvents> events) {
              if (day.day == examTime?.day &&
                  day.month == examTime?.month &&
                  day.year == examTime?.year) {
                return Center(
                  child: Container(
                    height: HYSizeFit.sethRpx(30),
                    width: HYSizeFit.sethRpx(30),
                    decoration: BoxDecoration(
                        color: commonColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(90))),
                    child: Center(
                      child: Text(
                        "${day.day}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
              if (day.isAfter(DateTime.now())) {
                return Center(
                  child: Text(
                    "${day.day}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              }
              if (!day.isAfter(DateTime.now())) {}
            }),
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: commonColor,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectDay, day);
            },
            onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
              setState(() {
                _selectDay = selectedDay;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: HYSizeFit.setRpx(12)),
            width: HYSizeFit.setRpx(300),
            height: HYSizeFit.setRpx(40),
            child: MaterialButton(
              height: HYSizeFit.setRpx(25),
              color: commonColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () {
                Navigator.of(navigatorKey.currentState!.context).pushNamed(
                    questionScreen,
                    arguments: ListModel.getDailyPractice());
              },
              child: isDailyComplete!
                  ? Text(resStr.toDayText,
                      style: TextStyle(
                          color: Colors.black, fontSize: HYSizeFit.setRpx(14)))
                  : Text(
                      resStr.goToDailyText,
                      style: TextStyle(
                          color: Colors.white, fontSize: HYSizeFit.setRpx(14)),
                    ),
            ),
          ),
          SizedBox(
            height: HYSizeFit.sethRpx(12),
          )
        ],
      ),
    );
  }

  Widget _bottomCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(HYSizeFit.sethRpx(8)),
          child: Text(
            resStr.quizModeText,
            style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.black,
                fontSize: HYSizeFit.sethRpx(12)),
          ),
        ),
        HomeItemWidget(
          text: "Quick 10 Quiz",
          icon: Icons.quiz,
          size: HYSizeFit.sethRpx(26),
          color: Colors.purple,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: HYSizeFit.sethRpx(16)),
          onTap: () {
            Navigator.of(navigatorKey.currentState!.context).pushNamed(
                questionScreen,
                arguments: ListModel.getQuickForStudy());
          },
        ),
        HomeItemWidget(
            text: "Time Quiz",
            icon: Icons.timer_sharp,
            size: HYSizeFit.sethRpx(26),
            color: Colors.blueAccent,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: HYSizeFit.sethRpx(16)),
            onTap: () {
              showSetProgressDialog(context, "Time Quiz", "How many minutes?");
            }),
        HomeItemWidget(
            text: "Single-Subject Quiz",
            icon: Icons.subject,
            size: HYSizeFit.sethRpx(26),
            color: Colors.green,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: HYSizeFit.sethRpx(16)),
            onTap: () {
              _goToSingleSubjectScreen();
            }),
        HomeItemWidget(
            text: "Wrong Question Quiz",
            icon: Icons.restore_page,
            size: HYSizeFit.sethRpx(26),
            color: Colors.red,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: HYSizeFit.sethRpx(16)),
            onTap: () {}),
        HomeItemWidget(
            text: "Simulation Quiz",
            icon: Icons.question_answer,
            size: HYSizeFit.sethRpx(26),
            color: Colors.black,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: HYSizeFit.sethRpx(16)),
            onTap: () {}),
        HomeItemWidget(
            text: "Customized Quiz",
            icon: Icons.widgets,
            size: HYSizeFit.sethRpx(26),
            color: Colors.brown,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: HYSizeFit.sethRpx(16)),
            onTap: () {}),
      ],
    );
  }

  _goToSingleSubjectScreen() async {
    DBManager.getInstance().selectAllTopicListModel().then((value) {
      Navigator.of(navigatorKey.currentState!.context)
          .pushNamed(singleSubjectScreen, arguments: value);
    });
  }

  Widget _setExamButton() {
    if (examTime == null) {
      return Container(
        margin: EdgeInsets.only(
            top: HYSizeFit.sethRpx(12),
            left: HYSizeFit.sethRpx(12),
            right: HYSizeFit.sethRpx(12)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () async {
            showExamDialog(context);
          },
          child: Container(
            padding: EdgeInsets.all(HYSizeFit.sethRpx(12)),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Color(0x10000000)),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: HYSizeFit.sethRpx(20),
                  color: commonColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Text(
                  "Reminder of your exam time ",
                  style: TextStyle(
                    fontSize: HYSizeFit.sethRpx(16),
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.create_outlined,
                  size: HYSizeFit.sethRpx(20),
                  color: commonColor,
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
