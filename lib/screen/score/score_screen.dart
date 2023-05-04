import 'package:flutter/material.dart';
import 'package:questionhub/commons/model/question_model.dart';
import 'package:questionhub/commons/model/score_model.dart';
import 'package:questionhub/commons/res/constant_str.dart';
import 'package:questionhub/screen/home/home_tab_screen.dart';
import 'package:questionhub/screen/review/review_item.dart';
import 'package:questionhub/utils/screen_utils.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ScorePage extends StatefulWidget {
  final ScoreModel score;

  const ScorePage({Key? key, required this.score}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> with SingleTickerProviderStateMixin {
  final List<Tab> tabs = [
    const Tab(
      text: "All",
    ),
    const Tab(
      text: "Correct",
    ),
    const Tab(
      text: "Incorrect",
    ),
    const Tab(
      text: "Flagged",
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  int score = 0;
  String time = "0 H 0 s";

  List<QuestionModel> questions = List.empty(growable: true);

  Color _centerTitleColor = Colors.transparent;

  String _titleText = "";
  String _testTime = "";

  Color progressColor = Colors.green;
  Color bgColor = Colors.green.shade100;

  _loadScoreData() async {
    score = (100 * (widget.score.progress ?? 0)).round();

    if (score > 75) {
      progressColor = Colors.green;
      bgColor = Colors.green.shade100;
    } else if (score <= 75 && score > 50) {
      progressColor = const Color(0xFFFFBA37);
      bgColor = const Color(0xFFFFBA37).withOpacity(0.2);
    } else {
      progressColor = Colors.red;
      bgColor = Colors.red.shade100;
    }

    var seconds = widget.score.time! % 60;
    var hours = widget.score.time! ~/ (60 * 60);
    var minutes = widget.score.time! ~/ 60 - hours * 60;
    time =
        "${hours != 0 ? "$hours H" : ""} ${minutes != 0 ? "$minutes m" : ""} ${hours != 0 ? "" : "$seconds s"} ";
    _titleText = "${widget.score.typeName} - $score%";

    _scrollController.addListener(() {
      var s = (170 / 300 * _scrollController.offset).round();
      if (s > 170) {
        s = 170;
        _centerTitleColor = Colors.black;
      } else {
        _centerTitleColor = Colors.transparent;
      }

      setState(() {});
    });

    var testDate = DateTime.fromMicrosecondsSinceEpoch(widget.score.created!);
    _testTime =
        "${monthStr[testDate.month]} - ${testDate.day} at ${testDate.hour}:${testDate.minute.toString().padLeft(2, '0')} ${testDate.hour < 12 ? "AM" : "PM"}";

    setState(() {
      for (QuestionModel q in widget.score.questionList!) {
        if (q.isRight != null) {
          questions.add(q);
        }
      }
    });
  }

  @override
  void initState() {
    _loadScoreData();

    if (mounted){
      _tabController =
          TabController(length: tabs.length, initialIndex: 0, vsync: this);
    }

    _tabController.addListener(() {
      if (_tabController.index == _tabController.animation?.value) {
        questions.clear();

        if (_tabController.index == 0) {
          for (QuestionModel q in widget.score.questionList!) {
            if (q.isRight != null) {
              questions.add(q);
            }
          }
        }
        if (_tabController.index == 1) {
          for (QuestionModel q in widget.score.questionList!) {
            if (q.isRight == 0) {
              questions.add(q);
            }
          }
        }
        if (_tabController.index == 2) {
          for (QuestionModel q in widget.score.questionList!) {
            if (q.isRight != 0 && q.isRight != null) {
              questions.add(q);
            }
          }
        }
        if (_tabController.index == 3) {
          for (QuestionModel q in widget.score.questionList!) {
            if (q.state == 2) {
              questions.add(q);
            }
          }
        }
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool b) {
          return [
            SliverAppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: 24,
                  color: Colors.blue,
                ),
              ),
              backgroundColor: Colors.white,
              pinned: true,
              floating: true,
              collapsedHeight: HYSizeFit.sethRpx(70),
              expandedHeight: HYSizeFit.sethRpx(430),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: HYSizeFit.sethRpx(70),
                      ),
                      Text(
                        widget.score.typeName ?? "",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: HYSizeFit.sethRpx(18)),
                      ),
                      Text(
                        _testTime,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: HYSizeFit.sethRpx(18)),
                      ),
                      SizedBox(
                        height: HYSizeFit.sethRpx(20),
                      ),
                      _progressHeader(),
                      SizedBox(
                        height: HYSizeFit.sethRpx(20),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: HYSizeFit.setRpx(10)),
                        width: HYSizeFit.setRpx(240),
                        height: HYSizeFit.setRpx(40),
                        child: MaterialButton(
                          height: HYSizeFit.setRpx(25),
                          color: Colors.blue,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          onPressed: () {
                            //todo try again
                          },
                          child: Text(
                            "Try Again",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: HYSizeFit.setRpx(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(bottom: HYSizeFit.sethRpx(60)),
                  child: Text(
                    _titleText,
                    style: TextStyle(
                        color: _centerTitleColor,
                        fontSize: HYSizeFit.sethRpx(16)),
                  ),
                ),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.blue,
                  labelColor: Colors.black,
                  tabs: tabs),
            ),
          ];
        },
        body: Container(
          color: const Color(0x09000000),
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(HYSizeFit.sethRpx(4)),
                    child: ReviewItem(
                      questionModel: questions[index],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  _progressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SleekCircularSlider(
          min: 0,
          max: 100,
          initialValue: score.toDouble(),
          innerWidget: (percentage) {
            return Center(
              child: Container(
                child: Text(
                  "$score%",
                  style: TextStyle(
                      fontSize: HYSizeFit.sethRpx(70),
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          appearance: CircularSliderAppearance(
            size: 200,
            startAngle: 180,
            angleRange: 360,
            spinnerMode: false,
            counterClockwise: false,
            customColors: CustomSliderColors(
                dotColor: Colors.white,
                progressBarColor: progressColor,
                trackColor: Colors.grey.shade300),
            customWidths: CustomSliderWidths(
                trackWidth: HYSizeFit.setRpx(16),
                shadowWidth: 1,
                progressBarWidth: HYSizeFit.setRpx(16)),
          ),
        ),
        SizedBox(
          width: HYSizeFit.sethRpx(20),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: HYSizeFit.sethRpx(156),
              padding: EdgeInsets.all(HYSizeFit.sethRpx(12)),
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: [
                  Text(
                    "${(widget.score.scoreValue)!.round()} / ${widget.score.answered}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "Answered",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: HYSizeFit.sethRpx(156),
              padding: EdgeInsets.all(HYSizeFit.sethRpx(12)),
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "Quiz Time",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
