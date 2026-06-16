import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/fancy_bet_exposure_model.dart';

class FetchFancyBetExposureBloc extends Bloc<FetchFancyBetExposureEvent, FetchFancyBetExposureState> {
  final EMApiRepository _emApiRepository;
  FetchFancyBetExposureBloc(this._emApiRepository) : super(FetchFancyBetExposureInitial()) {
    on<FetchFancyBetExposure>((event, emit) async {
      if (kDebugMode) debugPrint("Called FetchFancyBetExposureBloc");
      emit(FetchFancyBetExposureProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<FancyBetResponse> response = await _emApiRepository.getFancyBetExposure(event.marketId);
          if (response.statusCode == 200) {
            final fancyBetData = response.body!.data;
            emit(FetchFancyBetExposureSuccess(fancyBetData: fancyBetData));
          } else {
            if (kDebugMode) debugPrint("FetchFancyBetExposureBloc - non 200 response ${response.statusCode}");
            emit(FetchFancyBetExposureFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchFancyBetExposureBloc,$e");
          emit(FetchFancyBetExposureFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchFancyBetExposureFailure("User Not Logged In"));
      }
    });
    on<FetchFancyBetExposureSetToInit>((event, emit) async {
      emit(FetchFancyBetExposureInitial());
    });
  }
}

//states
abstract class FetchFancyBetExposureState {}

//events
abstract class FetchFancyBetExposureEvent {}

//states implementation
class FetchFancyBetExposureInitial extends FetchFancyBetExposureState {}

class FetchFancyBetExposureProgress extends FetchFancyBetExposureState {}

class FetchFancyBetExposureSuccess extends FetchFancyBetExposureState {
  final List<FancyBetData> fancyBetData;
  FetchFancyBetExposureSuccess({required this.fancyBetData});
}

class FetchFancyBetExposureFailure extends FetchFancyBetExposureState {
  final dynamic error;
  FetchFancyBetExposureFailure(this.error);
}

//events implementation
class FetchFancyBetExposure extends FetchFancyBetExposureEvent {
  final String marketId;
  FetchFancyBetExposure({required this.marketId});
}

class FetchFancyBetExposureSetToInit extends FetchFancyBetExposureEvent {}
