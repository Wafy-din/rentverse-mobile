import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/wallet/domain/usecase/request_payout_usecase.dart';
import 'package:rentverse/features/wallet/presentation/cubit/payout_cubit.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RequestPayoutPage extends StatefulWidget {
  const RequestPayoutPage({super.key});

  static Widget withProvider() {
    return BlocProvider(
      create: (_) => PayoutCubit(sl<RequestPayoutUseCase>()),
      child: const RequestPayoutPage(),
    );
  }

  @override
  State<RequestPayoutPage> createState() => _RequestPayoutPageState();
}

class _RequestPayoutPageState extends State<RequestPayoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _accountNoCtrl = TextEditingController();
  final _accountNameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _bankCtrl.dispose();
    _accountNoCtrl.dispose();
    _accountNameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount required';
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Amount must be a number';
    if (parsed < 50000) return 'Minimum withdrawal is 50,000';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Request Payout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<PayoutCubit, PayoutState>(
        listener: (context, state) {
          if (state.status == PayoutStatus.failure && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.status == PayoutStatus.success) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final loading = state.status == PayoutStatus.loading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildFormCard(loading),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard(bool loading) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payout Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _amountCtrl,
              label: 'Amount',
              icon: LucideIcons.dollarSign,
              keyboardType: TextInputType.number,
              validator: _validateAmount,
              prefixText: 'Rp ',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _bankCtrl,
              label: 'Bank Name',
              icon: LucideIcons.wallet,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Bank name required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _accountNoCtrl,
              label: 'Account Number',
              icon: LucideIcons.hash,
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Account number required'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _accountNameCtrl,
              label: 'Account Name',
              icon: LucideIcons.user,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Account name required'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _notesCtrl,
              label: 'Notes (optional)',
              icon: LucideIcons.fileText,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(loading),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? prefixText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: appSecondaryColor),
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: appSecondaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool loading) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: customLinearGradient,
        borderRadius: BorderRadius.circular(16)
      ),
      child: ElevatedButton(
        onPressed: loading
            ? null
            : () {
                if (!_formKey.currentState!.validate()) return;
                final params = RequestPayoutParams(
                  amount: int.parse(_amountCtrl.text.trim()),
                  bankName: _bankCtrl.text.trim(),
                  accountNo: _accountNoCtrl.text.trim(),
                  accountName: _accountNameCtrl.text.trim(),
                  notes: _notesCtrl.text.trim().isEmpty
                      ? null
                      : _notesCtrl.text.trim(),
                );
                context.read<PayoutCubit>().submit(params);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Submit Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
