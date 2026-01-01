import 'dart:math';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/customers/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerBookDetailsWidget extends StatelessWidget {
  const CustomerBookDetailsWidget({
    super.key,
    required this.bookDto,
    this.quantityOnTap,
    this.onChangeStatusTap,
    this.onDismissed,
    this.confirmDismiss,
  });
  final BookDto bookDto;
  final void Function()? quantityOnTap;
  final void Function(bool addedToCart)? onChangeStatusTap;
  final void Function(DismissDirection)? onDismissed;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: bookDto.statusBadge?.toLowerCase() == "received"
          ? DismissDirection.startToEnd
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Directionality.of(context) == ui.TextDirection.ltr
            ? Alignment.centerLeft
            : Alignment.centerRight,
        padding: 40.hPadding,
        child: Icon(Icons.delete, color: Colors.white, size: 30.r),
      ),
      key: UniqueKey(),
      confirmDismiss: confirmDismiss,
      onDismissed: onDismissed,
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: 2.allPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: GestureDetector(
                  onTap: quantityOnTap,
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                    child: Text(
                      bookDto.quantity?.toString() ?? 0.toString(),
                      style: AppTextStyles.body14(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
                title: Text(
                  "${bookDto.name}\n${bookDto.subject}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14(
                    context,
                  ).copyWith(color: Theme.of(context).scaffoldBackgroundColor),
                ),
                subtitle: Text(
                  bookDto.gradeName?.tr() ?? "Grade N/A",
                  style: AppTextStyles.body12(
                    context,
                  ).copyWith(color: Colors.white),
                ),

                trailing: StatusBadge(status: "${bookDto.statusBadge}"),
              ),
              ListTile(
                title: Text(
                  "${"Ordered".tr()}: ${DateFormat('dd/MM/yyyy').format(bookDto.createdAt ?? DateTime.now())}",
                  maxLines: 2,
                  style: AppTextStyles.body12(
                    context,
                  ).copyWith(color: Colors.white),
                ),

                trailing: Visibility(
                  visible:
                      bookDto.statusBadge?.toLowerCase() == "ready" ||
                      (!(bookDto.addedToCart ?? false) &&
                          bookDto.statusBadge?.toLowerCase() != "waiting"),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,

                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      onChangeStatusTap?.call(bookDto.addedToCart ?? false);
                    },
                    child: Text(
                      bookDto.addedToCart ?? false
                          ? "Mark as Received".tr()
                          : "Add to Cart".tr(),
                      style: AppTextStyles.body12(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Divider(indent: 16, endIndent: 16, color: Colors.white),
              8.height,
              Padding(
                padding: 16.hPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Icon(
                      bookDto.withHeight ?? false
                          ? Icons.crop_portrait_rounded
                          : Icons.crop_landscape_rounded,
                      size: 30.r,
                      color: Colors.blue,
                    ),
                    Text(
                      bookDto.withHeight ?? false
                          ? "print vertically".tr()
                          : "print horizontally".tr(),
                      style: AppTextStyles.body14(context).copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 12,
                  children: [
                    Text(
                      "Price".tr(),
                      style: AppTextStyles.body14(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                    Text(
                      "${bookDto.price} ${"EGP".tr()}",
                      style: AppTextStyles.body14(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
