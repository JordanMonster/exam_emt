import 'package:flutter/cupertino.dart';

class HYSizeFit {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? rpx;
  static double? hRpx;
  static double? px;

  static void initialize(BuildContext context,
      {double standardWidth = 375, double standardHeight = 812}) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    rpx = screenWidth! / standardWidth;
    px = screenWidth! / standardWidth * 2;
    hRpx = screenHeight! / standardHeight;
  }

  // 按照像素来设置
  static double setPx(double size) {
    return HYSizeFit.rpx! * size * 2;
  }

  // 按照rxp来设置
  static double setRpx(double size) {
    return HYSizeFit.rpx! * size;
  }

  // 按照rxp来设置
  static double sethRpx(double size) {
    return HYSizeFit.hRpx! * size;
  }

  static double setLHRpx(double size) {
    if (screenHeight! < 700.0) {
      return (HYSizeFit.hRpx! * size) + 50;
    }
    return HYSizeFit.hRpx! * size;
  }
}
