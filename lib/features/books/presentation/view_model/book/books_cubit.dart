import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:engaz_app/features/books/data/repo/repository/book_repository_contract.dart';
import 'package:engaz_app/features/books/presentation/view_model/book/books_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksCubit extends Cubit<CustomerState> {
  BooksCubit(this._repository) : super(BooksInitial());
  final BookRepositoryContract _repository;
  List<BookDto> _allBooks = [];
  List<BookDto> _filteredBooks = [];

  //! fetch all books
  Future<void> fetchBooks(GradeDto grade) async {
    emit(GetBooksLoading());
    try {
      _allBooks = await _repository.getBooks(grade);
      emit(GetBookSuccess(_allBooks));
    } catch (e) {
      emit(GetBooksFailure(e.toString()));
    }
  }

  //! filter books by grade
  List<BookDto> filterBooksByGrade(GradeDto grade) {
    _filteredBooks = _allBooks
        .where((book) => book.gradeId == grade.id)
        .toList();
    return _filteredBooks;
  }

  //! Search Books
  void searchBooks(GradeDto grade, String query) {
    emit(GetBooksLoading());
    if (query.isEmpty) {
      _filteredBooks = filterBooksByGrade(grade);
      emit(GetBookSuccess(_filteredBooks));
      return;
    }

    final searched = _allBooks.where((book) {
      final name = book.name!.toLowerCase();
      final subject = book.subject!.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input) || subject.contains(input);
    }).toList();

    emit(GetBookSuccess(searched));
  }

  //! add book
  Future<void> addBook(GradeDto grade, BookDto book) async {
    emit(BookAddLoading());
    try {
      await _repository.addBook(grade, book);
      await fetchBooks(grade); // refresh
      emit(BookAddSuccess());
      emit(GetBookSuccess(_allBooks));
    } catch (e) {
      emit(BookAddFailure("Failed to add book".tr()));
    }
  }

  //! update book
  Future<void> updateBook(GradeDto grade, BookDto book) async {
    emit(BookUpdateLoading());
    try {
      await _repository.updateBook(grade, book);
      await fetchBooks(grade); // refresh
      emit(BookUpdateSuccess());
      emit(GetBookSuccess(_allBooks));
    } catch (e) {
      emit(BookUpdateFailure("Failed to update book".tr()));
    }
  }

  //! delete book
  Future<void> deleteBook(GradeDto grade, String bookId) async {
    emit(BookDeleteLoading());
    try {
      await _repository.deleteBook(grade, bookId);
      await fetchBooks(grade); // refresh
      emit(BookDeleteSuccess());
      emit(GetBookSuccess(_allBooks));
    } catch (e) {
      emit(BookDeleteFailure("Failed to delete book".tr()));
    }
  }
}
