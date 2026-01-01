import 'package:engaz_app/features/customers/data/model/customer_dto.dart';

sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class GetCustomersLoading extends CustomerState {}

final class GetCustomerSuccess extends CustomerState {
  final List<CustomerDto> customers;
  GetCustomerSuccess([this.customers = const []]);
}

final class GetCustomersFailure extends CustomerState {
  final String message;

  GetCustomersFailure(this.message);
}

final class CustomerAddLoading extends CustomerState {}

final class CustomerAddSuccess extends CustomerState {}

final class CustomerAddFailure extends CustomerState {
  final String message;
  CustomerAddFailure(this.message);
}

final class CustomerUpdateLoading extends CustomerState {}

final class CustomerUpdateSuccess extends CustomerState {
  final CustomerDto ? customer;
  CustomerUpdateSuccess(this.customer);
}

final class CustomerUpdateFailure extends CustomerState {
  final String message;
  CustomerUpdateFailure(this.message);
}

final class CustomerDeleteLoading extends CustomerState {}

final class CustomerDeleteSuccess extends CustomerState {}

final class CustomerDeleteFailure extends CustomerState {
  final String message;
  CustomerDeleteFailure(this.message);
}
