import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_contract.dart';
import 'package:engaz_app/features/reservations/data/model/reservation_row_dto.dart';
import 'package:engaz_app/features/reservations/presentation/view_model/reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  ReservationsCubit(this._repository) : super(ReservationsInitial());
  final CustomerRepositoryContract _repository;
  StreamSubscription<List<Map<String, dynamic>>>? _reservationsSubscription;

  void fetchReservations() {
    emit(ReservationsLoading());
    _reservationsSubscription?.cancel();

    _reservationsSubscription = _repository.getAllReservationRows().listen(
      (reservationsData) {
        try {
          final reservations = reservationsData
              .map((data) => ReservationRowDto.fromJson(data))
              .toList();

          final readyReservations = reservations
              .where((r) => r.isReady == true)
              .toList();

          final notReadyReservations = reservations
              .where((r) => r.isReady != true)
              .toList();

          emit(
            ReservationsLoaded(
              reservations: reservations,
              readyReservations: readyReservations,
              notReadyReservations: notReadyReservations,
            ),
          );
        } catch (e) {
          emit(ReservationsError("Failed to load reservations".tr()));
        }
      },
      onError: (e) {
        emit(ReservationsError("Failed to load reservations".tr()));
      },
    );
  }

  Future<void> finalizeReservation(String bookId) async {
    if (isClosed) return;

    emit(ReservationFinalizing());
    try {
      await _repository.finalizeReservation(bookId);
      if (isClosed) return;

      emit(ReservationFinalized(bookId));
      // Refresh reservations
      fetchReservations();
    } catch (e) {
      if (isClosed) return;
      emit(ReservationFinalizeError("Failed to finalize reservation".tr()));
    }
  }

  Future<void> deleteReservation(String bookId) async {
    try {
      await _repository.deleteReservationForBook(bookId);
      // Refresh reservations
      fetchReservations();
    } catch (e) {
      emit(ReservationsError("Failed to delete reservation".tr()));
    }
  }

  @override
  Future<void> close() {
    _reservationsSubscription?.cancel();
    return super.close();
  }
}
