class BookingAvailabilityModel {
  final String start;
  final String end;
  final String? reason;

  BookingAvailabilityModel({
    required this.start,
    required this.end,
    this.reason,
  });

  factory BookingAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return BookingAvailabilityModel(
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      reason: json['reason'] as String?,
    );
  }
}
