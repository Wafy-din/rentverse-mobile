import 'package:rentverse/core/usecase/usecase.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_availability_entity.dart';
import 'package:rentverse/features/bookings/domain/repository/bookings_repository.dart';

class GetPropertyAvailabilityUseCase
    implements UseCase<List<BookingAvailabilityEntity>, String> {
  GetPropertyAvailabilityUseCase(this._repository);

  final BookingsRepository _repository;

  @override
  Future<List<BookingAvailabilityEntity>> call({String? param}) {
    if (param == null || param.isEmpty) {
      throw ArgumentError('propertyId cannot be null or empty');
    }
    return _repository.getPropertyAvailability(param);
  }
}
