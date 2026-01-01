import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/widgets/custom_cupertino_pop_up.dart';
import 'package:engaz_app/core/widgets/toast.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer_book/customer_book_cubit.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_book_form.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/shared/presentation/view_model/popup_form/popup_form_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCustomerBookButton extends StatefulWidget {
  const AddCustomerBookButton({super.key, required this.customer});
  final CustomerDto customer;

  @override
  State<AddCustomerBookButton> createState() => _AddCustomerBookButtonState();
}

class _AddCustomerBookButtonState extends State<AddCustomerBookButton> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBookCubit, CustomerBookState>(
      listener: (BuildContext context, CustomerBookState customerBookState) {
        if (customerBookState is CustomerBookError) {
          Toast.error(context, customerBookState.message);
        }
        if (customerBookState is CustomerBookAdded) {
          Toast.success(context, "Customer book added successfully".tr());
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 16.w, left: 8.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: () {
            book = BookDto();
            customCupertinoPopUp(
              context,
              title: "Add New Customer Book",
              cancelOnPressed: () {
                context.read<PopupFormCubit>().reset({});
              },
              content: StatefulBuilder(
                builder: (context, setState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomerBookForm(
                      formKey: formKey,
                      quantityController: quantityController,
                      bookDto: book,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("print vertically".tr()),
                      value: withHeight,
                      onChanged: (value) {
                        setState(() {
                          withHeight = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              buttonText: "Add".tr(),
              onPressed: () {
                book = context.read<PopupFormCubit>().getValue('selected_book');
                if (!formKey.currentState!.validate() || book.name == null) {
                  Navigator.of(context).pop();
                  Toast.warning(context, "Please fill all fields".tr());
                  return;
                }
                book.quantity = int.tryParse(quantityController.text) ?? 0;
                book.statusBadge = "waiting";
                book.createdAt = DateTime.now();
                book.withHeight = withHeight;
                if (withHeight) {
                  book.price = 2 * book.price! - 10;
                }
                book.addedToCart = false;
                context.read<CustomerBookCubit>().addBook(
                  widget.customer.phone ?? "",
                  book,
                );
                quantityController.clear();
                Navigator.of(context).pop();
                context.read<PopupFormCubit>().reset({});
                withHeight = false;
              },
            );
          },

          child: Text(
            "Add Book".tr(),
            style: TextStyle(color: Colors.black, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }

  late BookDto book;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController quantityController;
  bool withHeight = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    quantityController = TextEditingController();
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }
}
