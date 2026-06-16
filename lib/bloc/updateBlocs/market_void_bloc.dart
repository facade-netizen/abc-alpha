import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class MarketVoidBloc extends Bloc<MarketVoidEvent, MarketVoidState> {
  final EMApiRepository _emApiRepository;
  MarketVoidBloc(this._emApiRepository) : super(MarketVoidInitial()) {
    on<MarketVoid>((event, emit) async {
      emit(MarketVoidProgress());
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response response = await _emApiRepository.voidMarket(event.marketId);
          if (response.statusCode == 200) {
            final market = response.body;
            if (kDebugMode) debugPrint("Decoded Response: $market");
            emit(MarketVoidSuccess());
          } else {
            if (kDebugMode) debugPrint("MarketVoidBloc - non 200 response ${response.statusCode}");
            emit(MarketVoidFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in MarketVoidBloc,$e");
          emit(MarketVoidFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(MarketVoidFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class MarketVoidState {}

//events
abstract class MarketVoidEvent {}

//states implementation
class MarketVoidInitial extends MarketVoidState {}

class MarketVoidProgress extends MarketVoidState {}

class MarketVoidSuccess extends MarketVoidState {}

class MarketVoidFailure extends MarketVoidState {
  final dynamic error;
  MarketVoidFailure(this.error);
}

//events implementation
class MarketVoid extends MarketVoidEvent {
  final String marketId;
  MarketVoid({required this.marketId});
}
