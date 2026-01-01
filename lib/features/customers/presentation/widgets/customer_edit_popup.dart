import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/widgets/custom_cupertino_pop_up.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showCustomerEditPopup(BuildContext context, CustomerDto customer) {
  final nameController = TextEditingController(text: customer.name);

  final phoneController = TextEditingController(
    text: customer.phone?.replaceFirst("+2", ""),
  );
  final addressController = TextEditingController(text: customer.address);
  final formKey = GlobalKey<FormState>();

  customCupertinoPopUp(
    context,
    title: "Update Customer".tr(),
    content: CustomerForm(
      formKey: formKey,
      nameController: nameController,
      phoneController: phoneController,
      addressController: addressController,
    ),

    buttonText: "Update".tr(),
    onPressed: () {
      if (!formKey.currentState!.validate()) return;

      if (phoneController.text.startsWith('0')) {
        phoneController.text = phoneController.text.substring(1);
      }

      context.read<CustomerCubit>().updateCustomer(
        customer: customer.copyWith(
          name: nameController.text,
          phone: "+20${phoneController.text}",
          address: addressController.text,
        ),
      );

      Navigator.pop(context);
    },
  );
}
