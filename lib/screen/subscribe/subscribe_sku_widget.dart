import 'package:flutter/material.dart';
import 'package:questionhub/utils/screen_utils.dart';

class SubscribeSkuWidget extends StatelessWidget {
  final Color color;
  final bool haveTag;
  final String tagText;
  final String price;
  final String description;
  final String title;
  final GestureTapCallback? onTap;

  SubscribeSkuWidget(
      {Key? key,
      required this.color,
      required this.haveTag,
      required this.tagText,
      this.onTap,
      required this.price,
      required this.description,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            children: [
              SizedBox(height: HYSizeFit.sethRpx(14)),
              Container(
                  child: Container(
                      width: HYSizeFit.sethRpx(107),
                      height: HYSizeFit.sethRpx(170),
                      child: Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          Text(price,
                              style: TextStyle(
                                  fontSize: HYSizeFit.sethRpx(24),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text(title,
                              style: TextStyle(
                                  fontSize: HYSizeFit.sethRpx(10),
                                  color: Colors.grey)),
                          Container(
                              margin: EdgeInsets.all(HYSizeFit.sethRpx(13)),
                              color: const Color(0xFFC9CDD4),
                              height: 1),
                          Container(
                              padding: EdgeInsets.all(HYSizeFit.sethRpx(4)),
                              child: Text(description,
                                  style: TextStyle(
                                      fontSize: HYSizeFit.sethRpx(12),
                                      color: const Color(0xFF57B9A4),
                                      fontWeight: FontWeight.bold)),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFEBF6EF),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(HYSizeFit.sethRpx(12))))),
                          const Expanded(child: SizedBox())
                        ],
                      ),
                      margin: EdgeInsets.all(HYSizeFit.sethRpx(1)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(HYSizeFit.sethRpx(8))))),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(
                          Radius.circular(HYSizeFit.sethRpx(8)))))
            ],
          ),
          haveTag
              ? Positioned(
                  top: 0,
                  child: Container(
                      height: HYSizeFit.sethRpx(28),
                      child: Text(
                        tagText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: HYSizeFit.sethRpx(16)),
                      ),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.all(
                              Radius.circular(HYSizeFit.sethRpx(8))))))
              : Container()
        ],
      ),
    );
  }
}
