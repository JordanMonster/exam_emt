import 'package:flutter/material.dart';

import '../../data/data_manager.dart';
import '../../main.dart';
import '../../utils/screen_utils.dart';
import 'package:provider/provider.dart';

class QuestionToolBar extends StatefulWidget {
  final String title;
  final GestureTapCallback? onRestart;
  final GestureTapCallback? onSubmit;

  const QuestionToolBar(
      {Key? key, required this.title, this.onRestart, this.onSubmit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuestionToolBarState();
}

class _QuestionToolBarState extends State<QuestionToolBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        closeButton,
        Expanded(
            child: Column(
          children: [
            Center(
              child: Consumer<QuestionDetailModule>(
                builder: (context, module, child) => Text(
                  "${module.position + 1}/${module.questionTotal}",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF587183),
                      fontSize: HYSizeFit.setRpx(16)),
                ),
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Text(
                widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF587183),
                    fontSize: HYSizeFit.sethRpx(12)),
              ),
            )
          ],
        )),
        Consumer<QuestionDetailModule>(
            builder: (context, module, child) => _moreButton(module))
      ],
    );
  }

  Widget _moreButton(QuestionDetailModule module) {
    return Center(
      child: Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(90)),
          onTap: () {
            _showMoreDialog(module);
          },
          child: const Icon(
            Icons.more_horiz_sharp,
            size: 28,
            color: Color(0xFF587183),
          ),
        ),
      ),
    );
  }

  _showMoreDialog(QuestionDetailModule module) {
    module.isActive = false;

    var hours = module.secondsPassed ~/ (60 * 60);
    var minutes = module.secondsPassed ~/ 60 - hours * 60;
    var seconds = module.secondsPassed % 60;

    var time =
        "${hours != 0 ? "$hours H" : ""} ${minutes != 0 ? "$minutes m" : ""} ${hours != 0 ? "" : "$seconds s"} ";

    showDialog(
        context: navigatorKey.currentState!.context,
        barrierDismissible: true,
        builder: (_) => Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: HYSizeFit.sethRpx(12), right: HYSizeFit.sethRpx(12)),
                  width: HYSizeFit.sethRpx(240),
                  height: HYSizeFit.sethRpx(280),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Container(
                      padding: EdgeInsets.all(HYSizeFit.sethRpx(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: HYSizeFit.sethRpx(18)),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.blue,
                                size: 26,
                              ),
                              Text(time)
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          _dialogButton(Icons.home_outlined, "Main Menu", () {
                            Navigator.of(navigatorKey.currentState!.context)
                              ..pop()
                              ..pop();
                          }),
                          _dialogButton(Icons.refresh, "Restart", () {
                            module.clear();
                            Navigator.of(navigatorKey.currentState!.context)
                                .pop();
                            widget.onRestart?.call();
                          }),
                          _dialogButton(
                              Icons.subdirectory_arrow_right, "Submit Test",
                              () {
                            Navigator.of(navigatorKey.currentState!.context)
                                .pop();
                            widget.onSubmit?.call();
                          }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )).then((value) => module.isActive = true);
  }

  _dialogButton(IconData iconData, String text, onTap) {
    return Container(
      height: HYSizeFit.sethRpx(40),
      margin: EdgeInsets.only(bottom: HYSizeFit.sethRpx(8)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(HYSizeFit.sethRpx(8)),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0x09000000)),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                text,
                style: TextStyle(
                    fontSize: HYSizeFit.sethRpx(16), color: Colors.blueAccent),
              )),
              const SizedBox(
                width: 8,
              ),
              Icon(
                iconData,
                size: HYSizeFit.sethRpx(24),
                color: Colors.blueAccent,
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget closeButton = Center(
    child: Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(90)),
        onTap: () {
          Navigator.of(navigatorKey.currentState!.context).pop();
        },
        child: Container(
          width: HYSizeFit.setRpx(30),
          height: HYSizeFit.setRpx(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90.0),
            color: const Color(0x10000000),
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 22,
            color: Color(0xFF587183),
          ),
        ),
      ),
    ),
  );
}
