import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import '../../presentation/cubit/disputes_cubit.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/disputes/domain/usecase/create_dispute_usecase.dart';
import 'package:rentverse/features/disputes/domain/usecase/get_my_disputes_usecase.dart';

class CreateDisputePage extends StatefulWidget {
  final String bookingId;
  const CreateDisputePage({super.key, required this.bookingId});

  static Widget withProvider({required String bookingId}) {
    return BlocProvider(
      create: (_) =>
          DisputesCubit(sl<GetMyDisputesUseCase>(), sl<CreateDisputeUseCase>()),
      child: CreateDisputePage(bookingId: bookingId),
    );
  }

  @override
  State<CreateDisputePage> createState() => _CreateDisputePageState();
}

class _CreateDisputePageState extends State<CreateDisputePage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Dispute')),
      body: BlocConsumer<DisputesCubit, DisputesState>(
        listener: (context, state) {
          if (state.status == DisputesStatus.failure && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.status == DisputesStatus.success) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == DisputesStatus.loading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Report an Issue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Please provide details about the dispute.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _reasonCtrl,
                        validator: (v) => (v == null || v.trim().length < 5)
                            ? 'Min 5 chars'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: appSecondaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: appSecondaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: customLinearGradient,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: isLoading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    final reason = _reasonCtrl.text.trim();
                                    final desc =
                                        _descCtrl.text.trim().isEmpty
                                            ? null
                                            : _descCtrl.text.trim();

                                    await context.read<DisputesCubit>().create(
                                      widget.bookingId,
                                      reason,
                                      desc,
                                    );
                                  },
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Submit Dispute',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
