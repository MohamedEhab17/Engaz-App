import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = "Select",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          dropdownColor:
              Theme.of(context).scaffoldBackgroundColor ==
                  AppColor.darkScaffoldColor
              ? Colors.black
              : Colors.white,
          menuMaxHeight: 300,
          value: value,
          hint: Text(hintText.tr()),
          isExpanded: true,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item.tr(),
                    style: AppTextStyles.body14(context).copyWith(
                      color:
                          Theme.of(context).scaffoldBackgroundColor ==
                              AppColor.darkScaffoldColor
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
