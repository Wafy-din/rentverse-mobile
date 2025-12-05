import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/core/resources/data_state.dart';
import 'package:rentverse/features/auth/domain/entity/login_request_entity.dart';
import 'package:rentverse/features/auth/domain/usecase/login_usecase.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  // Inject UseCase Asli
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> submitLogin(String email, String password) async {
    // 1. Emit Loading
    emit(state.copyWith(status: LoginStatus.loading));

    // 2. Panggil UseCase (Logic Bisnis)
    final result = await _loginUseCase(
      param: LoginRequestEntity(email: email, password: password),
    );

    // 3. Cek Hasil (Success / Failed)
    if (result is DataSuccess) {
      emit(state.copyWith(status: LoginStatus.success));
    } else if (result is DataFailed) {
      // Ambil pesan error dari DioException atau default
      final statusCode = result.error?.response?.statusCode;
      final errorMsg = statusCode == 401
          ? 'Email / password salah atau belum terdaftar'
          : (result.error?.message ??
                result.error?.response?.statusMessage ??
                'Login Failed');

      emit(state.copyWith(status: LoginStatus.failure, errorMessage: errorMsg));
    }
  }
}
