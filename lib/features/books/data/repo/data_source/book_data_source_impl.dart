import 'package:engaz_app/features/books/data/firebase/book_firebase.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:engaz_app/features/books/data/repo/data_source/book_data_source_contract.dart';

class BookDataSourceImpl implements BookDataSourceContract {
  BookDataSourceImpl(this._bookFirebase);
  final BookFirebase _bookFirebase;

  @override
  Future<void> addBook(GradeDto gradeModel, BookDto bookModel) async =>
      await _bookFirebase.addBook(gradeModel, bookModel);

  @override
  Future<void> deleteBook(GradeDto gradeModel, String bookId)async =>
      await _bookFirebase.deleteBook(gradeModel, bookId);

  @override
  Future<List<BookDto>> getBooks(GradeDto gradeModel) async=>
     await _bookFirebase.getBooks(gradeModel);

  @override
  Future<void> updateBook(GradeDto gradeModel, BookDto bookModel) async=>
    await _bookFirebase.updateBook(gradeModel, bookModel);
}

BookDataSourceContract injectableBookDataSource = BookDataSourceImpl(
  BookFirebase.instance,
);
