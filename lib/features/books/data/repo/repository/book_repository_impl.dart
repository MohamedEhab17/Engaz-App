import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:engaz_app/features/books/data/repo/data_source/book_data_source_contract.dart';
import 'package:engaz_app/features/books/data/repo/data_source/book_data_source_impl.dart';
import 'package:engaz_app/features/books/data/repo/repository/book_repository_contract.dart';

class BooksRepositoryImpl implements BookRepositoryContract {
  BooksRepositoryImpl(this._bookDataSourceContract);
  final BookDataSourceContract _bookDataSourceContract;

  @override
  Future<void> addBook(GradeDto gradeModel, BookDto bookModel) async =>
      await _bookDataSourceContract.addBook(gradeModel, bookModel);

  @override
  Future<void> deleteBook(GradeDto gradeModel, String bookId) async =>
      await _bookDataSourceContract.deleteBook(gradeModel, bookId);

  @override
  Future<List<BookDto>> getBooks(GradeDto gradeModel) async =>
      await _bookDataSourceContract.getBooks(gradeModel);

  @override
  Future<void> updateBook(GradeDto gradeModel, BookDto bookModel) async =>
      await _bookDataSourceContract.updateBook(gradeModel, bookModel);
}

BookRepositoryContract injectableBookRepository() =>
    BooksRepositoryImpl(injectableBookDataSource);
