import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/fancy_catalouges_on_markettype_model.dart';

class FetchCatalougeOnMarketTypeBloc extends Bloc<FetchCatalougeOnMarketTypeEvent, FetchCatalougeOnMarketTypeState> {
  final EMApiRepository _emApiRepository;
  FetchCatalougeOnMarketTypeBloc(this._emApiRepository) : super(FetchCatalougeOnMarketTypeInitial()) {
    on<FetchCatalougeOnMarketType>((event, emit) async {
      if (kDebugMode) debugPrint("Called FetchCatalougeOnMarketTypeBloc");
      emit(FetchCatalougeOnMarketTypeProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<FancyCatalougesOnMarketTypeResponse> response = await _emApiRepository.getCatalougesOnMarketType(event.eventId, event.marketType);
          if (response.statusCode == 200) {
            final catalougeDetails = response.body!.data;
            emit(FetchCatalougeOnMarketTypeSuccess(catalougeDetails: catalougeDetails));
          } else {
            if (kDebugMode) debugPrint("FetchCatalougeOnMarketTypeBloc - non 200 response ${response.statusCode}");
            emit(FetchCatalougeOnMarketTypeFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchCatalougeOnMarketTypeBloc,$e");
          emit(FetchCatalougeOnMarketTypeFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchCatalougeOnMarketTypeFailure("User Not Logged In"));
      }
    });
    on<FetchCatalougeOnMarketTypeSetToInit>((event, emit) async {
      emit(FetchCatalougeOnMarketTypeInitial());
    });
  }
}

//states
abstract class FetchCatalougeOnMarketTypeState {}

//events
abstract class FetchCatalougeOnMarketTypeEvent {}

//states implementation
class FetchCatalougeOnMarketTypeInitial extends FetchCatalougeOnMarketTypeState {}

class FetchCatalougeOnMarketTypeProgress extends FetchCatalougeOnMarketTypeState {}

class FetchCatalougeOnMarketTypeSuccess extends FetchCatalougeOnMarketTypeState {
  final List<FancyCatalougesOnMarketType> catalougeDetails;
  FetchCatalougeOnMarketTypeSuccess({required this.catalougeDetails});
}

class FetchCatalougeOnMarketTypeFailure extends FetchCatalougeOnMarketTypeState {
  final dynamic error;
  FetchCatalougeOnMarketTypeFailure(this.error);
}

//events implementation
class FetchCatalougeOnMarketType extends FetchCatalougeOnMarketTypeEvent {
  final int eventId;
  final String marketType;
  FetchCatalougeOnMarketType({required this.marketType, required this.eventId});
}

class FetchCatalougeOnMarketTypeSetToInit extends FetchCatalougeOnMarketTypeEvent {}
