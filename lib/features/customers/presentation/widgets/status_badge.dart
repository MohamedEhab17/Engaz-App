import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> statusMap = {
      "waiting": {
        "color": Colors.yellow[700],
        "icon": Icons.access_time,
        "textColor": Colors.brown,
      },
      "ready": {
        "color": Colors.green[400],
        "icon": Icons.check_circle,
        "textColor": Colors.white,
      },
      "received": {
        "color": Colors.blue[400],
        "icon": Icons.done_all,
        "textColor": Colors.white,
      },
    };

    final data = statusMap[status.toLowerCase()] ?? statusMap["waiting"];

    return Card(
      color: data["color"],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(data["icon"], size: 16.h, color: data["textColor"]),
            Text(
              status.tr(),
              style: AppTextStyles.body12(
                context,
              ).copyWith(color: data["textColor"]),
            ),
          ],
        ),
      ),
    );
  }
}
