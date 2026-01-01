import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';

abstract class BookDataSourceContract {
  Future<List<BookDto>> getBooks(GradeDto gradeModel);
  Future<void> addBook(GradeDto gradeModel, BookDto bookModel);
  Future<void> updateBook(GradeDto gradeModel, BookDto bookModel);
  Future<void> deleteBook(GradeDto gradeModel, String bookId);
}