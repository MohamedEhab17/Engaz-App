import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_contract.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:meta/meta.dart';

part 'book_popup_state.dart';

class BookPopupCubit extends Cubit<BookPopupState> {
  BookPopupCubit(this._repository) : super(BookPopupInitial());
  final CustomerRepositoryContract _repository;
  StreamSubscription<List<BookDto>>? _booksSubscription;

  void getBooksByGradeAndSubject({
    required String gradeId,
    required String subject,
  }) {
    emit(BookPopupLoading());
    _booksSubscription?.cancel();
    _booksSubscription = _repository
        .streamBooksByGradeAndSubject(gradeId: gradeId, subject: subject)
        .listen(
          (books) {
            emit(BookPopupLoaded(books));
          },
          onError: (e) {
            emit(BookPopupError("Failed to load books".tr()));
          },
        );
  }

  @override
  Future<void> close() {
    _booksSubscription?.cancel();
    return super.close();
  }
}
