import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/event_type_model.dart';

class FetchEventTypesBloc extends Bloc<FetchEventTypesEvent, FetchEventTypesState> {
  final EMApiRepository _emApiRepository;
  FetchEventTypesBloc(this._emApiRepository) : super(FetchEventTypesInitial()) {
    on<FetchEventTypes>((event, emit) async {
      emit(FetchEventTypesProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<EventTypesResponse> response = await _emApiRepository.getEventType();
          if (response.statusCode == 200) {
            final filteredEventResponse = EventTypesResponse(
              status: response.body!.status,
              message: response.body!.message,
              data: response.body!.data.where((item) => item.id != "7" && item.id != "4339" && item.id != "2378961").toList(),
            );
            emit(FetchEventTypesSuccess(eventTypes: filteredEventResponse.data));
          } else {
            if (kDebugMode) debugPrint("FetchEventTypesBloc - non 200 response ${response.statusCode}");
            emit(FetchEventTypesFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchEventTypesBloc,$e");
          emit(FetchEventTypesFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchEventTypesFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class FetchEventTypesState {}

//events
abstract class FetchEventTypesEvent {}

//states implementation
class FetchEventTypesInitial extends FetchEventTypesState {}

class FetchEventTypesProgress extends FetchEventTypesState {}

class FetchEventTypesSuccess extends FetchEventTypesState {
  final List<EventTypes> eventTypes;
  FetchEventTypesSuccess({required this.eventTypes});
}

class FetchEventTypesFailure extends FetchEventTypesState {
  final dynamic error;
  FetchEventTypesFailure(this.error);
}

//events implementation
class FetchEventTypes extends FetchEventTypesEvent {}
