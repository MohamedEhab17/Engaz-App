import 'package:engaz_app/shared/data/model/book_dto.dart';

sealed class CustomerState {}

final class BooksInitial extends CustomerState {}

final class GetBooksLoading extends CustomerState {}

final class GetBookSuccess extends CustomerState {
  final List<BookDto> books;
  GetBookSuccess([this.books = const []]);
}

final class GetBooksFailure extends CustomerState {
  final String message;

  GetBooksFailure(this.message);
}

final class BookAddLoading extends CustomerState {}

final class BookAddSuccess extends CustomerState {}

final class BookAddFailure extends CustomerState {
  final String message;
  BookAddFailure(this.message);
}

final class BookUpdateLoading extends CustomerState {}

final class BookUpdateSuccess extends CustomerState {}

final class BookUpdateFailure extends CustomerState {
  final String message;
  BookUpdateFailure(this.message);
}

final class BookDeleteLoading extends CustomerState {}

final class BookDeleteSuccess extends CustomerState {}

final class BookDeleteFailure extends CustomerState {
  final String message;
  BookDeleteFailure(this.message);
}
