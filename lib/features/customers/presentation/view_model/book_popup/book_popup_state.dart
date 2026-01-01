part of 'book_popup_cubit.dart';

@immutable
sealed class BookPopupState {}

final class BookPopupInitial extends BookPopupState {}

final class BookPopupLoading extends BookPopupState {}

final class BookPopupLoaded extends BookPopupState {
  final List<BookDto> books;
  BookPopupLoaded(this.books);
}

final class BookPopupError extends BookPopupState {
  final String message;
  BookPopupError(this.message);
}
