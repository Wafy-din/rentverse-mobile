import 'package:rentverse/features/bookings/domain/entity/req/request_booking_entity.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_availability_entity.dart';

abstract class BookingsRepository {
  Future<BookingResponseEntity> createBooking(RequestBookingEntity request);
  Future<BookingListEntity> getBookings({int limit, String? cursor});
  Future<BookingResponseEntity> confirmBooking(String bookingId);
  Future<BookingResponseEntity> rejectBooking(String bookingId);
  Future<List<BookingAvailabilityEntity>> getPropertyAvailability(
    String propertyId,
  );
}
