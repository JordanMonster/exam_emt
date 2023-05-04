import 'package:flutter/material.dart';
import 'package:questionhub/commons/db/db_manager.dart';
import 'package:questionhub/commons/model/list_model.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/commons/routes/route_name.dart';
import 'package:questionhub/screen/single/single_subject_item.dart';

class SingleSubjectScreen extends StatefulWidget {
  final List<ListModel> list;

  const SingleSubjectScreen({Key? key, required this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingleSubjectScreenState();
}

class _SingleSubjectScreenState extends State<SingleSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: commonColor,
          title: const Text('Single-Subject Quiz'),
        ),
        body: ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleSubjectItem(
                onTap: () {
                  if (widget.list[index].type == ListModel.typeMenu) {
                    _pushChlidItem(index);
                  } else {
                    _pushStudySubjectsTest(index);
                  }
                },
                text: widget.list[index].titleName ?? "",
                count: widget.list[index].count ?? 0,
              );
            }));
  }

  _pushChlidItem(int index) {
    var i = (widget.list[index].count!) % 20;
    var n = widget.list[index].count! ~/ 20 + (i == 0 ? 0 : 1);
    var p = 0;
    List<ListModel> list = List.empty(growable: true);
    while (p < n) {
      list.add(ListModel(
          topicName: widget.list[index].topicName,
          titleName: "${widget.list[index].titleName} ${p + 1}",
          type: ListModel.typeStudySubjects,
          index: p,
          count: p == n - 1 ? i : 20));
      p++;
    }

    Navigator.of(context).pushNamed(singleSubjectScreen, arguments: list);
  }

  _pushStudySubjectsTest(int index) {
    Navigator.of(context)
        .pushNamed(questionScreen, arguments: widget.list[index]);
  }
}
