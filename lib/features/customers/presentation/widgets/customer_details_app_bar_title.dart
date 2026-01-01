import 'dart:ui' as ui;

import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:flutter/material.dart';

class CustomerDetailsAppBarTitle extends StatelessWidget {
  const CustomerDetailsAppBarTitle({super.key, this.customerDto});
  final CustomerDto? customerDto;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Directionality.of(context) == ui.TextDirection.ltr
            ? Alignment.centerLeft
            : Alignment.centerRight,

        child: Text(
          customerDto?.name ?? "",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: AppTextStyles.h3Regular24(
            context,
          ).copyWith(color: AppColor.darkPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      subtitle: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Directionality.of(context) == ui.TextDirection.ltr
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Text(
          customerDto?.phone ?? "",
          textAlign: Directionality.of(context) == ui.TextDirection.ltr
              ? TextAlign.start
              : TextAlign.end,
          textDirection: ui.TextDirection.ltr,
          style: AppTextStyles.body20(
            context,
          ).copyWith(color: AppColor.darkPrimary, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
