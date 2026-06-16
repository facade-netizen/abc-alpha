import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class DespoiAndWithdrawBloc extends Bloc<DespoiAndWithdrawEvent, DespoiAndWithdrawState> {
  final AccountApiRepository _accountApiRepository;
  DespoiAndWithdrawBloc(this._accountApiRepository) : super(DespoiAndWithdrawInitial()) {
    on<DespoiAndWithdraw>((event, emit) async {
      if (kDebugMode) debugPrint('Called DespoiAndWithdrawBloc');
      emit(DespoiAndWithdrawProgress());
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;

      if (savedData != null) {
        try {
          final response = await _accountApiRepository.depositAndWithdraw(body: event.depositAndWithdrawMap);
          final responseData = response.body;
          final status = responseData["status"];
          final data = responseData["data"];
          if (status == 200) {
            emit(DespoiAndWithdrawSuccess());
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            if (kDebugMode) debugPrint("Request failure >> $errorMsg");
            emit(DespoiAndWithdrawFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("DespoiAndWithdrawBloc [Catch Exception] >> $e");
          emit(DespoiAndWithdrawFailure(e));
        }
      } else {
        emit(DespoiAndWithdrawFailure("User not logged in"));
      }
    });
  }
}

//states
abstract class DespoiAndWithdrawState {}

//events
abstract class DespoiAndWithdrawEvent {}

//states implementation
class DespoiAndWithdrawInitial extends DespoiAndWithdrawState {}

class DespoiAndWithdrawProgress extends DespoiAndWithdrawState {}

class DespoiAndWithdrawSuccess extends DespoiAndWithdrawState {}

class DespoiAndWithdrawFailure extends DespoiAndWithdrawState {
  final dynamic error;
  DespoiAndWithdrawFailure(this.error);
}

//events implementation
class DespoiAndWithdraw extends DespoiAndWithdrawEvent {
  DespoiAndWithdraw({required this.depositAndWithdrawMap});
  final Map<String, dynamic> depositAndWithdrawMap;
}
