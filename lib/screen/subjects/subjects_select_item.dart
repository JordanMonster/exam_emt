import 'package:flutter/material.dart';
import 'package:questionhub/commons/model/subjects_model.dart';
import 'package:questionhub/utils/screen_utils.dart';

class SubjectsSelectListItem extends StatelessWidget {
  final SubjectsModel subjectsModel;
  final GestureTapCallback? onTap;
  final bool isSelect;

  const SubjectsSelectListItem(
      {Key? key,
      required this.subjectsModel,
      required this.isSelect,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          top: isSelect ? HYSizeFit.setRpx(4) : HYSizeFit.setRpx(8),
          bottom: isSelect ? HYSizeFit.setRpx(4) : HYSizeFit.setRpx(8),
          left: isSelect ? HYSizeFit.setRpx(12) : HYSizeFit.setRpx(18),
          right: isSelect ? HYSizeFit.setRpx(12) : HYSizeFit.setRpx(18)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(HYSizeFit.setRpx(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    subjectsModel.textSubject!,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: HYSizeFit.setRpx(16)),
                  ),
                  const Expanded(child: SizedBox()),
                  isSelect
                      ? Icon(
                          Icons.check_circle_rounded,
                          size: HYSizeFit.setRpx(18),
                          color: Colors.orangeAccent,
                        )
                      : Container()
                ],
              ),
              Text(
                subjectsModel.des!,
                style: TextStyle(
                    color: Colors.grey, fontSize: HYSizeFit.setRpx(12)),
              ),
              SizedBox(
                height: HYSizeFit.setRpx(8),
              ),
              Text(
                "${subjectsModel.questionCount} questions, ${subjectsModel.subjectCount} subjects",
                style: TextStyle(
                    color: Colors.grey, fontSize: HYSizeFit.setRpx(10)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
