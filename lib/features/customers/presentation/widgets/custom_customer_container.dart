import 'dart:ui' as ui;
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/helper/open_phone_or_whats_app.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/utils/string_util.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCustomerContainer extends StatelessWidget {
  const CustomCustomerContainer({
    super.key,
    required this.customerDto,
    this.onPressed,
    this.confirmDismiss,
  });
  final CustomerDto customerDto;
  final void Function()? onPressed;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Directionality.of(context) == ui.TextDirection.ltr
            ? Alignment.centerLeft
            : Alignment.centerRight,
        padding: 40.hPadding,
        child: Icon(Icons.delete, color: Colors.white, size: 30.r),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Directionality.of(context) == ui.TextDirection.ltr
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: 40.hPadding,
        child: Icon(Icons.edit, color: Colors.white, size: 30.r),
      ),
      confirmDismiss: confirmDismiss,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkScaffoldColor
              : AppColor.lightScaffoldColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(50),
            bottomRight: const Radius.circular(50),
          ),
          border: Border.symmetric(
            vertical: BorderSide(color: Colors.grey, width: 15),
            horizontal: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        child: Padding(
          padding: 16.allPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                spacing: 12,
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                    child: Text(
                      initials(customerDto.name ?? ""),
                      style: AppTextStyles.body14(context),
                      // .copyWith(color: Colors.white),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        customerDto.name ?? "N/A",
                        style: AppTextStyles.body16(context),
                      ),

                      Row(
                        spacing: 4,
                        children: [
                          Transform.flip(
                            flipX:
                                Directionality.of(context) ==
                                ui.TextDirection.rtl,
                            child: Icon(
                              Icons.phone,
                              size: 16.h,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openPhoneOrWhatsApp(customerDto.phone ?? "");
                            },
                            child: Text(
                              customerDto.phone ?? "+20123456789",
                              textAlign: TextAlign.end,
                              textDirection: ui.TextDirection.ltr,
                              style: AppTextStyles.body14(
                                context,
                              ).copyWith(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              Text(
                "${"Not in Shopping Cart".tr()}: (${customerDto.shoppingCartCount ?? 0})",
                style: AppTextStyles.body14(
                  context,
                ).copyWith(color: Colors.blue),
              ),
              Text(
                "${"Books Ordered".tr()}: (${customerDto.numberOfBooks ?? 0})",
                style: AppTextStyles.body14(
                  context,
                ).copyWith(color: Colors.blue),
              ),
              Text(
                "${"Address".tr()}: ${customerDto.address ?? "Engaz"}",
                style: AppTextStyles.body14(
                  context,
                ).copyWith(color: Colors.grey),
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.darkPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    "View".tr(),
                    style: AppTextStyles.body14(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
