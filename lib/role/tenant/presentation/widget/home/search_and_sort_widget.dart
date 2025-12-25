import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rentverse/role/tenant/presentation/cubit/property_types/property_types_cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/property_types/property_types_state.dart';
import 'package:rentverse/role/tenant/presentation/cubit/search_and_sort/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/search_and_sort/state.dart';
import 'package:rentverse/core/services/service_locator.dart';

class SearchAndSortWidget extends StatelessWidget {
  final void Function(String query, String category)? onChanged;

  const SearchAndSortWidget({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PropertyTypesCubit(sl())..fetch()),
        BlocProvider(create: (_) => SearchAndSortCubit()),
      ],
      child: BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
        builder: (context, typesState) {
          final categories = typesState.categories;
          return BlocBuilder<SearchAndSortCubit, SearchAndSortState>(
            builder: (context, state) {
              final cubit = context.read<SearchAndSortCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _SearchField(
                    initialValue: state.query,
                    onChanged: (q) {
                      cubit.updateQuery(q);
                      onChanged?.call(q, state.selectedType);
                    },
                  ),
                  const SizedBox(height: 12),
                  if (typesState.isLoading)
                    const SizedBox(
                      height: 32,
                      child: Center(
                        child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else if (typesState.error != null)
                    Text(
                      'Gagal memuat tipe properti',
                      style: const TextStyle(color: Colors.red),
                    ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final c in categories) ...[
                          _FilterChipItem(
                            label: c,
                            selected: state.selectedType == c,
                            onTap: () {
                              cubit.selectType(c);
                              onChanged?.call(state.query, c);
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: Colors.teal, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? null : Colors.white,
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF00C2FF), Color(0xFF00E0C3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
