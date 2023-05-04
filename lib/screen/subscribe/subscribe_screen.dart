import 'package:flutter/material.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/commons/res/res_string.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:questionhub/purchase/purchase_manager.dart';
import 'package:questionhub/screen/subscribe/subscribe_sku_widget.dart';
import 'package:questionhub/utils/screen_utils.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({Key? key}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final SubscribeStr resStr = SubscribeStr();
  final SubscribeColor resColor = SubscribeColor();

  int _selectPosition = 1;
  List<ProductDetails> _products = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _queryProduct();
  }

  _queryProduct() async {
    _products = await PurchaseManager.instance.queryProductDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var topSize = SizedBox(height: HYSizeFit.sethRpx(11));
    return Material(
        child: Container(
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image(
              image: AssetImage("assets/images/sub_background.png"),
              fit: BoxFit.fitWidth,
            )),
        Positioned(
            top: HYSizeFit.sethRpx(236),
            child: Column(
              children: [
                Text(
                  resStr.titleText,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: HYSizeFit.sethRpx(30)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topSize,
                    _iconText(
                        resStr.wrongText, "assets/images/icon_sub_wrong.png"),
                    topSize,
                    _iconText(resStr.simText, "assets/images/icon_sub_sim.png"),
                    topSize,
                    _iconText(
                        resStr.recordText, "assets/images/icon_sub_record.png"),
                    topSize,
                    _iconText(resStr.achText, "assets/images/icon_sub_ach.png"),
                  ],
                ),
                SizedBox(height: HYSizeFit.sethRpx(26)),
                SizedBox(
                  height: HYSizeFit.sethRpx(200),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SubscribeSkuWidget(
                        color: _selectPosition == index
                            ? resColor.skuSelectdColor
                            : resColor.skuUnSelectColor,
                        haveTag: index == 0 ? false : true,
                        tagText: "a",
                        onTap: () {
                          setState(() {
                            _selectPosition = index;
                          });
                        },
                        description: _products[index].description,
                        title: _products[index].title,
                        price: _products[index].price,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: HYSizeFit.sethRpx(16));
                    },
                  ),
                )
              ],
            ))
      ]),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [resColor.backgroundTopColor, resColor.backgroundBottomColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
    ));
  }

  _iconText(String text, String iconPath) {
    return Row(
      children: [
        Image(
            image: AssetImage(iconPath),
            width: HYSizeFit.sethRpx(15),
            height: HYSizeFit.sethRpx(15)),
        SizedBox(
          width: HYSizeFit.sethRpx(14),
        ),
        Text(text,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontSize: HYSizeFit.sethRpx(14),
                fontWeight: FontWeight.w700))
      ],
    );
  }
}
