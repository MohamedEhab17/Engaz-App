import 'package:flutter/material.dart';
import 'package:engaz_app/core/widgets/text_form_field_helper.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';

class CustomerSearchBar extends StatefulWidget {
  const CustomerSearchBar({super.key});

  @override
  State<CustomerSearchBar> createState() => _CustomerSearchBarState();
}

class _CustomerSearchBarState extends State<CustomerSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextFormFieldHelper(
      isMobile: true,
      controller: searchController,
      action: TextInputAction.search,
      suffixWidget: Image.asset(
        AppIcons.iconsSearch,
        color: AppColor.darkPrimary,
      ),
      hint: "search by name or phone...".tr(),
      onChanged: (value) {
        context.read<CustomerCubit>().searchCustomer(value ?? "");
      },
    );
  }

  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
