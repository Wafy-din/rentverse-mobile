import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:rentverse/core/utils/error_utils.dart';
import 'package:rentverse/features/property/domain/usecase/get_landlord_properties_usecase.dart';

import 'state.dart';

class LandlordPropertyCubit extends Cubit<LandlordPropertyState> {
  LandlordPropertyCubit(this._getLandlordPropertiesUseCase)
      : super(const LandlordPropertyState());

  final GetLandlordPropertiesUseCase _getLandlordPropertiesUseCase;

  Future<void> load({int? limit, String? cursor}) async {
    emit(state.copyWith(status: LandlordPropertyStatus.loading, error: null));
    try {
      final result = await _getLandlordPropertiesUseCase(
        limit: limit,
        cursor: cursor,
      );
      emit(
        state.copyWith(
          status: LandlordPropertyStatus.success,
          items: result.properties,
          error: null,
        ),
      );
    } catch (e) {
      final msg = e is DioException ? resolveApiErrorMessage(e) : e.toString();
      emit(
        state.copyWith(
          status: LandlordPropertyStatus.failure,
          error: msg,
        ),
      );
    }
  }
}
