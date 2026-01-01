part of 'customer_book_cubit.dart';

@immutable
sealed class CustomerBookState {}

final class CustomerBookInitial extends CustomerBookState {}

final class CustomerBookLoading extends CustomerBookState {}

final class CustomerBookLoaded extends CustomerBookState {
  final List<BookDto> books;
  CustomerBookLoaded(this.books);
}

final class CustomerBookAdding extends CustomerBookState {}

final class CustomerBookAdded extends CustomerBookState {}

final class CustomerBookError extends CustomerBookState {
  final String message;
  CustomerBookError(this.message);
}

// final class CustomerFetchingGradesAndSubjects extends CustomerBookState {
//   final List<BookDto> currentBooks;
//   CustomerFetchingGradesAndSubjects({this.currentBooks = const []});
// }

// final class CustomerFetchedGradesAndSubjects extends CustomerBookState {
//   final List<BookDto> books;
//   CustomerFetchedGradesAndSubjects(this.books);
// }

// final class CustomerFetchGradesAndSubjectsError extends CustomerBookState {
//   final String message;
//   CustomerFetchGradesAndSubjectsError(this.message);
// }
