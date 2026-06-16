import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/settleManageRepo/ms_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/custom_fancy_market_model.dart';

class SaveMarketToSettleBloc extends Bloc<SaveMarketToSettleEvent, SaveMarketToSettleState> {
  final SettleApiRepository _settleApiRepository;
  SaveMarketToSettleBloc(this._settleApiRepository) : super(SaveMarketToSettleInitial()) {
    on<SaveMarketToSettle>((event, emit) async {
      emit(SaveMarketToSettleProgress());
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
          finalUpdateMap.addAll(event.saveMarketToSettle);
          finalUpdateMap.addAll({"createdDate": currentUnixSeconds, "updator": savedData.userName});
          final response = await _settleApiRepository.saveMarketTosettle(body: finalUpdateMap);
          if (response.statusCode == 200) {
            final saveMarketRes = response.body;
            if (saveMarketRes['status'] == 200) {
              if (kDebugMode) debugPrint("Decoded saveMarketRes: $saveMarketRes");
              final patch = CustomMarket.fromJson(saveMarketRes['data']);
              emit(SaveMarketToSettleSuccess(patch: patch));
            } else {
              if (kDebugMode) debugPrint("MarketSettleBloc  [response error]>> 400");
              emit(SaveMarketToSettleFailure('${saveMarketRes['message']}'));
            }
          } else {
            if (kDebugMode) debugPrint("SaveMarketToSettleBloc - non 200 response ${response.statusCode}");
            emit(SaveMarketToSettleFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in SaveMarketToSettleBloc,$e");
          emit(SaveMarketToSettleFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(SaveMarketToSettleFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class SaveMarketToSettleState {}

//events
abstract class SaveMarketToSettleEvent {}

//states implementation
class SaveMarketToSettleInitial extends SaveMarketToSettleState {}

class SaveMarketToSettleProgress extends SaveMarketToSettleState {}

class SaveMarketToSettleSuccess extends SaveMarketToSettleState {
  final CustomMarket patch;
  SaveMarketToSettleSuccess({required this.patch});
}

class SaveMarketToSettleFailure extends SaveMarketToSettleState {
  final dynamic error;
  SaveMarketToSettleFailure(this.error);
}

//events implementation
class SaveMarketToSettle extends SaveMarketToSettleEvent {
  SaveMarketToSettle({required this.saveMarketToSettle});
  final Map<String, dynamic> saveMarketToSettle;
}
