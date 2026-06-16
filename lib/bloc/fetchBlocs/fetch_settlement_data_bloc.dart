import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../model/settlement_model.dart';

class FetchSettlementBloc extends Bloc<FetchSettlementEvent, FetchSettlementState> {
  final AccountApiRepository _accountApiRepository;
  FetchSettlementBloc(this._accountApiRepository) : super(FetchSettlementInitial()) {
    on<FetchSettlement>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchSettlementBloc');
      emit(FetchSettlementProgress());
      try {
        final Response<SettlementResponse> response = await _accountApiRepository.getSettlement();
        if (response.statusCode == 200) {
          SettlementResponse settlement = response.body!;
          emit(FetchSettlementSuccess(settlement: settlement));
        } else {
          if (kDebugMode) debugPrint("FetchSettlementBloc - non 200 response ${response.statusCode}");
          emit(FetchSettlementFailure("Non ${response.statusCode} Status"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FetchSettlementBloc Catch Error $e');
        emit(FetchSettlementFailure(e));
      }
    });
  }
}

//states
abstract class FetchSettlementState {}

//events
abstract class FetchSettlementEvent {}

//states implementation
class FetchSettlementInitial extends FetchSettlementState {}

class FetchSettlementProgress extends FetchSettlementState {}

class FetchSettlementSuccess extends FetchSettlementState {
  final SettlementResponse settlement;
  FetchSettlementSuccess({required this.settlement});
}

class FetchSettlementFailure extends FetchSettlementState {
  final dynamic error;
  FetchSettlementFailure(this.error);
}

//events implementation
class FetchSettlement extends FetchSettlementEvent {}
