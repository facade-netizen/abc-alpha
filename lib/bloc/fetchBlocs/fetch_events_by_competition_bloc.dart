import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/events_model.dart';

class FetchEventsByCompetitionBloc extends Bloc<FetchEventsByCompetitionEvent, FetchEventsByCompetitionState> {
  final EMApiRepository _emApiRepository;
  // In-memory cache keyed by competitionId — avoids re-fetching on browser back/forward
  final Map<String, List<EventDetails>> _cache = {};

  FetchEventsByCompetitionBloc(this._emApiRepository) : super(FetchEventsByCompetitionInitial()) {
    on<FetchEventsByCompetition>((event, emit) async {
      if (kDebugMode) debugPrint(" Called FetchEventsByCompetitionBloc");
      // Return cached data immediately unless a force refresh is requested
      if (!event.forceRefresh && _cache.containsKey(event.competitionId)) {
        emit(FetchEventsByCompetitionSuccess(eventDetails: _cache[event.competitionId]!));
        return;
      }
      emit(FetchEventsByCompetitionProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<EventByCompetitionResponse> response = await _emApiRepository.getEventsByCompId(event.competitionId, event.provider);
          if (response.statusCode == 200) {
            final eventDetails = response.body!.data;
            _cache[event.competitionId] = eventDetails;
            emit(FetchEventsByCompetitionSuccess(eventDetails: eventDetails));
          } else {
            if (kDebugMode) debugPrint("FetchEventsByCompetitionBloc - non 200 response ${response.statusCode}");
            emit(FetchEventsByCompetitionFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchEventsByCompetitionBloc,$e");
          emit(FetchEventsByCompetitionFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchEventsByCompetitionFailure("User Not Logged In"));
      }
    });
    on<FetchEventsByCompetitionSetToInit>((event, emit) async {
      emit(FetchEventsByCompetitionInitial());
    });
  }
}

//states
abstract class FetchEventsByCompetitionState {}

//events
abstract class FetchEventsByCompetitionEvent {}

//states implementation
class FetchEventsByCompetitionInitial extends FetchEventsByCompetitionState {}

class FetchEventsByCompetitionProgress extends FetchEventsByCompetitionState {}

class FetchEventsByCompetitionSuccess extends FetchEventsByCompetitionState {
  final List<EventDetails> eventDetails;
  FetchEventsByCompetitionSuccess({required this.eventDetails});
}

class FetchEventsByCompetitionFailure extends FetchEventsByCompetitionState {
  final dynamic error;
  FetchEventsByCompetitionFailure(this.error);
}

//events implementation
class FetchEventsByCompetition extends FetchEventsByCompetitionEvent {
  final String competitionId;
  final String provider;
  final bool forceRefresh;
  FetchEventsByCompetition({required this.competitionId, required this.provider, this.forceRefresh = false});
}

class FetchEventsByCompetitionSetToInit extends FetchEventsByCompetitionEvent {}
