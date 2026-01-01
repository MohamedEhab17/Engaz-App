import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/utils/grades_list.dart';
import 'package:engaz_app/core/utils/subjects_list.dart';
import 'package:engaz_app/core/widgets/custom_drop_down.dart';
import 'package:engaz_app/core/widgets/text_form_field_helper.dart';
import 'package:engaz_app/features/customers/presentation/view_model/book_popup/book_popup_cubit.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/shared/presentation/view_model/popup_form/popup_form_cubit_cubit.dart';
import 'package:engaz_app/shared/presentation/view_model/popup_form/popup_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBookForm extends StatelessWidget {
  const CustomerBookForm({
    super.key,
    required this.formKey,
    required this.quantityController,
    required this.bookDto,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController quantityController;
  final BookDto bookDto;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopupFormCubit, PopupFormState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              CustomDropdown(
                value: state.values['grade'],
                items: GradeConstants.gradesList,
                hintText: "Select Grade",
                onChanged: (value) {
                  bookDto.gradeName = value;
                  context.read<PopupFormCubit>().setValue('grade', value);
                },
              ),
              BlocBuilder<BookPopupCubit, BookPopupState>(
                builder: (context, bookPopUp) {
                  return CustomDropdown(
                    value: state.values['subject'],
                    items: bookDto.gradeName == null ? [] : subjects,
                    hintText: "Select Subject",
                    onChanged: (value) {
                      bookDto.subject = value;
                      context.read<PopupFormCubit>().setValue('subject', value);
                      context.read<BookPopupCubit>().getBooksByGradeAndSubject(
                        gradeId:
                            (GradeConstants.gradesList.indexOf(
                                      bookDto.gradeName ??
                                          GradeConstants.gradesList[0],
                                    ) +
                                    1)
                                .toString(),
                        subject: bookDto.subject ?? "",
                      );
                    },
                  );
                },
              ),
              BlocBuilder<BookPopupCubit, BookPopupState>(
                builder: (context, bookState) {
                  return CustomDropdown(
                    value: state.values['book_name'],
                    items: bookDto.subject == null
                        ? []
                        : bookState is BookPopupLoaded
                        ? bookState.books.map((e) => e.name ?? "").toList()
                        : [],
                    hintText: "Select Book Name",
                    onChanged: (value) {
                      final BookDto selected = bookState is BookPopupLoaded
                          ? bookState.books.firstWhere(
                              (book) => book.name == value,
                              orElse: () => BookDto(),
                            )
                          : BookDto();

                      context.read<PopupFormCubit>().setValue(
                        'book_name',
                        value,
                      );
                      context.read<PopupFormCubit>().setValue(
                        'selected_book',
                        selected,
                      );
                    },
                  );
                },
              ),
              TextFormFieldHelper(
                controller: quantityController,
                hint: "Quantity".tr(),
                keyboardType: TextInputType.number,
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter quantity".tr();
                  }
                  if (int.tryParse(value) == null) {
                    return "Please enter a valid number".tr();
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
