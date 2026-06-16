import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/competitions_by_eventtype_model.dart';

class FetchCompetitionsByEventTypeBloc extends Bloc<FetchCompetitionsByEventTypeEvent, FetchCompetitionsByEventTypeState> {
  final EMApiRepository _emApiRepository;
  // In-memory cache keyed by sportId — avoids re-fetching on browser back/forward
  final Map<String, List<CompetitionByEventType>> _cache = {};

  FetchCompetitionsByEventTypeBloc(this._emApiRepository) : super(FetchCompetitionsByEventTypeInitial()) {
    on<FetchCompetitionsByEventType>((event, emit) async {
      emit(FetchCompetitionsByEventTypeProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<CompetitionResponseByEventType> response = await _emApiRepository.getCompetitionByEventTypeId(event.sportId, event.sportName);
          if (response.statusCode == 200) {
            final competitionByEventType = response.body!.data;
            _cache[event.sportId] = competitionByEventType;
            emit(FetchCompetitionsByEventTypeSuccess(competitionByEventType: competitionByEventType));
          } else {
            if (kDebugMode) debugPrint("FetchCompetitionsByEventTypeBloc - none 200 response ${response.statusCode}");
            emit(FetchCompetitionsByEventTypeFailure("FetchCompetitionsByEventTypeBloc - none 200  response ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchCompetitionsByEventTypeBloc,$e");
          emit(FetchCompetitionsByEventTypeFailure(e));
        }
      } else {
        emit(FetchCompetitionsByEventTypeFailure('User not logged in'));
      }
    });
  }
}

//states
abstract class FetchCompetitionsByEventTypeState {}

//events
abstract class FetchCompetitionsByEventTypeEvent {}

//states implementation
class FetchCompetitionsByEventTypeInitial extends FetchCompetitionsByEventTypeState {}

class FetchCompetitionsByEventTypeProgress extends FetchCompetitionsByEventTypeState {}

class FetchCompetitionsByEventTypeSuccess extends FetchCompetitionsByEventTypeState {
  final List<CompetitionByEventType> competitionByEventType;
  FetchCompetitionsByEventTypeSuccess({required this.competitionByEventType});
}

class FetchCompetitionsByEventTypeFailure extends FetchCompetitionsByEventTypeState {
  final dynamic error;
  FetchCompetitionsByEventTypeFailure(this.error);
}

//events implementation
class FetchCompetitionsByEventType extends FetchCompetitionsByEventTypeEvent {
  final String sportId;
  final String sportName;
  FetchCompetitionsByEventType({required this.sportId, required this.sportName});
}
