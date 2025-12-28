import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:rentverse/core/utils/error_utils.dart';
import 'package:rentverse/features/bookings/domain/usecase/get_bookings_usecase.dart';
import 'package:rentverse/features/bookings/domain/usecase/confirm_booking_usecase.dart';
import 'package:rentverse/features/bookings/domain/usecase/reject_booking_usecase.dart';
import 'package:rentverse/features/landlord_dashboard/presentation/cubit/booking_request/state.dart';

class LandlordBookingRequestCubit extends Cubit<LandlordBookingRequestState> {
  LandlordBookingRequestCubit(
    this._getBookingsUseCase,
    this._confirmBookingUseCase,
    this._rejectBookingUseCase,
  ) : super(const LandlordBookingRequestState());

  final GetBookingsUseCase _getBookingsUseCase;
  final ConfirmBookingUseCase _confirmBookingUseCase;
  final RejectBookingUseCase _rejectBookingUseCase;

  Future<void> load({int limit = 20, String? cursor}) async {
    emit(
      state.copyWith(status: LandlordBookingRequestStatus.loading, error: null),
    );
    try {
      final res = await _getBookingsUseCase(
        param: GetBookingsParams(limit: limit, cursor: cursor),
      );
      final requests = res.items
          .where(
            (item) =>
                item.status == 'PENDING' || item.status == 'PENDING_PAYMENT',
          )
          .toList();
      final pendingPayments = res.items
          .where(
            (item) =>
                item.status == 'PENDING_PAYMENT' ||
                item.payment.status == 'PENDING',
          )
          .toList();
      final paidPayments =
          res.items.where((item) => item.payment.status == 'PAID').toList();
      final confirmed =
          res.items.where((item) => item.status == 'CONFIRMED').toList();
      final rejected =
          res.items.where((item) => item.status == 'REJECTED').toList();

      emit(
        state.copyWith(
          status: LandlordBookingRequestStatus.success,
          requests: requests,
          pendingPayments: pendingPayments,
          paidPayments: paidPayments,
          confirmed: confirmed,
          rejected: rejected,
        ),
      );
    } catch (e) {
      Logger().e('Load booking requests failed', error: e);
      final msg = e is DioException ? resolveApiErrorMessage(e) : e.toString();
      emit(
        state.copyWith(
          status: LandlordBookingRequestStatus.failure,
          error: msg,
        ),
      );
    }
  }

  Future<void> confirmBooking(String bookingId) async {
    emit(
      state.copyWith(
        isActionLoading: true,
        actionBookingId: bookingId,
        error: null,
      ),
    );
    try {
      await _confirmBookingUseCase(param: bookingId);
      await load();
    } catch (e) {
      Logger().e('Confirm booking failed', error: e);
      final msg = e is DioException ? resolveApiErrorMessage(e) : e.toString();
      emit(
        state.copyWith(
          isActionLoading: false,
          actionBookingId: null,
          error: msg,
        ),
      );
    }
    emit(state.copyWith(isActionLoading: false, actionBookingId: null));
  }

  Future<void> rejectBooking(String bookingId) async {
    emit(
      state.copyWith(
        isActionLoading: true,
        actionBookingId: bookingId,
        error: null,
      ),
    );
    try {
      await _rejectBookingUseCase(param: bookingId);
      await load();
    } catch (e) {
      Logger().e('Reject booking failed', error: e);
      final msg = e is DioException ? resolveApiErrorMessage(e) : e.toString();
      emit(
        state.copyWith(
          isActionLoading: false,
          actionBookingId: null,
          error: msg,
        ),
      );
      return;
    }
    emit(state.copyWith(isActionLoading: false, actionBookingId: null));
  }
}
