import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/role/tenant/presentation/cubit/receipt_booking/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/receipt_booking/state.dart';
import 'package:rentverse/role/tenant/presentation/pages/rent/midtrans_payment_page.dart';
import 'package:rentverse/role/tenant/presentation/widget/receipt_booking/property_rent_details.dart';
import 'package:rentverse/role/tenant/presentation/widget/receipt_booking/nav_bar_receipt.dart';

class ReceiptBookingPage extends StatelessWidget {
  const ReceiptBookingPage({super.key, required this.response});

  final BookingResponseEntity response;

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade600;
    return BlocProvider(
      create: (_) => ReceiptBookingCubit(sl(), response),
      child: Scaffold(
        appBar: AppBar(title: const Text('Receipt Booking'), centerTitle: true),
        body: BlocConsumer<ReceiptBookingCubit, ReceiptBookingState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context).showSnackBar(SnackBar(content: Text(state.error!)));
            }
            if (state.payment != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MidtransPaymentPage(
                    booking: state.response,
                    redirectUrl: state.payment!.redirectUrl,
                    snapToken: state.payment!.token,
                    clientKey: state.payment!.clientKey)));
            }
          },
          builder: (context, state) {
            final res = state.response;
            final billingPeriodLabel = res.billingPeriod?.label ?? 'Monthly';
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(
                      title: 'Summary',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Row(label: 'Booking ID', value: res.bookingId),
                          _Row(label: 'Invoice ID', value: res.invoiceId),
                          _Row(label: 'Status', value: res.status),
                          _Row.highlight(
                            label: 'Total',
                            value: '${res.amount} ${res.currency}'),
                          if (res.message != null && res.message!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                res.message!,
                                style: TextStyle(color: muted)))])),
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: 'Schedule',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Row(label: 'Check In', value: _fmtDate(res.checkIn)),
                          _Row(
                            label: 'Check Out',
                            value: _fmtDate(res.checkOut)),
                          _Row(
                            label: 'Payment Deadline',
                            value: _fmtDate(res.paymentDeadline)),
                          const SizedBox(height: 8),
                          _Row(
                            label: 'Billing Period',
                            value: billingPeriodLabel)])),
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: 'Property & Rent Details',
                      child: PropertyRentDetailsCard(
                        location: res.property?.address ?? '-',
                        startDate: _fmtDate(res.checkIn),
                        billingPeriod: billingPeriodLabel,
                        propertyType: res.property?.title ?? '-',
                        priceLabel: _formatCurrency(res.amount, res.currency))),
                    if (state.payment != null) ...[
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: 'Payment Token',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Row(label: 'Token', value: state.payment!.token),
                            _Row(
                              label: 'Redirect URL',
                              value: state.payment!.redirectUrl),
                            _Row(
                              label: 'Client Key',
                              value: state.payment!.clientKey)]))],
                    const SizedBox(height: 80)])));
          }),
        bottomNavigationBar:
            BlocBuilder<ReceiptBookingCubit, ReceiptBookingState>(
              builder: (context, state) {
                final res = state.response;
                final amountLabel = _formatCurrency(res.amount, res.currency);
                return NavBarReceipt(amountLabel: amountLabel);
              })));
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  factory _Row.highlight({required String label, required String value}) {
    return _Row(label: label, value: value, emphasize: true);
  }

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
        : const TextStyle();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text(value, style: style))]));
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          child]));
  }
}

String _fmtDate(DateTime? date) {
  if (date == null) return '-';
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _formatCurrency(int amount, String currency) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: currency.isEmpty ? 'Rp ' : '$currency ',
    decimalDigits: 0);
  return formatter.format(amount);
}
