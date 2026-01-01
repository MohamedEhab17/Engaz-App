import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_impl.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/customers/presentation/widgets/add_customer_book_button.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_books_list.dart';
import 'package:engaz_app/features/customers/presentation/widgets/customer_details_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDetailsView extends StatefulWidget {
  const CustomerDetailsView({super.key, required this.customerDto});
  final CustomerDto customerDto;
  @override
  State<CustomerDetailsView> createState() => _CustomerDetailsViewState();
}

class _CustomerDetailsViewState extends State<CustomerDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomerDetailsAppBarTitle(customerDto: widget.customerDto),
        actions: [
          AddCustomerBookButton(customer: widget.customerDto),
        ],
      ),
      body: BlocProvider(
        create: (context) => CustomerCubit(injectableCustomerRepository()),
        child: CustomerBooksList(customer: widget.customerDto),
      ),
    );
  }

  late final GlobalKey<FormState> formKey;
  late final TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();

    quantityController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
  }
}
