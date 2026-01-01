import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/presentation/view/customer_details_view.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer_book/customer_book_cubit.dart';
import 'package:engaz_app/features/customers/presentation/widgets/custom_customer_container.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_edit_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerItem extends StatelessWidget {
  final CustomerDto customer;
  const CustomerItem({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return CustomCustomerContainer(
      customerDto: customer,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          showCustomerEditPopup(context, customer);
          return false;
        } else {
          // Show confirmation dialog before deletion
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Delete Customer".tr()),
              content: Text(
                "Are you sure you want to delete this customer? This action cannot be undone.".tr(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel".tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text("Delete".tr()),
                ),
              ],
            ),
          );
          
          if (shouldDelete == true) {
            context.read<CustomerCubit>().deleteCustomer(
              phone: customer.phone ?? "",
            );
            return true;
          }
          return false;
        }
      },
      onPressed: () {
        context.read<CustomerBookCubit>().getCustomerBooks(
          customer.phone ?? "",
        );
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CustomerDetailsView(customerDto: customer),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
    );
  }
}
