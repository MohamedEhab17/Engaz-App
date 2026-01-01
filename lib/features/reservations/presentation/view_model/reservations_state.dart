import 'package:engaz_app/features/reservations/data/model/reservation_row_dto.dart';

sealed class ReservationsState {}

final class ReservationsInitial extends ReservationsState {}

final class ReservationsLoading extends ReservationsState {}

final class ReservationsLoaded extends ReservationsState {
  final List<ReservationRowDto> reservations;
  final List<ReservationRowDto> readyReservations;
  final List<ReservationRowDto> notReadyReservations;

  ReservationsLoaded({
    required this.reservations,
    required this.readyReservations,
    required this.notReadyReservations,
  });
}

final class ReservationsError extends ReservationsState {
  final String message;
  ReservationsError(this.message);
}

final class ReservationFinalizing extends ReservationsState {}

final class ReservationFinalized extends ReservationsState {
  final String bookId;
  ReservationFinalized(this.bookId);
}

final class ReservationFinalizeError extends ReservationsState {
  final String message;
  ReservationFinalizeError(this.message);
}

