import 'package:flutter/material.dart';
import 'package:questionhub/commons/global.dart';
import 'package:questionhub/screen/subjects/subjects_select_item.dart';

import '../../commons/db/db_manager.dart';
import '../../commons/model/subjects_model.dart';
import '../../commons/routes/route_name.dart';
import '../../utils/screen_utils.dart';

class SubjectsSelectPage extends StatefulWidget {
  final bool isSetting;

  const SubjectsSelectPage({Key? key, required this.isSetting})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubjectsSelectPageState();
}

class _SubjectsSelectPageState extends State<SubjectsSelectPage> {
  List<SubjectsModel>? _list;
  int _selectSubjectsIndex = 0;

  @override
  void initState() {
    super.initState();
    DBManager.getInstance().selectAllSubjects().then((value) {
      if (widget.isSetting && value != null) {
        var index = 0;
        for (var element in value) {
          if (Global.subjectsModel!.subject == element.subject) {
            _selectSubjectsIndex = index;
          }
          index++;
        }
      }

      setState(() {
        _list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    HYSizeFit.initialize(context);
    return Scaffold(
      backgroundColor:
          widget.isSetting ? Colors.grey.shade50 : const Color(0xFF1380F0),
      appBar: widget.isSetting
          ? AppBar(
              title: const Text('Select Exam'),
            )
          : null,
      body: Column(
        children: [
          widget.isSetting
              ? Container(
                  height: HYSizeFit.sethRpx(16),
                )
              : const Expanded(
                  child: SizedBox(),
                  flex: 1,
                ),
          widget.isSetting
              ? Container()
              : Expanded(
                  flex: 1,
                  child: Text(
                    "Select the exam you need \nto take.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: HYSizeFit.setRpx(28)),
                  )),
          Expanded(
            child: ListView.builder(
                itemCount: _list?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return SubjectsSelectListItem(
                    subjectsModel: _list![index],
                    isSelect: index == _selectSubjectsIndex,
                    onTap: () {
                      setState(() {
                        _selectSubjectsIndex = index;
                      });
                    },
                  );
                }),
            flex: 7,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: HYSizeFit.setRpx(20)),
              width: HYSizeFit.setRpx(300),
              child: MaterialButton(
                height: HYSizeFit.setRpx(25),
                color: widget.isSetting ? Colors.blue : Colors.orangeAccent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  Global.selectSubjects(_list![_selectSubjectsIndex].subject!)
                      .then((value) {
                    if (value) {
                      if (widget.isSetting) {
                        Navigator.of(context).pop(true);
                      } else {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(homeScreen, (route) => false);
                      }
                    } else {
                      setState(() {});
                    }
                  });
                },
                child: Text(
                  "Selected",
                  style: TextStyle(
                      color: Colors.white, fontSize: HYSizeFit.setRpx(14)),
                ),
              ),
            ),
            flex: 1,
          ),
          const Expanded(
            child: SizedBox(),
            flex: 1,
          )
        ],
      ),
    );
  }
}
