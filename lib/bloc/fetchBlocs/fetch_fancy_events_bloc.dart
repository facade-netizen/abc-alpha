import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/fancy_events_model.dart';

class FetchFancyEventsBloc extends Bloc<FetchFancyEventsEvent, FetchFancyEventsState> {
  final EMApiRepository _emApiRepository;
  FetchFancyEventsBloc(this._emApiRepository) : super(FetchFancyEventsInitial()) {
    on<FetchFancyEvents>((event, emit) async {
      if (kDebugMode) debugPrint("Called FetchFancyEventsBloc");
      emit(FetchFancyEventsProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<FancyEventResponse> response = await _emApiRepository.getFancyEvent(event.selectedDate, 4);
          if (response.statusCode == 200) {
            final eventDetails = response.body!.data;
            emit(FetchFancyEventsSuccess(eventDetails: eventDetails));
          } else {
            if (kDebugMode) debugPrint("FetchFancyEventsBloc - non 200 response ${response.statusCode}");
            emit(FetchFancyEventsFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchFancyEventsBloc,$e");
          emit(FetchFancyEventsFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchFancyEventsFailure("User Not Logged In"));
      }
    });
    on<FetchFancyEventsSetToInit>((event, emit) async {
      emit(FetchFancyEventsInitial());
    });
  }
}

//states
abstract class FetchFancyEventsState {}

//events
abstract class FetchFancyEventsEvent {}

//states implementation
class FetchFancyEventsInitial extends FetchFancyEventsState {}

class FetchFancyEventsProgress extends FetchFancyEventsState {}

class FetchFancyEventsSuccess extends FetchFancyEventsState {
  final List<FancyEventData> eventDetails;
  FetchFancyEventsSuccess({required this.eventDetails});
}

class FetchFancyEventsFailure extends FetchFancyEventsState {
  final dynamic error;
  FetchFancyEventsFailure(this.error);
}

//events implementation
class FetchFancyEvents extends FetchFancyEventsEvent {
  final String selectedDate;
  FetchFancyEvents({required this.selectedDate});
}

class FetchFancyEventsSetToInit extends FetchFancyEventsEvent {}
