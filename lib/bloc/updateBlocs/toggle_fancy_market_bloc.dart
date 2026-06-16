import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class ToggleFancyMarketBloc extends Bloc<ToggleFancyMarketEvent, ToggleFancyMarketState> {
  final EMApiRepository _emApiRepository;
  ToggleFancyMarketBloc(this._emApiRepository) : super(ToggleFancyMarketInitial()) {
    on<ToggleFancyMarket>((event, emit) async {
      emit(ToggleFancyMarketProgress());
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response response = await _emApiRepository.toogleFancyMarket(event.marketId, event.enable, event.isBallRunning);
          if (response.statusCode == 200) {
            final market = response.body;
            if (kDebugMode) debugPrint("Decoded Response: $market");
            final data = market["data"];
            emit(ToggleFancyMarketSuccess(isEnabled: data["status"], marketId: data["marketId"]));
          } else {
            if (kDebugMode) debugPrint("ToggleFancyMarketBloc - non 200 response ${response.statusCode}");
            emit(ToggleFancyMarketFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in ToggleFancyMarketBloc,$e");
          emit(ToggleFancyMarketFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(ToggleFancyMarketFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class ToggleFancyMarketState {}

//events
abstract class ToggleFancyMarketEvent {}

//states implementation
class ToggleFancyMarketInitial extends ToggleFancyMarketState {}

class ToggleFancyMarketProgress extends ToggleFancyMarketState {}

class ToggleFancyMarketSuccess extends ToggleFancyMarketState {
  ToggleFancyMarketSuccess({required this.isEnabled, required this.marketId});
  final bool isEnabled;
  final String marketId;
}

class ToggleFancyMarketFailure extends ToggleFancyMarketState {
  final dynamic error;
  ToggleFancyMarketFailure(this.error);
}

//events implementation
class ToggleFancyMarket extends ToggleFancyMarketEvent {
  final String marketId;
  final bool enable;
  final bool isBallRunning;
  ToggleFancyMarket({required this.marketId, required this.enable, required this.isBallRunning});
}
