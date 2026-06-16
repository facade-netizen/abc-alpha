import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/authRepo/auth_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class VerifyOTPBloc extends Bloc<VerifyOTPEvent, VerifyOTPState> {
  final AuthApiRepository _authApiRepository;
  VerifyOTPBloc(this._authApiRepository) : super(VerifyOTPInitial()) {
    on<VerifyOTP>((event, emit) async {
      emit(VerifyOTPProgress());
      debugPrint("Called VerifyOTPBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;

      if (savedData != null) {
        try {
          final response = await _authApiRepository.verifyOTP(event.otp);
          final responseData = response.body;
          final status = responseData["status"];
          final data = responseData["data"];
          if (status == 200) {
            emit(VerifyOTPSuccess());
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            if (kDebugMode) debugPrint("VerifyOTPBloc failure >> $errorMsg");
            emit(VerifyOTPFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("VerifyOTPBloc [Catch Exception] >> $e");
          emit(VerifyOTPFailure(e));
        }
      } else {
        emit(VerifyOTPFailure("User not logged in"));
      }
    });
  }
}

//states
abstract class VerifyOTPState {}

//events
abstract class VerifyOTPEvent {}

//states implementation
class VerifyOTPInitial extends VerifyOTPState {}

class VerifyOTPProgress extends VerifyOTPState {}

class VerifyOTPSuccess extends VerifyOTPState {}

class VerifyOTPFailure extends VerifyOTPState {
  final dynamic error;
  VerifyOTPFailure(this.error);
}

//events implementation
class VerifyOTP extends VerifyOTPEvent {
  VerifyOTP({required this.otp});
  final String otp;
}
