import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SwitchButtonWidget extends StatelessWidget {
  const SwitchButtonWidget({
    super.key,
    required this.checked,
    this.onChanged,
    required this.activeThumbImage,
    required this.inactiveThumbImage,
  });
  final bool checked;
  final void Function(bool)? onChanged;
  final String activeThumbImage;
  final String inactiveThumbImage;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: checked,
      activeThumbImage: AssetImage(activeThumbImage),
      inactiveThumbImage: AssetImage(inactiveThumbImage),
      activeTrackColor: AppColor.lightCardColor,
      inactiveTrackColor: AppColor.darkCardColor,

      onChanged: onChanged,
    );
  }
}
