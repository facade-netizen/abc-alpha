import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/settleManageRepo/ms_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/settle_history_model.dart';

class FetchSettleHistoryBloc extends Bloc<FetchSettleHistoryEvent, FetchSettleHistoryState> {
  final SettleApiRepository _settleApiRepository;
  FetchSettleHistoryBloc(this._settleApiRepository) : super(FetchSettleHistoryInitial()) {
    on<FetchSettleHistory>((event, emit) async {
      emit(FetchSettleHistoryProgress());
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<SettleHistoryResponse> response = await _settleApiRepository.getSettleHistory(event.marketId);
          if (response.statusCode == 200) {
            final settleHistory = response.body!.data;
            // if (kDebugMode) debugPrint("Decoded Response: $customMarketDate");
            emit(FetchSettleHistorySuccess(settleHistory: settleHistory));
          } else {
            if (kDebugMode) debugPrint("FetchSettleHistoryBloc - non 200 response ${response.statusCode}");
            emit(FetchSettleHistoryFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchSettleHistoryBloc,$e");
          emit(FetchSettleHistoryFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchSettleHistoryFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class FetchSettleHistoryState {}

//events
abstract class FetchSettleHistoryEvent {}

//states implementation
class FetchSettleHistoryInitial extends FetchSettleHistoryState {}

class FetchSettleHistoryProgress extends FetchSettleHistoryState {}

class FetchSettleHistorySuccess extends FetchSettleHistoryState {
  FetchSettleHistorySuccess({required this.settleHistory});
  final List<SettleHistoryData> settleHistory;
}

class FetchSettleHistoryFailure extends FetchSettleHistoryState {
  final dynamic error;
  FetchSettleHistoryFailure(this.error);
}

//events implementation
class FetchSettleHistory extends FetchSettleHistoryEvent {
  FetchSettleHistory({required this.marketId});
  final String marketId;
}
