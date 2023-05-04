import 'package:flutter/material.dart';
import 'package:questionhub/commons/global.dart';
import 'package:questionhub/commons/res/constant_str.dart';
import 'package:questionhub/utils/screen_utils.dart';

import '../../commons/res/res_colors.dart';
import '../../commons/routes/route_name.dart';
import '../../main.dart';
import '../dialog/dialog_manager.dart';
import '../home_screen.dart';
import 'home_tab_screen.dart';

GlobalKey<_UserTabScreen> userGlobalKey = GlobalKey();

class UserTabScreen extends StatefulWidget {
  const UserTabScreen(Key? key) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserTabScreen();
}

class _UserTabScreen extends State<UserTabScreen> {
  final HomeColor resColor = HomeColor();

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
    return Scaffold(
        body: NestedScrollView(
      body: Container(
        color: const Color(0x09000000),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                  bottom: HYSizeFit.sethRpx(8),
                  top: HYSizeFit.sethRpx(26),
                  left: HYSizeFit.sethRpx(10)),
              child: const Text("Exam Settings"),
            ),
            _selectExam(),
            _setExamDate(),
            _resetProgress(),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                  bottom: HYSizeFit.sethRpx(8),
                  top: HYSizeFit.sethRpx(26),
                  left: HYSizeFit.sethRpx(10)),
              child: const Text("Notifications"),
            ),
            _practiceReminder(true),
            _practiceReminder(false)
          ],
        )),
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              centerTitle: false,
              expandedHeight: 200.0,
              floating: true,
              pinned: true,
              backgroundColor: resColor.homeBottomColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Settings",style: TextStyle(color: Colors.white),),
                centerTitle: false,
                background: Row(
                  children: [],
                ),
              )),
        ];
      },
    ));
  }

  Widget _selectExam() {
    return Material(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              Navigator.of(navigatorKey.currentState!.context)
                  .pushNamed(settingSubjectsSelectScreen)
                  .then((value) {
                if (value as bool) {
                  _initData();
                  setState(() {});
                }
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.black26, width: 0.5),
                    bottom: BorderSide(color: Colors.black26, width: 0.5)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                    "Selected Exam",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Text(
                    Global.getSelectSubject(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.black,
                    size: HYSizeFit.sethRpx(26),
                  )
                ],
              ),
            )));
  }

  Widget _setExamDate() {
    return Material(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              showExamDialog(context);
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black26, width: 0.5)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                    "Exam Date",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                  Text(
                    examTime == null
                        ? ""
                        : "${monthsString[examTime!.month]}  ${examTime?.day} , ${examTime?.year}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.black,
                    size: HYSizeFit.sethRpx(26),
                  )
                ],
              ),
            )));
  }

  Widget _resetProgress() {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          print("object");
        },
        child: Container(
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black26, width: 0.5)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: const [
              Expanded(
                  child: Text(
                "Resetting progress",
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.blueAccent),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _practiceReminder(bool isDaily) {
    bool isOpen = false;
    if (isDaily) {
      isOpen = isDailyReminder ?? false;
    } else {
      isOpen = isStudyReminder ?? false;
    }
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if (isDaily) {
            //todo reminder
          } else {}
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: const BorderSide(color: Colors.black26, width: 0.5),
                top: isDaily
                    ? const BorderSide(color: Colors.black26, width: 0.5)
                    : BorderSide.none),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                isDaily ? "Daily Practice Reminder" : "Learning Time Reminder",
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black),
              )),
              Text(
                isOpen ? "On" : "Off",
                style: const TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.arrow_right_outlined,
                color: Colors.black,
                size: HYSizeFit.sethRpx(26),
              )
            ],
          ),
        ),
      ),
    );
  }
}
