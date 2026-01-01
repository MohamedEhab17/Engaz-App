import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/widgets/custom_cupertino_pop_up.dart';
import 'package:engaz_app/core/widgets/custom_floating_action_button.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_form.dart';

class AddCustomerFab extends StatefulWidget {
  const AddCustomerFab({super.key});

  @override
  State<AddCustomerFab> createState() => _AddCustomerFabState();
}

class _AddCustomerFabState extends State<AddCustomerFab> {
  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      toolTip: "Add New Customer",
      heroTag: "add_new_customer",
      onPressed: () {
        customCupertinoPopUp(
          context,
          title: "Add New Customer".tr(),
          content: CustomerForm(
            formKey: formKey,
            nameController: nameController,
            phoneController: phoneController,
            addressController: addressController,
          ),

          buttonText: "Add".tr(),
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            if (phoneController.text.startsWith('0')) {
              phoneController.text = phoneController.text.substring(1);
            }
            context.read<CustomerCubit>().addCustomer(
              customer: CustomerDto(
                name: nameController.text,
                phone: "+20${phoneController.text}",
                address: addressController.text,
                numberOfBooks: 0,
              ),
            );
            nameController.clear();
            phoneController.clear();
            addressController.text = "Engaz";

            Navigator.pop(context);
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final GlobalKey<FormState> formKey;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController(text: "Engaz");
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
