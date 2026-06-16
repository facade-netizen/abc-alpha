import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/authRepo/auth_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class Check2FAEnabledBloc extends Bloc<Check2FAEnabledEvent, Check2FAEnabledState> {
  final AuthApiRepository _authApiRepository;
  Check2FAEnabledBloc(this._authApiRepository) : super(Check2FAEnabledInitial()) {
    on<Check2FAEnabled>((event, emit) async {
      emit(Check2FAEnabledProgress());
      debugPrint("Called Check2FAEnabledBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;

      if (savedData != null) {
        try {
          final response = await _authApiRepository.check2FAEnabled();
          final responseData = response.body;
          final status = responseData["status"];
          final data = responseData["data"];
          if (status == 200) {
            emit(Check2FAEnabledSuccess(is2FAEnabled: data));
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            if (kDebugMode) debugPrint("Check2FAEnabledBloc failure >> $errorMsg");
            emit(Check2FAEnabledFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("Check2FAEnabledBloc [Catch Exception] >> $e");
          emit(Check2FAEnabledFailure(e));
        }
      } else {
        emit(Check2FAEnabledFailure("User not logged in"));
      }
    });
  }
}

//states
abstract class Check2FAEnabledState {}

//events
abstract class Check2FAEnabledEvent {}

//states implementation
class Check2FAEnabledInitial extends Check2FAEnabledState {}

class Check2FAEnabledProgress extends Check2FAEnabledState {}

class Check2FAEnabledSuccess extends Check2FAEnabledState {
  Check2FAEnabledSuccess({required this.is2FAEnabled});
  final bool is2FAEnabled;
}

class Check2FAEnabledFailure extends Check2FAEnabledState {
  final dynamic error;
  Check2FAEnabledFailure(this.error);
}

//events implementation
class Check2FAEnabled extends Check2FAEnabledEvent {}
