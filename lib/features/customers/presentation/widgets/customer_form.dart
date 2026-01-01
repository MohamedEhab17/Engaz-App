import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/utils/validators.dart';
import 'package:engaz_app/core/widgets/text_form_field_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomerForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const CustomerForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer Name".tr()),
          TextFormFieldHelper(
            controller: nameController,
            hint: "Customer Name".tr(),
            onValidate: Validator.validateName,
          ),
          6.height,
          Text("Phone".tr()),
          TextFormFieldHelper(
            controller: phoneController,
            hint: "Phone Number".tr(),
            keyboardType: TextInputType.phone,
            prefix: Text(
              "+2 ",
              style: AppTextStyles.body14(context).copyWith(color: Colors.blue),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onValidate: Validator.validatePhoneNumber,
          ),
          6.height,
          Text("Address".tr()),
          TextFormFieldHelper(
            controller: addressController,
            hint: "Customer Address".tr(),
          ),
        ],
      ),
    );
  }
}
