import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';

abstract class CustomerDataSourceContract {
  Future<bool> isCustomerExists(String phone);
  Future<void> addCustomer(CustomerDto customer);
  Future<void> updateCustomer(CustomerDto customer);
  Future<void> deleteCustomer(String phone);
  Stream<List<CustomerDto>> getAllCustomers();

  Future<bool> isCustomerBookExists(String customerId, String bookId);
  Future<void> addBookToCustomer(String customerId, BookDto book);
  Future<void> removeBookFromCustomer(String customerId, BookDto book);
  Future<void> updateBookInCustomer(String customerId, BookDto book);
  Future<void> addBookToCart({
    required String customerId,
    required String bookId,
  });

  Stream<List<BookDto>> streamBooksByGradeAndSubject({
    required String gradeId,
    required String subject,
  });
  Stream<List<BookDto>> getCustomerBooks(String customerId);

  // Reservation methods
  Future<void> syncReservationForBook(String bookId);
  Future<void> deleteReservationForBook(String bookId);
  Future<void> finalizeReservation(String bookId);
  Stream<List<Map<String, dynamic>>> getAllReservationRows();
}
