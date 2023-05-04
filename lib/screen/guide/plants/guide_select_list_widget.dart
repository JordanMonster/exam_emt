import 'package:flutter/material.dart';
import 'package:questionhub/commons/global.dart';
import 'package:questionhub/utils/screen_utils.dart';

typedef SelectListIndex = void Function(String index);

class GuideSelectListWidget extends StatefulWidget {
  final List<String> list;
  final Color activeColor;
  final SelectListIndex? selectListIndex;
  final bool? isMutil;
  String? selectIndex = "0";

  GuideSelectListWidget(
      {Key? key,
      required this.list,
      required this.activeColor,
      this.selectListIndex,
      this.selectIndex,
      this.isMutil = false})
      : super(key: key);

  @override
  State<GuideSelectListWidget> createState() => _GuideSelectListWidgetState();
}

class _GuideSelectListWidgetState extends State<GuideSelectListWidget> {
  var selectIndex = 0;
  var selectd = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    if (widget.isMutil!) {
      selectd.addAll(widget.selectIndex!.split(":"));
    } else {
      selectIndex = int.parse(widget.selectIndex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: HYSizeFit.sethRpx(26),
          bottom: HYSizeFit.sethRpx(26),
          left: HYSizeFit.sethRpx(42),
          right: HYSizeFit.sethRpx(42)),
      width: HYSizeFit.screenWidth!,
      child: Container(
        margin: EdgeInsets.only(
            left: HYSizeFit.sethRpx(20), right: HYSizeFit.sethRpx(20)),
        child: MediaQuery.removePadding(
            removeTop: true,
            removeBottom: true,
            context: context,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.list.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      if (widget.isMutil!) {
                        selectd.contains("$index")
                            ? selectd.remove("$index")
                            : selectd.add("$index");
                        var selectors = "";
                        for (var element in selectd) {
                          selectors.isEmpty
                              ? selectors += "$element"
                              : selectors += ":$element";
                        }

                        widget.selectListIndex?.call(selectors);
                      } else {
                        selectIndex = index;
                        widget.selectListIndex?.call("$index");
                      }

                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: HYSizeFit.sethRpx(12),
                              bottom: HYSizeFit.sethRpx(12)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                widget.list[index],
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: (widget.isMutil!
                                            ? selectd.contains("$index")
                                            : selectIndex == index)
                                        ? Colors.black
                                        : const Color(0xFF8F8F92),
                                    fontSize: 18),
                              )),
                              Checkbox(
                                side: const BorderSide(
                                    color: Color(0xFF8F8F92), width: 1),
                                value: widget.isMutil!
                                    ? selectd.contains("$index")
                                    : selectIndex == index,
                                activeColor: widget.activeColor,
                                shape: const CircleBorder(),
                                onChanged: (bool? value) {},
                              )
                            ],
                          ),
                        ),
                        index != widget.list.length - 1
                            ? Container(
                                width: HYSizeFit.sethRpx(310),
                                height: 1,
                                color: const Color(0xFFE5E6EB))
                            : Container()
                      ],
                    ),
                  );
                })),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 9,
            offset: const Offset(-0.2, 1),
          ),
        ],
      ),
    );
  }
}
