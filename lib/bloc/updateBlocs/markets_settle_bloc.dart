import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/settleManageRepo/ms_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class MarketSettleBloc extends Bloc<MarketSettleEvent, MarketSettleState> {
  final SettleApiRepository _settleApiRepository;
  MarketSettleBloc(this._settleApiRepository) : super(MarketSettleInitial()) {
    on<MarketSettle>((event, emit) async {
      emit(MarketSettleProgress());
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final DateTime unixEpoch = DateTime.utc(1970, 1, 1, 0, 0, 0);
          int convertInSeconds(DateTime dateTime) {
            return dateTime.toUtc().difference(unixEpoch).inSeconds;
          }

          final DateTime nowLocal = DateTime.now();
          final int currentUnixSeconds = convertInSeconds(nowLocal);
          final Map<String, dynamic> finalUpdateMap = {};
          finalUpdateMap.addAll(event.marketSettle);
          finalUpdateMap.addAll({"createdDate": currentUnixSeconds, "settler": savedData.userName});
          final response = await _settleApiRepository.marketSettle(body: finalUpdateMap);
          if (response.statusCode == 200) {
            final saveMarketRes = response.body;
            if (saveMarketRes['status'] == 200) {
              if (kDebugMode) debugPrint("Decoded saveMarketRes: $saveMarketRes");
              emit(MarketSettleSuccess());
            } else {
              if (kDebugMode) debugPrint("MarketSettleBloc  [response error]>> 400");
              emit(MarketSettleFailure('${saveMarketRes['message']}'));
            }
          } else {
            if (kDebugMode) debugPrint("MarketSettleBloc - non 200 response ${response.statusCode}");
            emit(MarketSettleFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in MarketSettleBloc,$e");
          emit(MarketSettleFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(MarketSettleFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class MarketSettleState {}

//events
abstract class MarketSettleEvent {}

//states implementation
class MarketSettleInitial extends MarketSettleState {}

class MarketSettleProgress extends MarketSettleState {}

class MarketSettleSuccess extends MarketSettleState {}

class MarketSettleFailure extends MarketSettleState {
  final dynamic error;
  MarketSettleFailure(this.error);
}

//events implementation
class MarketSettle extends MarketSettleEvent {
  MarketSettle({required this.marketSettle});
  final Map<String, dynamic> marketSettle;
}
