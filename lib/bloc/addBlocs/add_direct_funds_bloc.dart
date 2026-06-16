import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class AddDirectFundsBloc extends Bloc<AddDirectFundsEvent, AddDirectFundsState> {
  final AccountApiRepository _accountApiRepository;
  AddDirectFundsBloc(this._accountApiRepository) : super(AddDirectFundsInitial()) {
    on<AddDirectFunds>((event, emit) async {
      emit(AddDirectFundsProgress());
      if (kDebugMode) debugPrint("Called AddDirectFundsBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _accountApiRepository.directFund(body: event.addDirectFundsMap);
          if (response.statusCode == 200) {
            if (kDebugMode) debugPrint(response.bodyString);
            emit(AddDirectFundsSuccess());
          } else {
            if (kDebugMode) debugPrint("AddDirectFundsBloc None 200  [response error]>> ${response.statusCode}");
            emit(AddDirectFundsFailure('AddDirectFundsBloc None 200  [response error]>> ${response.statusCode}'));
          }
        } catch (e) {
          emit(AddDirectFundsFailure(e));
          if (kDebugMode) debugPrint("AddDirectFundsBloc [Catch Exception] >>error: $e");
        }
      } else {
        emit(AddDirectFundsFailure("User not in"));
      }
    });
  }
}

//states
abstract class AddDirectFundsState {}

//events
abstract class AddDirectFundsEvent {}

//states implementation
class AddDirectFundsInitial extends AddDirectFundsState {}

class AddDirectFundsProgress extends AddDirectFundsState {}

class AddDirectFundsSuccess extends AddDirectFundsState {}

class AddDirectFundsFailure extends AddDirectFundsState {
  final dynamic error;
  AddDirectFundsFailure(this.error);
}

//events implementation
class AddDirectFunds extends AddDirectFundsEvent {
  AddDirectFunds({required this.addDirectFundsMap});
  final Map<String, dynamic> addDirectFundsMap;
}
