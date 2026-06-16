import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../model/deposit_request_model.dart';

class FetchDepositRequestsBloc extends Bloc<FetchDepositRequestsEvent, FetchDepositRequestsState> {
  final AccountApiRepository _accountApiRepository;
  FetchDepositRequestsBloc(this._accountApiRepository) : super(FetchDepositRequestsInitial()) {
    on<FetchDepositRequests>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchDepositRequestsBloc');
      emit(FetchDepositRequestsProgress());
      try {
        final Response<DepositRequestResponse> response = await _accountApiRepository.getDepositRequest("pending");
        if (response.statusCode == 200) {
          final depositRequest = response.body!.data;
          // if (kDebugMode) debugPrint("Decoded Response: $depositRequest");
          emit(FetchDepositRequestsSuccess(depositRequest: depositRequest.where((type) => type.type == 'Deposit').toList()));
        } else {
          if (kDebugMode) debugPrint("FetchDepositRequestsBloc - non 200 response ${response.statusCode}");
          emit(FetchDepositRequestsFailure("Non ${response.statusCode} Status"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FetchDepositRequestsBloc Catch Error $e');
        emit(FetchDepositRequestsFailure(e));
      }
    });
  }
}

//states
abstract class FetchDepositRequestsState {}

//events
abstract class FetchDepositRequestsEvent {}

//states implementation
class FetchDepositRequestsInitial extends FetchDepositRequestsState {}

class FetchDepositRequestsProgress extends FetchDepositRequestsState {}

class FetchDepositRequestsSuccess extends FetchDepositRequestsState {
  final List<DepositRequest> depositRequest;
  FetchDepositRequestsSuccess({required this.depositRequest});
}

class FetchDepositRequestsFailure extends FetchDepositRequestsState {
  final dynamic error;
  FetchDepositRequestsFailure(this.error);
}

//events implementation
class FetchDepositRequests extends FetchDepositRequestsEvent {}
