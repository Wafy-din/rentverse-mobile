import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/auth/presentation/widget/custom_text_field.dart';
import 'package:rentverse/features/property/domain/entity/list_property_entity.dart';
import 'package:rentverse/features/rental/domain/entity/rent_references_entity_response.dart';
import 'package:rentverse/role/tenant/presentation/cubit/booking/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/booking/state.dart';
import 'package:rentverse/role/tenant/presentation/cubit/get_user/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/get_user/state.dart';
import 'package:rentverse/role/tenant/presentation/pages/rent/receipt_booking.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BookingPropertyPage extends StatelessWidget {
  const BookingPropertyPage({super.key, required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              BookingCubit(sl(), sl())
                ..initBillingPeriods(property.allowedBillingPeriods)),
        BlocProvider(create: (_) => GetUserCubit(sl(), sl())..load())],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rental Agreement Form'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0),
        body: SafeArea(
          child: BlocConsumer<BookingCubit, BookingState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(
                  context).showSnackBar(SnackBar(content: Text(state.error!)));
              }
              if (state.result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.result!.message ?? 'Booking created')));
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReceiptBookingPage(response: state.result!)));
              }
            },
            builder: (context, state) {
              final cubit = context.read<BookingCubit>();
              final selectedPeriod = state.billingPeriods.firstWhere(
                (p) => p.id == state.billingPeriodId,
                orElse: () => state.billingPeriods.isNotEmpty
                    ? state.billingPeriods.first
                    : BillingPeriodEntity(
                        id: 0,
                        slug: '',
                        label: 'Durasi belum tersedia',
                        durationMonths: 0));

              final durationLabel = state.billingPeriods.isEmpty
                  ? 'Durasi belum tersedia'
                  : '${selectedPeriod.label} (${selectedPeriod.durationMonths} bln)';

              final priceLabel = _formatCurrency(property.price);
              final propertyTypeLabel = property.propertyType?.label ?? '-';

              return BlocBuilder<GetUserCubit, GetUserState>(
                builder: (context, userState) {
                  final tenantName = userState.user?.name ?? '-';
                  final tenantEmail = userState.user?.email ?? '-';
                  final tenantPhone = userState.user?.phone ?? '-';

                  final meta = property.metadata ?? {};
                  final ownerName =
                      property.landlord?.name?.trim().isNotEmpty == true
                      ? property.landlord!.name!
                      : (meta['landlordName'] ?? meta['ownerName'] ?? '-')
                            .toString();
                  final ownerEmail =
                      (meta['landlordEmail'] ?? meta['ownerEmail'] ?? '-')
                          .toString();
                  final ownerPhone =
                      (meta['landlordPhone'] ?? meta['ownerPhone'] ?? '-')
                          .toString();
                  final city = property.city.trim();
                  final country = property.country.trim();
                  final ownerAddress = [
                    city,
                    country].where((part) => part.isNotEmpty).join(', ');
                  final resolvedOwnerAddress = ownerAddress.isEmpty
                      ? '-'
                      : ownerAddress;

                  Logger().i(
                    'Booking autofill -> tenant: {name: $tenantName, email: $tenantEmail, phone: $tenantPhone}; owner: {name: $ownerName, email: $ownerEmail, phone: $ownerPhone, address: $resolvedOwnerAddress}');

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle('Tenant Details'),
                        const SizedBox(height: 8),
                        _LabeledField(
                          label: 'Fullname',
                          child: CustomTextField(
                            key: ValueKey('tenant-name-$tenantName'),
                            hintText: tenantName,
                            initialValue: tenantName,
                            prefixIcon: Icon(LucideIcons.user),
                            readOnly: true)),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Email',
                          child: CustomTextField(
                            key: ValueKey('tenant-email-$tenantEmail'),
                            hintText: tenantEmail,
                            initialValue: tenantEmail,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(LucideIcons.mail),
                            readOnly: true)),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Current Address',
                          child: CustomTextField(
                            hintText: '-',
                            initialValue: '-',
                            prefixIcon: Icon(LucideIcons.home),
                            readOnly: false)),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Phone Number',
                          child: CustomTextField(
                            key: ValueKey('tenant-phone-$tenantPhone'),
                            hintText: tenantPhone,
                            initialValue: tenantPhone,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(LucideIcons.phone),
                            readOnly: true)),

                        const SizedBox(height: 24),
                        _SectionTitle('Owner Details ( Auto-filled )'),
                        const SizedBox(height: 8),
                        _LabeledField(
                          label: 'Fullname',
                          child: CustomTextField(
                            key: ValueKey('owner-name-$ownerName'),
                            hintText: ownerName,
                            initialValue: ownerName,
                            prefixIcon: Icon(LucideIcons.user),
                            readOnly: true)),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Current Address',
                          child: CustomTextField(
                            key: ValueKey(
                              'owner-address-$resolvedOwnerAddress'),
                            hintText: resolvedOwnerAddress,
                            initialValue: resolvedOwnerAddress,
                            prefixIcon: Icon(LucideIcons.home),
                            readOnly: true)),

                        const SizedBox(height: 24),
                        _SectionTitle(
                          'Property & Rent Details ( Auto-filled )'),
                        const SizedBox(height: 8),
                        _LabeledField(
                          label: 'Property Address',
                          child: CustomTextField(
                            key: ValueKey(
                              'property-address-${property.address}'),
                            hintText: property.address.isEmpty
                                ? '-'
                                : property.address,
                            initialValue: property.address.isEmpty
                                ? '-'
                                : property.address,
                            prefixIcon: Icon(LucideIcons.mapPin),
                            readOnly: true)),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Start Rent Date',
                          child: CustomTextField(
                            hintText: _formatDate(state.startDate),
                            initialValue: _formatDate(state.startDate),
                            readOnly: true,
                            onTap: () async {
                              final now = DateTime.now();
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: state.startDate.isAfter(now)
                                    ? state.startDate
                                    : now,
                                firstDate: now,
                                lastDate: DateTime(now.year + 3));
                              if (picked != null) {
                                cubit.setStartDate(picked);
                              }
                            },
                            suffixIcon: Icon(LucideIcons.calendar))),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Duration',
                          child: CustomTextField(
                            key: ValueKey(
                              'duration-$durationLabel-${state.billingPeriodId}'),
                            hintText: durationLabel,
                            initialValue: durationLabel,
                            readOnly: true,
                            suffixIcon: Icon(LucideIcons.chevronDown),
                            onTap: () =>
                                _showBillingPeriodPicker(context, state, cubit))),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Monthly Rent Price',
                          child: CustomTextField(
                            key: ValueKey('property-price-$priceLabel'),
                            hintText: priceLabel,
                            initialValue: priceLabel,
                            readOnly: true,
                            prefixIcon: Icon(LucideIcons.creditCard))),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Property Type',
                          child: CustomTextField(
                            key: ValueKey('property-type-$propertyTypeLabel'),
                            hintText: propertyTypeLabel,
                            initialValue: propertyTypeLabel,
                            readOnly: true,
                            prefixIcon: Icon(LucideIcons.building))),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                state.isLoading ||
                                    state.isBillingPeriodsLoading ||
                                    state.billingPeriods.isEmpty
                                ? null
                                : () async {
                                    await cubit.submit(property.id);
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white)))
                                : const Text(
                                    'Kirim Booking',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)))),
                        const SizedBox(height: 12),
                        if (state.result != null)
                          _Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Booking Created',
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                Text('Booking ID: ${state.result!.bookingId}'),
                                Text('Invoice ID: ${state.result!.invoiceId}'),
                                Text('Status: ${state.result!.status}'),
                                Text('Amount: Rp${state.result!.amount}')]))]));
                });
            }))));
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String _formatCurrency(String rawPrice) {
    final value = int.tryParse(rawPrice) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0);
    return formatter.format(value);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700));
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        child]);
  }
}

Future<void> _showBillingPeriodPicker(
  BuildContext context,
  BookingState state,
  BookingCubit cubit) async {
  if (state.billingPeriods.isEmpty || state.isBillingPeriodsLoading) return;

  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Billing Period',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              ...state.billingPeriods.map(
                (p) => ListTile(
                  title: Text('${p.label} (${p.durationMonths} bln)'),
                  trailing: state.billingPeriodId == p.id
                      ? Icon(LucideIcons.check, color: Colors.teal)
                      : null,
                  onTap: () {
                    Logger().i(
                      'Billing period selected -> id=${p.id}, label=${p.label}, duration=${p.durationMonths}');
                    cubit.setBillingPeriod(p.id);
                    Navigator.of(ctx).pop();
                  }))])));
    });
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)),
      child: child);
  }
}
