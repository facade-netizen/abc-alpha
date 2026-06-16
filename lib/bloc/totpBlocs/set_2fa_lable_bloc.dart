import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/authRepo/auth_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class SetTOTPLableBloc extends Bloc<SetTOTPLableEvent, SetTOTPLableState> {
  final AuthApiRepository _authApiRepository;
  SetTOTPLableBloc(this._authApiRepository) : super(SetTOTPLableInitial()) {
    on<SetTOTPLable>((event, emit) async {
      emit(SetTOTPLableProgress());
      debugPrint(" Called SetTOTPLableBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _authApiRepository.setTOTPLable(body: event.setTOTPLableMap);
          if (response.statusCode == 200) {
            // if (kDebugMode) debugPrint(response.bodyString);
            final data = response.body["data"];
            final qrCodeUri = data["qrCodeUri"];
            emit(SetTOTPLableSuccess(qrCodeUri: qrCodeUri));
          } else {
            if (kDebugMode) debugPrint("SetTOTPLableBloc None 200 [response error]>> ${response.statusCode}");
            emit(SetTOTPLableFailure('SetTOTPLableBloc  None 200 [response error]>> ${response.statusCode}'));
          }
        } catch (e) {
          debugPrint("SetTOTPLableBloc [Catch Exception] >>error: $e");
          emit(SetTOTPLableFailure(e));
        }
      } else {
        emit(SetTOTPLableFailure("User not in"));
      }
    });
  }
}

//states
abstract class SetTOTPLableState {}

//events
abstract class SetTOTPLableEvent {}

//states implementation
class SetTOTPLableInitial extends SetTOTPLableState {}

class SetTOTPLableProgress extends SetTOTPLableState {}

class SetTOTPLableSuccess extends SetTOTPLableState {
  SetTOTPLableSuccess({required this.qrCodeUri});

  final String qrCodeUri;
}

class SetTOTPLableFailure extends SetTOTPLableState {
  final dynamic error;
  SetTOTPLableFailure(this.error);
}

//events implementation
class SetTOTPLable extends SetTOTPLableEvent {
  SetTOTPLable({required this.setTOTPLableMap});
  final Map<String, dynamic> setTOTPLableMap;
}
