import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/fancy_bet_list_model.dart';

class FetchFancyBetEventsBloc extends Bloc<FetchFancyBetEventsEvent, FetchFancyBetEventsState> {
  final EMApiRepository _emApiRepository;
  FetchFancyBetEventsBloc(this._emApiRepository) : super(FetchFancyBetEventsInitial()) {
    on<FetchFancyBetEvents>((event, emit) async {
      if (kDebugMode) debugPrint("Called FetchFancyBetEventsBloc");
      emit(FetchFancyBetEventsProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<FancyBetEventResponse> response = await _emApiRepository.getFancyBetEvents(body: event.fancyBetMap);
          if (response.statusCode == 200) {
            final eventDetails = response.body!.data;
            emit(FetchFancyBetEventsSuccess(eventDetails: eventDetails));
          } else {
            if (kDebugMode) debugPrint("FetchFancyBetEventsBloc - non 200 response ${response.statusCode}");
            emit(FetchFancyBetEventsFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchFancyBetEventsBloc,$e");
          emit(FetchFancyBetEventsFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchFancyBetEventsFailure("User Not Logged In"));
      }
    });
    on<FetchFancyBetEventsSetToInit>((event, emit) async {
      emit(FetchFancyBetEventsInitial());
    });
  }
}

//states
abstract class FetchFancyBetEventsState {}

//events
abstract class FetchFancyBetEventsEvent {}

//states implementation
class FetchFancyBetEventsInitial extends FetchFancyBetEventsState {}

class FetchFancyBetEventsProgress extends FetchFancyBetEventsState {}

class FetchFancyBetEventsSuccess extends FetchFancyBetEventsState {
  final List<FancyBetEventData> eventDetails;
  FetchFancyBetEventsSuccess({required this.eventDetails});
}

class FetchFancyBetEventsFailure extends FetchFancyBetEventsState {
  final dynamic error;
  FetchFancyBetEventsFailure(this.error);
}

//events implementation
class FetchFancyBetEvents extends FetchFancyBetEventsEvent {
  final Map<String, dynamic> fancyBetMap;
  FetchFancyBetEvents({required this.fancyBetMap});
}

class FetchFancyBetEventsSetToInit extends FetchFancyBetEventsEvent {}
