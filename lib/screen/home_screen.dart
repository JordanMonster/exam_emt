import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionhub/commons/db/db_manager.dart';
import 'package:questionhub/commons/model/progress_model.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/screen/home/test_tab_screen.dart';
import 'package:questionhub/screen/home/topic_tab_screen.dart';
import 'package:questionhub/screen/home/user_tab_screen.dart';
import 'package:questionhub/utils/screen_utils.dart';

import '../commons/global.dart';
import '../commons/routes/routes.dart';
import 'home/home_tab_screen.dart';

GlobalKey<_HomeScreenState> homeGlobalKey = GlobalKey();

ProgressModel? homeTabData;
DateTime? examTime;

bool? isDailyComplete = false;

bool? isDailyReminder = false;
bool? isStudyReminder = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CupertinoTabController? _controller;
  final List<StatefulWidget> _pageList = [
    HomeTabScreen(homeTabGlobalKey),
    TestTabScreen(testGlobalKey),
    TopicTabScreen(topicGlobalKey),
    UserTabScreen(userGlobalKey)
  ];
  int currIndex = 0;

  @override
  void initState() {
    super.initState();
    Global.startFirst();
    _initData(currIndex);
    _controller = CupertinoTabController();
    _controller?.addListener(() {
      setState(() {
        currIndex = _controller!.index;
        _initData(currIndex);
      });
    });
  }

  _initData(int index) {
    GlobalKey globalKey = _pageList[index].key as GlobalKey;
    switch (index) {
      case 0:
        _initHomeTabData(globalKey);
        break;
      case 1:
        _initTestTabData(globalKey);
        break;
      case 2:
        _initTopicTabData(globalKey);
        break;
      case 3:
        _initUserTabData(globalKey);
        break;
    }
  }

  _initHomeTabData(GlobalKey? key) {
    DBManager.getInstance().countQuestionProgress().then((value) {
      int time = Global.getExamTime();
      if (time != -1) {
        examTime = DateTime.fromMillisecondsSinceEpoch(time);
      } else {
        examTime = null;
      }

      key?.currentState?.setState(() {
        homeTabData = value;
      });
    });

    var now = DateTime.now();
    var star = DateTime(now.year, now.month, now.day);
    var end = star.add(const Duration(days: 1));
    DBManager.getInstance().countDailyPractice(star, end).then((value) {
      key?.currentState?.setState(() {
        isDailyComplete = (value > 0);
      });
    });
  }

  _initTestTabData(GlobalKey? key) {}

  _initTopicTabData(GlobalKey? key) {}

  _initUserTabData(GlobalKey? key) {
    int time = Global.getExamTime();
    if (time != -1) {
      examTime = DateTime.fromMillisecondsSinceEpoch(time);
    } else {
      examTime = null;
    }

    key?.currentState?.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        resizeToAvoidBottomInset: false,
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: HYSizeFit.sethRpx(26),
              ),
              activeIcon: Icon(Icons.home,
                  size: HYSizeFit.sethRpx(30), color: commonColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_added_outlined,
                size: HYSizeFit.sethRpx(26),
              ),
              activeIcon: Icon(Icons.bookmark_added,
                  size: HYSizeFit.sethRpx(30), color: commonColor),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.note_alt_outlined,
                  size: HYSizeFit.sethRpx(26),
                ),
                activeIcon: Icon(Icons.note_alt_rounded,
                    size: HYSizeFit.sethRpx(30), color: commonColor)),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: HYSizeFit.sethRpx(26),
                ),
                activeIcon: Icon(Icons.account_circle_rounded,
                    size: HYSizeFit.sethRpx(30), color: commonColor)),
          ],
          iconSize: 40,
        ),
        controller: _controller,
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (context) {
              if (index < _pageList.length) {
                return _pageList[index];
              }
              return _pageList[0];
            },
            routes: RouteManager().mapForHome(),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
