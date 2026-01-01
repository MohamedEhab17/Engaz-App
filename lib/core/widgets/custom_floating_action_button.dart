import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    this.child,
    required this.toolTip,
    required this.heroTag,  
    this.backgroundColor,
  });
  final void Function()? onPressed;
  final Widget? child;
  final String toolTip;
  final String heroTag;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: toolTip.tr(),

      backgroundColor:backgroundColor?? Theme.of(context).cardColor,
      foregroundColor: Colors.white,
      heroTag: heroTag,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,

      onPressed: onPressed,
      child:
          child ?? const Icon(Icons.add, size: 30, fontWeight: FontWeight.w800),
    );
  }
}
