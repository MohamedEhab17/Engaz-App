import 'package:flutter/material.dart';

//! extension to add space using sizedBox
//* using : 16.height or 16.width
extension SizeExtensions on num {
  Widget get height => SizedBox(height: toDouble());
  Widget get width => SizedBox(width: toDouble());
}

//! Padding extension
//* using : 16.hPadding
//* using : 16.vPadding
//* using : 16.vhPadding
//* using : 16.allPadding
//* using : 16.topPadding
//* using : 16.bottomPadding
//* using : 16.leftPadding
//* using : 16.rightPadding
extension PaddingExtensions on num {
  EdgeInsets get hPadding => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vPadding => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get vhPadding =>
      EdgeInsets.symmetric(vertical: toDouble(), horizontal: toDouble());
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());
  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());
  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());
  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());
}
