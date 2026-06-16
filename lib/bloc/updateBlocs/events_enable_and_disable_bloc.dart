import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class EventsEnableAndDisableBloc extends Bloc<EventsEnableAndDisableEvent, EventsEnableAndDisableState> {
  final EMApiRepository _emApiRepository;
  EventsEnableAndDisableBloc(this._emApiRepository) : super(EventsEnableAndDisableInitial()) {
    on<EventsEnableAndDisable>((event, emit) async {
      emit(EventsEnableAndDisableProgress());
      debugPrint("Called EventsEnableAndDisableBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _emApiRepository.eventToggle(body: event.eventsEnableAndDisableMap);
          final decoded = jsonDecode(response.bodyString);
          if (decoded['status'] == 200) {
            final data = decoded['data'];
            emit(EventsEnableAndDisableSuccess(compId: data['compId'], provider: data['provider']));
          } else {
            if (kDebugMode) debugPrint("EventsEnableAndDisableBloc  [response error]>> 400");
            emit(EventsEnableAndDisableFailure('${decoded['message']}'));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("EventsEnableAndDisableBloc [Catch Exception] >>error: $e");
          emit(EventsEnableAndDisableFailure(e));
        }
      } else {
        emit(EventsEnableAndDisableFailure("User not in"));
      }
    });
  }
}

//states
abstract class EventsEnableAndDisableState {}

//events
abstract class EventsEnableAndDisableEvent {}

//states implementation
class EventsEnableAndDisableInitial extends EventsEnableAndDisableState {}

class EventsEnableAndDisableProgress extends EventsEnableAndDisableState {}

class EventsEnableAndDisableSuccess extends EventsEnableAndDisableState {
  EventsEnableAndDisableSuccess({required this.compId, required this.provider});
  final String compId;
  final String provider;
}

class EventsEnableAndDisableFailure extends EventsEnableAndDisableState {
  final dynamic error;
  EventsEnableAndDisableFailure(this.error);
}

//events implementation
class EventsEnableAndDisable extends EventsEnableAndDisableEvent {
  EventsEnableAndDisable({required this.eventsEnableAndDisableMap});
  final Map<dynamic, dynamic> eventsEnableAndDisableMap;
}
