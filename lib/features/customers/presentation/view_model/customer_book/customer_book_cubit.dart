import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_contract.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
part 'customer_book_state.dart';

class CustomerBookCubit extends Cubit<CustomerBookState> {
  final CustomerRepositoryContract _repository;
  StreamSubscription<List<BookDto>>? _booksSubscription;
  List<BookDto> booksList = [];

  CustomerBookCubit(this._repository) : super(CustomerBookInitial());

  //! LISTEN TO CUSTOMER BOOKS
  void getCustomerBooks(String customerId) {
    emit(CustomerBookLoading());

    _booksSubscription?.cancel();

    _booksSubscription = _repository
        .getCustomerBooks(customerId)
        .listen(
          (books) {
            booksList = List.from(books);
            emit(CustomerBookLoaded(booksList));
          },
          onError: (e) {
            emit(CustomerBookError("Failed to load books".tr()));
          },
        );
  }

  //! ADD BOOK
  Future<void> addBook(String customerId, BookDto book) async {
    try {
      final result = await _repository.addBookToCustomer(customerId, book);

      if (!result) {
        emit(CustomerBookError("Book already exists".tr()));
        emit(CustomerBookLoaded(booksList));
        return;
      }

      // Sync reservation after adding book
      if (book.id != null && book.id!.isNotEmpty) {
        await _repository.syncReservationForBook(book.id!);
      }

      // Optimistic update: Add the new book to the list
      final updatedBooks = [...booksList];
      booksList = updatedBooks;
      emit(CustomerBookAdded());
      emit(CustomerBookLoaded(updatedBooks));
    } catch (e) {
      if (e.toString().contains("unavailable") ||
          e.toString().contains("SocketException") ||
          e.toString().contains("network")) {
        emit(CustomerBookError("Internet failure, check your internet".tr()));
      } else {
        emit(CustomerBookError("Failed to add book to customer".tr()));
      }
    }
  }
  //! Add Book to Cart
  Future<void> addBookToCart(String customerId, String bookId) async {
    try {
      await  _repository.addBookToCart(
        customerId: customerId,
        bookId: bookId,
      );
    } catch (e) {
      if (e.toString().contains("unavailable") ||
          e.toString().contains("SocketException") ||
          e.toString().contains("network")) {
        emit(CustomerBookError("Internet failure, check your internet".tr()));
      } else {
        emit(CustomerBookError("Failed to add book to cart".tr()));
      }
    }
  }

  //! REMOVE BOOK

  Future<void> removeBook(String customerId, BookDto book) async {
    try {
      await _repository.removeBookFromCustomer(customerId, book);

      // Sync reservation after removing book (will delete if no more books)
      if (book.id != null && book.id!.isNotEmpty) {
        await _repository.syncReservationForBook(book.id!);
      }

      // Optimistic update: Remove the book from the list
      final updatedBooks = booksList.where((b) => b.id != book.id).toList();
      booksList = updatedBooks;
      emit(CustomerBookLoaded(updatedBooks));
    } catch (e) {
      if (e.toString().contains("unavailable") ||
          e.toString().contains("SocketException") ||
          e.toString().contains("network")) {
        emit(CustomerBookError("Internet failure, check your internet".tr()));
      } else {
        emit(CustomerBookError("Failed to remove book from customer".tr()));
      }
    }
  }

  Future<void> updateBook(String customerId, BookDto book) async {
    try {
      await _repository.updateBookInCustomer(customerId, book);

      // Sync reservation after updating book
      if (book.id != null && book.id!.isNotEmpty) {
        await _repository.syncReservationForBook(book.id!);
      }

      // Optimistic update: Update the book in the list
      final updatedBooks = booksList.map((b) {
        if (b.id == book.id) {
          return book;
        }
        return b;
      }).toList();
      booksList = updatedBooks;
      emit(CustomerBookLoaded(updatedBooks));
    } catch (e) {
      if (e.toString().contains("unavailable") ||
          e.toString().contains("SocketException") ||
          e.toString().contains("network")) {
        emit(CustomerBookError("Internet failure, check your internet".tr()));
      } else {
        emit(CustomerBookError("Failed to update book in customer".tr()));
      }
    }
  }

  @override
  Future<void> close() {
    _booksSubscription?.cancel();
    return super.close();
  }
}
