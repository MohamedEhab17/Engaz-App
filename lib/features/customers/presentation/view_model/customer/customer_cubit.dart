import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_contract.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit(this._repository) : super(CustomerInitial());
  final CustomerRepositoryContract _repository;
  List<CustomerDto> customersList = [];
  StreamSubscription<List<CustomerDto>>? _customersSubscription;

  // ! fetch all customers
  void fetchCustomers() {
    emit(GetCustomersLoading());
    _customersSubscription?.cancel();
    _customersSubscription = _repository.getAllCustomers().listen(
      (customers) {
        customersList = List.from(customers);
        emit(GetCustomerSuccess(customersList));
      },
      onError: (error) {
        emit(GetCustomersFailure("Failed to load customers".tr()));
      },
    );
  }

  //! add customer
  Future<void> addCustomer({required CustomerDto customer}) async {
    emit(CustomerAddLoading());
    try {
      final result = await _repository.addCustomer(customer);

      if (!result) {
        emit(CustomerAddFailure("Customer already exists".tr()));
        return;
      }

      emit(CustomerAddSuccess());
    } catch (e) {
      emit(CustomerAddFailure("Failed to add customer".tr()));
    }
  }

  //! update customer
  Future<void> updateCustomer({required CustomerDto customer}) async {
    emit(CustomerUpdateLoading());
    try {
      await _repository.updateCustomer(customer);
      emit(CustomerUpdateSuccess(customer));
    } catch (e) {
      final errorMessage = e.toString().contains('not found')
          ? "Customer not found".tr()
          : "Failed to update customer".tr();
      emit(CustomerUpdateFailure(errorMessage));
    }
  }

  //! delete customer
  Future<void> deleteCustomer({required String phone}) async {
    if (kDebugMode) {
    log("Deleting customer with phone: $phone");
    }
    emit(CustomerDeleteLoading());
    try {
      await _repository.deleteCustomer(phone);
      emit(CustomerDeleteSuccess());
    } catch (e) {
      emit(CustomerDeleteFailure("Failed to delete customer".tr()));
    }
  }

  //! Search Customer
  void searchCustomer(String query) {
    if (query.isEmpty) {
      fetchCustomers();

      return;
    }
    final searched = customersList.where((customer) {
      final name = customer.name?.toLowerCase() ?? '';
      final phone = customer.phone?.toLowerCase() ?? '';
      final input = query.toLowerCase();
      return name.contains(input) || phone.contains(input);
    }).toList();
    customersList = searched;
    emit(GetCustomerSuccess(searched));
  }

  @override
  Future<void> close() {
    _customersSubscription?.cancel();
    return super.close();
  }
}
