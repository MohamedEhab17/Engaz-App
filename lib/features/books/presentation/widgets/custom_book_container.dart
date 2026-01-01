import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/constants/app_icons.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/custom_dialog.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/utils/subjects_list.dart';
import 'package:engaz_app/core/widgets/toast.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:engaz_app/features/books/presentation/view_model/book/books_cubit.dart';
import 'package:engaz_app/features/books/presentation/view_model/book/books_state.dart';
import 'package:engaz_app/core/widgets/custom_cupertino_pop_up.dart';
import 'package:engaz_app/core/widgets/text_form_field_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustoMBookContainer extends StatefulWidget {
  const CustoMBookContainer({
    super.key,
    required this.bookModel,
    required this.gradeDto,
  });
  final BookDto bookModel;
  final GradeDto gradeDto;

  @override
  State<CustoMBookContainer> createState() => _CustoMBookContainerState();
}

class _CustoMBookContainerState extends State<CustoMBookContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, CustomerState>(
      builder: (context, state) {
        late BookDto book;
        if (state is GetBookSuccess) {
          book = state.books.firstWhere((b) => b.id == widget.bookModel.id);
          log(book.name.toString());
        }
        return Container(
          padding: 16.vhPadding,
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

          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(book.name ?? "", style: AppTextStyles.body16(context)),
                  Text(
                    subjects[subjects.indexOf(book.subject ?? "")].tr(),
                    style: AppTextStyles.body14(context),
                  ),
                  Text(
                    "${book.price} ${"EGP".tr()}",
                    style: AppTextStyles.body16SemiBold(
                      context,
                    ).copyWith(color: Colors.blue),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      customCupertinoPopUp(
                        context,
                        title: "Edit Book",
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Book Name".tr(),
                              style: AppTextStyles.body14(context),
                            ),
                            TextFormFieldHelper(
                              hint: "Book Name".tr(),
                              controller: nameController,
                            ),
                            6.height,
                            Text(
                              "Subject".tr(),
                              style: AppTextStyles.body14(context),
                            ),
                            TextFormFieldHelper(
                              hint: "Subject".tr(),
                              controller: subjectController,
                            ),
                            6.height,
                            Text(
                              "Price".tr(),
                              style: AppTextStyles.body14(context),
                            ),
                            TextFormFieldHelper(
                              hint: "Price".tr(),
                              controller: priceController,
                            ),
                          ],
                        ),
                        buttonText: "Edit",
                        onPressed: () {
                          // Validate price before parsing
                          final priceText = priceController.text.trim();
                          if (priceText.isEmpty) {
                            Toast.warning(context, "Please enter price".tr());
                            return;
                          }
                          final price = double.tryParse(priceText);
                          if (price == null || price <= 0) {
                            Toast.warning(
                              context,
                              "Please enter a valid price".tr(),
                            );
                            return;
                          }

                          if (nameController.text.trim().isEmpty) {
                            Toast.warning(
                              context,
                              "Please enter book name".tr(),
                            );
                            return;
                          }

                          if (subjectController.text.trim().isEmpty) {
                            Toast.warning(context, "Please enter subject".tr());
                            return;
                          }

                          context.read<BooksCubit>().updateBook(
                            widget.gradeDto,
                            widget.bookModel.copyWith(
                              name: nameController.text.trim(),
                              subject: subjectController.text.trim(),
                              price: price,
                            ),
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                    icon: Icon(IconlyBold.edit, color: AppColor.darkPrimary),
                  ),
                  IconButton(
                    onPressed: () {
                      customDialog(
                        context,
                        title: "Are you sure?",
                        onPressed: () {
                          context.read<BooksCubit>().deleteBook(
                            widget.gradeDto,
                            widget.bookModel.id!,
                          );
                          Navigator.pop(context);
                        },
                        content: Lottie.asset(
                          AppIcons.iconsDelete,
                          height: 100.w,
                          width: 100.w,
                        ),
                        buttonText: "Delete",
                      );
                    },
                    icon: Icon(IconlyBold.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  late TextEditingController nameController;
  late TextEditingController subjectController;
  late TextEditingController priceController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.bookModel.name);
    subjectController = TextEditingController(text: widget.bookModel.subject);
    priceController = TextEditingController(
      text: widget.bookModel.price.toString(),
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    subjectController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
