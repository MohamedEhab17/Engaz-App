import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class GradeListTile extends StatelessWidget {
  const GradeListTile({super.key, required this.title, this.onTap});
  final String title;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title.tr()),
      titleTextStyle: AppTextStyles.body16SemiBold(context),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColor.darkPrimary),
    );
  }
}
