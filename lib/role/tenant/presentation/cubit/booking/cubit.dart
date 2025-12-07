import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rentverse/features/bookings/domain/entity/req/request_booking_entity.dart';
import 'package:rentverse/features/bookings/domain/usecase/create_booking_usecase.dart';
import 'package:rentverse/features/rental/domain/usecase/get_rent_references_usecase.dart';
import 'package:rentverse/role/tenant/presentation/cubit/booking/state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._createBookingUseCase, this._getRentReferencesUseCase)
    : super(BookingState.initial());

  final CreateBookingUseCase _createBookingUseCase;
  final GetRentReferencesUseCase _getRentReferencesUseCase;

  Future<void> loadBillingPeriods() async {
    emit(state.copyWith(isBillingPeriodsLoading: true, resetError: true));
    try {
      final refs = await _getRentReferencesUseCase();
      final periods = refs.billingPeriods;
      final hasPeriods = periods.isNotEmpty;
      final firstId = hasPeriods ? periods.first.id : 0;
      final hasExistingSelection = periods.any(
        (period) => period.id == state.billingPeriodId,
      );
      final selectedId = hasExistingSelection
          ? state.billingPeriodId
          : (hasPeriods ? firstId : state.billingPeriodId);

      Logger().i(
        'Billing periods loaded (${periods.length}): ${periods.map((p) => '${p.id}-${p.label}-${p.durationMonths}').join(', ')} | selectedId=$selectedId',
      );

      emit(
        state.copyWith(
          isBillingPeriodsLoading: false,
          billingPeriods: periods,
          billingPeriodId: selectedId,
        ),
      );
    } catch (e) {
      Logger().e('Failed to load billing periods', error: e);
      emit(state.copyWith(isBillingPeriodsLoading: false, error: e.toString()));
    }
  }

  void setBillingPeriod(int id) {
    emit(
      state.copyWith(billingPeriodId: id, resetError: true, resetResult: true),
    );
  }

  void setStartDate(DateTime date) {
    emit(state.copyWith(startDate: date, resetError: true, resetResult: true));
  }

  Future<void> submit(String propertyId) async {
    if (state.billingPeriods.isEmpty) {
      emit(
        state.copyWith(
          error: 'Billing period belum tersedia',
          resetResult: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, resetError: true, resetResult: true));
    try {
      final res = await _createBookingUseCase(
        param: RequestBookingEntity(
          propertyId: propertyId,
          billingPeriodId: state.billingPeriodId,
          startDate: state.startDate,
        ),
      );
      emit(state.copyWith(isLoading: false, result: res));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
