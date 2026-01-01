import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_state.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomersList extends StatelessWidget {
  const CustomersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        final bool isLoading = state is GetCustomersLoading;
        final List<CustomerDto> customers = context
            .read<CustomerCubit>()
            .customersList;

        return Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            itemCount: isLoading ? 10 : customers.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) {
              final customer = isLoading
                  ? CustomerDto(name: "Loading...", phone: "0000")
                  : customers[index];

              return CustomerItem(customer: customer);
            },
            separatorBuilder: (_, __) => 16.height,
          ),
        );
      },
    );
  }
}
