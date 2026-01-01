import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/utils/custom_dialog.dart';
import 'package:engaz_app/core/utils/validators.dart';
import 'package:engaz_app/core/widgets/cupertino_text_form_field_row_helper.dart';
import 'package:engaz_app/core/widgets/toast.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer_book/customer_book_cubit.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_book_details_widget.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBookItem extends StatefulWidget {
  const CustomerBookItem({
    super.key,
    required this.book,
    required this.customer,
  });
  final CustomerDto customer;
  final BookDto book;

  @override
  State<CustomerBookItem> createState() => _CustomerBookItemState();
}

class _CustomerBookItemState extends State<CustomerBookItem> {
  @override
  Widget build(BuildContext context) {
    return CustomerBookDetailsWidget(
      bookDto: widget.book,
      confirmDismiss: (direction) async {
        // Show confirmation dialog before deletion
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Remove Book".tr()),
            content: Text(
              "Are you sure you want to remove this book? This action cannot be undone."
                  .tr(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("cancel".tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text("Remove".tr()),
              ),
            ],
          ),
        );

        if (shouldDelete == true) {
          context.read<CustomerBookCubit>().removeBook(
            widget.customer.phone ?? "",
            widget.book,
          );
          return true;
        }
        return false;
      },
      onDismissed: (direction) {
        // This will be called after confirmDismiss returns true
        // The actual removal is handled in confirmDismiss
      },
      onChangeStatusTap: (bool addedToCart) {
        if (!addedToCart) {
          context.read<CustomerBookCubit>().addBookToCart(
            widget.customer.phone ?? "",
            widget.book.id ?? "",
          );
        } else {
          final updatedBook = widget.book.copyWith(statusBadge: "received");
          context.read<CustomerBookCubit>().updateBook(
            widget.customer.phone ?? "",
            updatedBook,
          );
        }
      },
      quantityOnTap: () async {
        quantityController.text = widget.book.quantity.toString();
        await customDialog(
          context,
          title: "Update Quantity",
          buttonText: "Update",

          content: CupertinoTextFormFieldHelper(
            controller: quantityController,
            scrollEnabled: false,
            hint: "Quantity".tr(),
            keyboardType: TextInputType.number,
            validator: Validator.validateQuantity,
          ),
          onPressed: () {
            final quantityText = quantityController.text.trim();
            if (quantityText.isEmpty) {
              Toast.warning(context, "Please enter quantity".tr());
              return;
            }
            final newQuantity = int.tryParse(quantityText);
            if (newQuantity == null || newQuantity <= 0) {
              Toast.warning(context, "Please enter a valid number".tr());
              return;
            }
            final updatedBook = widget.book.copyWith(quantity: newQuantity);
            context.read<CustomerBookCubit>().updateBook(
              widget.customer.phone ?? "",
              updatedBook,
            );
            quantityController.clear();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  late final TextEditingController quantityController;
  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController();
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }
}
