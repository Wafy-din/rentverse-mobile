import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import 'package:rentverse/features/property/domain/usecase/create_property_usecase.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/add_property_cubit.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/add_property_state.dart';
import 'package:rentverse/role/lanlord/presentation/pages/add_property_basic.dart';
import 'package:rentverse/role/lanlord/presentation/pages/pricing_and_amenity_property.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PartAddPropertyPage extends StatelessWidget {
  const PartAddPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddPropertyCubit(sl<CreatePropertyUseCase>()),
      child: const _PartAddPropertyView(),
    );
  }
}

class _PartAddPropertyView extends StatelessWidget {
  const _PartAddPropertyView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        if (state.status == AddPropertyStatus.failure && state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
        if (state.status == AddPropertyStatus.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Property submitted')));
          Navigator.of(context).maybePop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(LucideIcons.arrowLeft),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const Text('Add Property'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _StepCard(
                  title: 'Basic Property Information',
                  completed: state.basicCompleted,
                  onTap: () => _openBasic(context),
                ),
                const SizedBox(height: 12),
                _StepCard(
                  title: 'Pricing & Amenity Details',
                  completed: state.pricingCompleted,
                  onTap: () => _openPricing(context),
                ),
                const Spacer(),
                _SubmitButton(
                  enabled:
                      state.basicCompleted &&
                      state.pricingCompleted &&
                      state.status != AddPropertyStatus.loading,
                  loading: state.status == AddPropertyStatus.loading,
                  onPressed: () => context.read<AddPropertyCubit>().submit(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openBasic(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AddPropertyCubit>(),
          child: const AddPropertyBasicPage(),
        ),
      ),
    );
  }

  void _openPricing(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AddPropertyCubit>(),
          child: const PricingAndAmenityPropertyPage(),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.title,
    required this.completed,
    required this.onTap,
  });

  final String title;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: completed ? appPrimaryColor : const Color(0xFFE0E0E0),
          )
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8A8A8A),
                ),
              ),
            ),
            if (completed) Icon(LucideIcons.check, color: appPrimaryColor),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? appPrimaryColor : const Color(0xFFB8B8B8);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled && !loading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save & Send',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
