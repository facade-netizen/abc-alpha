import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../model/withdrawal_request_model.dart';

class FetchWithdrawalRequestsBloc extends Bloc<FetchWithdrawalRequestsEvent, FetchWithdrawalRequestsState> {
  final AccountApiRepository _accountApiRepository;
  FetchWithdrawalRequestsBloc(this._accountApiRepository) : super(FetchWithdrawalRequestsInitial()) {
    on<FetchWithdrawalRequests>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchWithdrawalRequestsBloc');
      emit(FetchWithdrawalRequestsProgress());
      try {
        final Response<WithdrawalRequestResponse> response = await _accountApiRepository.getWithdrawalRequest("pending");
        if (response.statusCode == 200) {
          final withdrawalRequest = response.body!.data;
          // if (kDebugMode) debugPrint("Decoded Response: $withdrawalRequest");
          emit(FetchWithdrawalRequestsSuccess(withdrawalRequest: withdrawalRequest.where((type) => type.type == 'Withdraw').toList()));
        } else {
          if (kDebugMode) debugPrint("FetchWithdrawalRequestsBloc - non 200 response ${response.statusCode}");
          emit(FetchWithdrawalRequestsFailure("Non ${response.statusCode} Status"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FetchWithdrawalRequestsBloc Catch Error $e');
        emit(FetchWithdrawalRequestsFailure(e));
      }
    });
  }
}

//states
abstract class FetchWithdrawalRequestsState {}

//events
abstract class FetchWithdrawalRequestsEvent {}

//states implementation
class FetchWithdrawalRequestsInitial extends FetchWithdrawalRequestsState {}

class FetchWithdrawalRequestsProgress extends FetchWithdrawalRequestsState {}

class FetchWithdrawalRequestsSuccess extends FetchWithdrawalRequestsState {
  final List<WithdrawalRequest> withdrawalRequest;
  FetchWithdrawalRequestsSuccess({required this.withdrawalRequest});
}

class FetchWithdrawalRequestsFailure extends FetchWithdrawalRequestsState {
  final dynamic error;
  FetchWithdrawalRequestsFailure(this.error);
}

//events implementation
class FetchWithdrawalRequests extends FetchWithdrawalRequestsEvent {}
