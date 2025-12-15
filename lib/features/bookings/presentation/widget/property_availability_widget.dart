import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/bookings/domain/usecase/get_property_availability_usecase.dart';
import 'package:logger/logger.dart';

class PropertyAvailabilityWidget extends StatefulWidget {
  final String propertyId;
  const PropertyAvailabilityWidget({super.key, required this.propertyId});

  @override
  State<PropertyAvailabilityWidget> createState() =>
      _PropertyAvailabilityWidgetState();
}

class _PropertyAvailabilityWidgetState
    extends State<PropertyAvailabilityWidget> {
  bool _loading = false;
  List<Map<String, DateTime>> _ranges = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final usecase = sl<GetPropertyAvailabilityUseCase>();
      final logger = Logger();
      final res = await usecase(param: widget.propertyId);

      logger.i(
        'Loaded ${res.length} availability ranges for property ${widget.propertyId}',
      );

      setState(() {
        _ranges = res.map((e) => {'start': e.start, 'end': e.end}).toList();
      });
    } catch (e, st) {
      Logger().e(
        'Failed to load availability for ${widget.propertyId}: $e\n$st',
      );
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd MMM yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Unavailable Dates',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (_loading) const Center(child: CircularProgressIndicator()),
        if (_error != null)
          Text(
            'Failed to load availability: $_error',
            style: const TextStyle(color: Colors.red),
          ),
        if (!_loading && _ranges.isEmpty && _error == null)
          const Text(
            'Properti tersedia sepenuhnya',
            style: TextStyle(color: Colors.grey),
          ),
        for (final r in _ranges) ...[
          Text(
            '${f.format(r['start']!)} — ${f.format(r['end']!)}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}
