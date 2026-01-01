import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/widgets/toast.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_state.dart';
import 'package:engaz_app/features/customers/presentation/widgets/add_customer_fab.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_search_bar.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customers_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({super.key});
  static const routeName = '/customers';

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerAddSuccess) {
          Toast.success(context, "customer added successfully".tr());
        }
        if (state is CustomerAddFailure) {
          Toast.error(context, state.message);
        }
        if (state is CustomerUpdateSuccess) {
          Toast.success(context, "customer updated successfully".tr());
        }
        if (state is CustomerUpdateFailure) {
          Toast.error(context, state.message);
        }
        if (state is CustomerDeleteSuccess) {
          Toast.success(context, "customer deleted successfully".tr());
        }
        if (state is CustomerDeleteFailure) {
          Toast.error(context, state.message);
        }
        if (state is GetCustomersFailure) {
          Toast.error(context, state.message);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: 16.vhPadding,
          child: Column(
            children: [
              CustomerSearchBar(),
              16.height,
              const Expanded(child: CustomersList()),
            ],
          ),
        ),
        floatingActionButton: AddCustomerFab(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
