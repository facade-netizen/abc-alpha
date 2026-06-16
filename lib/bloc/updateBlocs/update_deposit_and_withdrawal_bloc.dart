import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateDepositAndWithdrawalRequestBloc extends Bloc<UpdateDepositAndWithdrawalRequestEvent, UpdateDepositAndWithdrawalRequestState> {
  final AccountApiRepository _accountApiRepository;
  UpdateDepositAndWithdrawalRequestBloc(this._accountApiRepository) : super(UpdateDepositAndWithdrawalRequestInitial()) {
    on<UpdateDepositAndWithdrawalRequest>((event, emit) async {
      emit(UpdateDepositAndWithdrawalRequestProgress());
      debugPrint("Called UpdateDepositAndWithdrawalRequestBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _accountApiRepository.updateDepositAndWithdrawalRequest(body: event.updateDepositAndWithdrawalRequestMap);
          final decoded = jsonDecode(response.bodyString);
          if (decoded['status'] == 200) {
            emit(UpdateDepositAndWithdrawalRequestSuccess());
          } else {
            emit(UpdateDepositAndWithdrawalRequestFailure('${decoded['message']}'));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("UpdateDepositAndWithdrawalRequestBloc [Catch Exception] >>error: $e");
          emit(UpdateDepositAndWithdrawalRequestFailure(e));
        }
      } else {
        emit(UpdateDepositAndWithdrawalRequestFailure("User not in"));
      }
    });
  }
}

//states
abstract class UpdateDepositAndWithdrawalRequestState {}

//events
abstract class UpdateDepositAndWithdrawalRequestEvent {}

//states implementation
class UpdateDepositAndWithdrawalRequestInitial extends UpdateDepositAndWithdrawalRequestState {}

class UpdateDepositAndWithdrawalRequestProgress extends UpdateDepositAndWithdrawalRequestState {}

class UpdateDepositAndWithdrawalRequestSuccess extends UpdateDepositAndWithdrawalRequestState {}

class UpdateDepositAndWithdrawalRequestFailure extends UpdateDepositAndWithdrawalRequestState {
  final dynamic error;
  UpdateDepositAndWithdrawalRequestFailure(this.error);
}

//events implementation
class UpdateDepositAndWithdrawalRequest extends UpdateDepositAndWithdrawalRequestEvent {
  UpdateDepositAndWithdrawalRequest({required this.updateDepositAndWithdrawalRequestMap});
  final Map<String, dynamic> updateDepositAndWithdrawalRequestMap;
}
