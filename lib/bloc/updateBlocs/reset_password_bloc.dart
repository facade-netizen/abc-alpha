import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AccountApiRepository _accountApiRepository;
  ResetPasswordBloc(this._accountApiRepository) : super(ResetPasswordInitial()) {
    on<ResetPassword>((event, emit) async {
      emit(ResetPasswordProgress());
      debugPrint(" Called ResetPasswordBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _accountApiRepository.resetPassword(body: event.resetPassword);
          final responseData = response.body;
          final status = responseData["status"];
          final data = responseData["data"];
          if (status == 200) {
            emit(ResetPasswordSuccess());
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            if (kDebugMode) debugPrint("Request failure >> $errorMsg");
            emit(ResetPasswordFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("ResetPasswordBloc [Catch Exception] >>error: $e");
          emit(ResetPasswordFailure(e));
        }
      } else {
        emit(ResetPasswordFailure("User not in"));
      }
    });
  }
}

//states
abstract class ResetPasswordState {}

//events
abstract class ResetPasswordEvent {}

//states implementation
class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordProgress extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final dynamic error;
  ResetPasswordFailure(this.error);
}

//events implementation
class ResetPassword extends ResetPasswordEvent {
  ResetPassword({required this.resetPassword});
  final Map<String, dynamic> resetPassword;
}
