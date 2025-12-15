class BookingAvailabilityEntity {
  final DateTime start;
  final DateTime end;
  final String? reason;

  BookingAvailabilityEntity({
    required this.start,
    required this.end,
    this.reason,
  });
}
