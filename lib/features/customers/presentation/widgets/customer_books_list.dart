import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/utils/custom_dialog.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/utils/validators.dart';
import 'package:engaz_app/core/widgets/cupertino_text_form_field_row_helper.dart';
import 'package:engaz_app/core/widgets/toast.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_state.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer_book/customer_book_cubit.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_book_item.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBooksList extends StatefulWidget {
  const CustomerBooksList({super.key, required this.customer});
  final CustomerDto customer;

  @override
  State<CustomerBooksList> createState() => _CustomerBooksListState();
}

class _CustomerBooksListState extends State<CustomerBooksList> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBookCubit, CustomerBookState>(
      listener: (context, state) {
        if (state is CustomerBookError) {
          Toast.error(context, state.message);
        }
        if (state is CustomerBookAdded) {
          Toast.success(context, "Customer book added successfully".tr());
        }
      },
      child: BlocListener<CustomerCubit, CustomerState>(
        listener: (context, state) {
          if (state is CustomerUpdateSuccess) {
            Toast.success(context, "customer updated successfully".tr());
          }
          if (state is CustomerUpdateFailure) {
            Toast.error(context, state.message);
          }
        },
        child: BlocBuilder<CustomerBookCubit, CustomerBookState>(
          builder: (context, state) {
        final List<BookDto> books = state is CustomerBookLoaded
            ? state.books
            : [];
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: 16.allPadding,
                itemCount: books.length,
                itemBuilder: (_, index) => CustomerBookItem(
                  book: books[index],
                  customer: widget.customer,
                ),
              ),
            ),
            _buildPriceRow(
              "Total",
              "${calculateTotalPrice(books)} ${"EGP".tr()}",
            ),
            BlocBuilder<CustomerCubit, CustomerState>(
              builder: (context, state) {
                final CustomerDto? customer = state is CustomerUpdateSuccess
                    ? state.customer
                    : widget.customer;
                widget.customer.paid = customer?.paid ?? 0.0;

                return GestureDetector(
                  onTap: () async {
                    paidController.text = widget.customer.paid.toString();
                    await customDialog(
                      context,
                      title: "Update Payment".tr(),
                      buttonText: "Update",

                      content: CupertinoTextFormFieldHelper(
                        controller: paidController,
                        scrollEnabled: false,
                        hint: "Paid".tr(),
                        keyboardType: TextInputType.number,
                        validator: Validator.validateQuantity,
                      ),
                      onPressed: () {
                        final updatedBook = widget.customer.copyWith(
                          paid: double.tryParse(paidController.text),
                        );
                        context.read<CustomerCubit>().updateCustomer(
                          customer: updatedBook,
                        );
                        paidController.clear();
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Column(
                    children: [
                      _buildPriceRow("Paid", "${customer?.paid} ${"EGP".tr()}"),
                      Divider(indent: 16, endIndent: 16),
                      _buildPriceRow(
                        "Remaining",
                        "${calculateTotalPrice(books) - customer!.paid!} ${"EGP".tr()}",
                        isBold: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
          },
        ),
      ),
    );
  }

  late TextEditingController paidController;
  @override
  void initState() {
    super.initState();
    paidController = TextEditingController();
  }

  @override
  void dispose() {
    paidController.dispose();
    super.dispose();
  }
}

double calculateTotalPrice(List<BookDto> books) {
  double totalPrice = 0.0;
  for (var book in books) {
    if (book.statusBadge != "received") {
      totalPrice += book.price! * book.quantity!;
    }
  }
  return totalPrice;
}

Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.tr(),
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppColor.darkPrimary,
          ),
        ),
      ],
    ),
  );
}
