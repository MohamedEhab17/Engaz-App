import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/utils/grades_list.dart';
import 'package:engaz_app/core/utils/subjects_list.dart';
import 'package:engaz_app/features/reservations/data/model/reservation_row_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationRowItem extends StatelessWidget {
  const ReservationRowItem({
    super.key,
    required this.reservation,
    required this.isReady,
    required this.onFinalize,
    // required this.onDelete,
  });

  final ReservationRowDto reservation;
  final bool isReady;
  final VoidCallback onFinalize;
  // final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: 16.allPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkCardColor
            : AppColor.lightCardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isReady ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.bookName ?? "Unknown Book",
                      style: AppTextStyles.body16SemiBold(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.height,
                    Text(
                      "${subjects[subjects.indexOf(reservation.subject ?? "")].tr()} - ${GradeConstants.gradesList[GradeConstants.gradesList.indexOf(reservation.gradeName ?? "")].tr()}",
                      style: AppTextStyles.body14(
                        context,
                      ).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isReady ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isReady ? "Ready".tr() : "Pending".tr(),
                  style: AppTextStyles.body12(
                    context,
                  ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              _buildInfoItem(
                context,
                Icons.inventory_2,
                "Quantity".tr(),
                "${reservation.totalQuantity ?? 0}",
              ),
              16.width,
              _buildInfoItem(
                context,
                Icons.attach_money,
                "Total Price".tr(),
                "${reservation.totalPrice?.toStringAsFixed(2) ?? "0.00"} ${"EGP".tr()}",
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              Icon(
                Icons.swap_vertical_circle,
                size: 16.r,
                color: AppColor.darkPrimary,
              ),
              4.width,
              Text(
                "${"print vertically".tr()}: ",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: Colors.grey),
              ),
              4.width,
              Text(
                "${(reservation.numWithHeight ?? 0) + (reservation.readyHeight ?? 0)}",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: AppColor.darkPrimary),
              ),
              Spacer(),
              Icon(Icons.print, size: 16.r, color: AppColor.darkPrimary),
              4.width,
              Text(
                "${"printed".tr()}: ",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: Colors.grey),
              ),
              4.width,
              Text(
                "${reservation.printedHeight ?? 0}",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: AppColor.darkPrimary),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.swap_horizontal_circle,
                size: 16.r,
                color: AppColor.darkPrimary,
              ),
              4.width,
              Text(
                "${"print horizontally".tr()}: ",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: Colors.grey),
              ),
              4.width,
              Text(
                "${(reservation.numWithWidth ?? 0) + (reservation.readyWidth ?? 0)}",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: AppColor.darkPrimary),
              ),
              Spacer(),
              Icon(Icons.print, size: 16.r, color: AppColor.darkPrimary),
              4.width,
              Text(
                "${"printed".tr()}: ",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: Colors.grey),
              ),
              4.width,
              Text(
                "${reservation.printedWidth ?? 0}",
                style: AppTextStyles.body12(
                  context,
                ).copyWith(color: AppColor.darkPrimary),
              ),
            ],
          ),
          16.height,
          if (!isReady)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onFinalize,
                icon: const Icon(Icons.check_circle),
                label: Text("Confirm Reservation".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          // if (isReady)
          //   SizedBox(
          //     width: double.infinity,
          //     child: OutlinedButton.icon(
          //       onPressed: onDelete,
          //       icon: const Icon(Icons.delete_outline),
          //       label: Text("Delete Reservation".tr()),
          //       style: OutlinedButton.styleFrom(
          //         foregroundColor: Colors.red,
          //         padding: EdgeInsets.symmetric(vertical: 12.h),
          //         side: const BorderSide(color: Colors.red),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8.r),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18.r, color: AppColor.darkPrimary),
          8.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body12(
                    context,
                  ).copyWith(color: Colors.grey),
                ),
                2.height,
                Text(value, style: AppTextStyles.body14SemiBold(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
