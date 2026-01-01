import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/constants/fonts_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Display
  static TextStyle display64(context) => TextStyle(
    fontSize: 64.sp,
    fontWeight: FontWeight.w700,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle display48(context) => TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w600,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  // Headings
  static TextStyle h1Bold32(context) => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle h1Regular32(context) => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle h2SemiBold28(context) => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle h2Regular28(context) => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle h3SemiBold24(context) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle h3Regular24(context) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    fontFamily: cairoFont,
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  // Body
  static TextStyle body20(context) => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );
  static TextStyle body16(context) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle body16SemiBold(context) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle body14(context) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle body14SemiBold(context) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle body12(context) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  // Labels
  static TextStyle label12(context) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );

  static TextStyle label10(context) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    // fontFamily: "Poppins",
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkTextColor
        : AppColor.lightTextColor,
  );
}
