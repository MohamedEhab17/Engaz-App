import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/features/customers/data/repo/data_source/customer_data_source_contract.dart';
import 'package:engaz_app/features/customers/data/repo/data_source/customer_data_source_impl.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_contract.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';

class CustomerRepositoryImpl implements CustomerRepositoryContract {
  CustomerRepositoryImpl(this._customerDataSource);
  final CustomerDataSourceContract _customerDataSource;

  @override
  Future<bool> addCustomer(CustomerDto customer) async {
    // Check for duplicate before adding
    // Note: There's a small race condition window between check and insert,
    // but Firestore document IDs (phone) provide natural uniqueness.
    // For production, consider using Firestore transactions or server-side validation.
    if (await _customerDataSource.isCustomerExists(customer.phone.toString())) {
      return false;
    }
    await _customerDataSource.addCustomer(customer);
    return true;
  }

  @override
  Stream<List<CustomerDto>> getAllCustomers() =>
      _customerDataSource.getAllCustomers();

  @override
  Future<bool> isCustomerExists(String phone) async =>
      await _customerDataSource.isCustomerExists(phone);

  @override
  Future<bool> addBookToCustomer(String customerId, BookDto book) async {
    if (await _customerDataSource.isCustomerBookExists(
      customerId,
      book.id.toString(),
    )) {
      return false;
    }
    await _customerDataSource.addBookToCustomer(customerId, book);
    return true;
  }

  @override
  Stream<List<BookDto>> streamBooksByGradeAndSubject({
    required String gradeId,
    required String subject,
  }) => _customerDataSource.streamBooksByGradeAndSubject(
    gradeId: gradeId,
    subject: subject,
  );
  @override
  Stream<List<BookDto>> getCustomerBooks(String customerId) =>
      _customerDataSource.getCustomerBooks(customerId);

  @override
  Future<bool> isCustomerBookExists(String customerId, String bookId) async =>
      await _customerDataSource.isCustomerBookExists(customerId, bookId);

  @override
  Future<void> removeBookFromCustomer(String customerId, BookDto book) async =>
      await _customerDataSource.removeBookFromCustomer(customerId, book);

  @override
  Future<void> updateBookInCustomer(String customerId, BookDto book) async =>
      await _customerDataSource.updateBookInCustomer(customerId, book);

  @override
  Future<void> deleteCustomer(String phone) async =>
      await _customerDataSource.deleteCustomer(phone);

  @override
  Future<void> updateCustomer(CustomerDto customer) async {
    // Validate customer exists before update
    // Note: Firestore update() will throw if document doesn't exist,
    // but explicit check provides better error handling
    if (!await _customerDataSource.isCustomerExists(customer.phone.toString())) {
      throw Exception('Customer not found');
    }
    await _customerDataSource.updateCustomer(customer);
  }

  @override
  Future<void> syncReservationForBook(String bookId) async =>
      await _customerDataSource.syncReservationForBook(bookId);

  @override
  Future<void> deleteReservationForBook(String bookId) async =>
      await _customerDataSource.deleteReservationForBook(bookId);

  @override
  Future<void> finalizeReservation(String bookId) async =>
      await _customerDataSource.finalizeReservation(bookId);

  @override
  Stream<List<Map<String, dynamic>>> getAllReservationRows() =>
      _customerDataSource.getAllReservationRows();
      
        @override
        Future<void> addBookToCart({required String customerId, required String bookId}) async =>
            await _customerDataSource.addBookToCart(customerId: customerId, bookId: bookId);
}

CustomerRepositoryContract injectableCustomerRepository() =>
    CustomerRepositoryImpl(injectableCustomerDataSource);
