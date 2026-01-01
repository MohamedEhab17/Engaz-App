import 'package:engaz_app/features/customers/data/firebase/customer_firebase.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/data/repo/data_source/customer_data_source_contract.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';

class CustomerDataSourceImpl implements CustomerDataSourceContract {
  CustomerDataSourceImpl(this._customerFirebase);
  final CustomerFirebase _customerFirebase;

  @override
  Future<void> addCustomer(CustomerDto customer) async =>
      await _customerFirebase.addCustomer(customer);

  @override
  Stream<List<CustomerDto>> getAllCustomers() =>
      _customerFirebase.getAllCustomers();

  @override
  Future<bool> isCustomerExists(String phone) async =>
      await _customerFirebase.isCustomerExists(phone);

  @override
  Future<void> addBookToCustomer(String customerId, BookDto book) async =>
      await _customerFirebase.addBookToCustomer(customerId, book);

  @override
  Stream<List<BookDto>> streamBooksByGradeAndSubject({
    required String gradeId,
    required String subject,
  }) => _customerFirebase.streamBooksByGradeAndSubject(
    gradeId: gradeId,
    subject: subject,
  );
  @override
  Stream<List<BookDto>> getCustomerBooks(String customerId) =>
      _customerFirebase.getCustomerBooks(customerId: customerId);

  @override
  Future<bool> isCustomerBookExists(String customerId, String bookId) async =>
      await _customerFirebase.isCustomerBookExists(customerId, bookId);

  @override
  Future<void> removeBookFromCustomer(String customerId, BookDto book) async =>
      await _customerFirebase.removeBookFromCustomer(customerId, book);

  @override
  Future<void> updateBookInCustomer(String customerId, BookDto book) async =>
      await _customerFirebase.updateBookInCustomer(customerId, book);

  @override
  Future<void> deleteCustomer(String phone) async =>
      await _customerFirebase.deleteCustomer(phone);

  @override
  Future<void> updateCustomer(CustomerDto customer) async =>
      await _customerFirebase.updateCustomer(customer);

  @override
  Future<void> syncReservationForBook(String bookId) async =>
      await _customerFirebase.syncReservationForBook(bookId);

  @override
  Future<void> deleteReservationForBook(String bookId) async =>
      await _customerFirebase.deleteReservationRowByBookId(bookId);

  @override
  Future<void> finalizeReservation(String bookId) async =>
      await _customerFirebase.finalizeReservation(bookId);

  @override
  Stream<List<Map<String, dynamic>>> getAllReservationRows() =>
      _customerFirebase.getAllReservationRows();
      
        @override
        Future<void> addBookToCart({required String customerId, required String bookId}) async =>
            await _customerFirebase.addBookToCart(customerId: customerId, bookId: bookId);
}

CustomerDataSourceContract injectableCustomerDataSource =
    CustomerDataSourceImpl(CustomerFirebase.instance);
