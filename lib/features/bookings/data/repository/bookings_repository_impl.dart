import 'package:rentverse/features/bookings/data/models/request_booking_model.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';
import 'package:rentverse/features/bookings/data/source/booking_api_service.dart';
import 'package:rentverse/features/bookings/domain/entity/req/request_booking_entity.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/features/bookings/domain/repository/bookings_repository.dart';

import 'package:rentverse/features/bookings/domain/entity/res/booking_availability_entity.dart';
import 'package:logger/logger.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingApiService _apiService;

  BookingsRepositoryImpl(this._apiService);

  @override
  Future<BookingResponseEntity> createBooking(
    RequestBookingEntity request,
  ) async {
    final model = RequestBookingModel.fromEntity(request);
    final response = await _apiService.createBooking(model);
    return response.toEntity();
  }

  @override
  Future<BookingListEntity> getBookings({
    int limit = 10,
    String? cursor,
  }) async {
    final response = await _apiService.getBookings(
      limit: limit,
      cursor: cursor,
    );
    return response.toEntity();
  }

  @override
  Future<BookingResponseEntity> confirmBooking(String bookingId) async {
    final response = await _apiService.confirmBooking(bookingId);
    return response.toEntity();
  }

  @override
  Future<BookingResponseEntity> rejectBooking(String bookingId) async {
    final response = await _apiService.rejectBooking(bookingId);
    return response.toEntity();
  }

  @override
  Future<List<BookingAvailabilityEntity>> getPropertyAvailability(
    String propertyId,
  ) async {
    final logger = Logger();
    final list = await _apiService.getPropertyAvailability(propertyId);

    if (list.isEmpty) {
      logger.i('No availability ranges returned for property: $propertyId');
      return <BookingAvailabilityEntity>[];
    }

    final mapped = <BookingAvailabilityEntity>[];
    for (final m in list) {
      final rawStart = m.start.trim();
      final rawEnd = m.end.trim();

      if (rawStart.isEmpty || rawEnd.isEmpty) {
        logger.w(
          'Skipping availability with empty start/end for property $propertyId: start="$rawStart" end="$rawEnd" reason="${m.reason}"',
        );
        continue;
      }

      final start = DateTime.tryParse(rawStart);
      final end = DateTime.tryParse(rawEnd);

      if (start == null || end == null) {
        logger.w(
          'Skipping availability with unparsable dates for property $propertyId: start="$rawStart" end="$rawEnd"',
        );
        continue;
      }

      mapped.add(
        BookingAvailabilityEntity(start: start, end: end, reason: m.reason),
      );
    }

    logger.i(
      'Parsed ${mapped.length} availability ranges for property $propertyId (raw: ${list.length})',
    );
    return mapped;
  }
}
