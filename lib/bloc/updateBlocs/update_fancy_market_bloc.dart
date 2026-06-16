import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateFancyMarketBloc extends Bloc<UpdateFancyMarketEvent, UpdateFancyMarketState> {
  final EMApiRepository _emApiRepository;
  UpdateFancyMarketBloc(this._emApiRepository) : super(UpdateFancyMarketInitial()) {
    on<UpdateFancyMarket>((event, emit) async {
      if (kDebugMode) debugPrint('Called UpdateFancyMarketBloc');
      emit(UpdateFancyMarketProgress(marketId: event.updateFancyMap['marketId']));
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
          finalUpdateMap.addAll(event.updateFancyMap);
          finalUpdateMap.addAll({"updateBy": savedData.userName, "updateTime": currentUnixSeconds});
          final response = await _emApiRepository.updateFancyMarket(body: finalUpdateMap);
          final responseData = response.body;
          final status = responseData["status"];
          final data = responseData["data"];
          debugPrint('Market Update Data : $responseData');
          if (status == 200) {
            emit(UpdateFancyMarketSuccess());
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            debugPrint('ErrorMsg: $errorMsg');
            if (kDebugMode) debugPrint("Request failure >> $errorMsg");
            emit(UpdateFancyMarketFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("UpdateFancyMarketBloc [Catch Exception] >> $e");
          emit(UpdateFancyMarketFailure(e));
        }
      } else {
        emit(UpdateFancyMarketFailure("User not logged in"));
      }
    });
  }
}

//states
abstract class UpdateFancyMarketState {}

//events
abstract class UpdateFancyMarketEvent {}

//states implementation
class UpdateFancyMarketInitial extends UpdateFancyMarketState {}

class UpdateFancyMarketProgress extends UpdateFancyMarketState {
  final String marketId;
  UpdateFancyMarketProgress({required this.marketId});
}

class UpdateFancyMarketSuccess extends UpdateFancyMarketState {}

class UpdateFancyMarketFailure extends UpdateFancyMarketState {
  final dynamic error;
  UpdateFancyMarketFailure(this.error);
}

//events implementation
class UpdateFancyMarket extends UpdateFancyMarketEvent {
  UpdateFancyMarket({required this.updateFancyMap});
  final Map<String, dynamic> updateFancyMap;
}
