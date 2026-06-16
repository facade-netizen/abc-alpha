import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateMarketSequenceBloc extends Bloc<UpdateMarketSequenceEvent, UpdateMarketSequenceState> {
  final EMApiRepository _emApiRepository;
  UpdateMarketSequenceBloc(this._emApiRepository) : super(UpdateMarketSequenceInitial()) {
    on<UpdateMarketSequence>((event, emit) async {
      emit(UpdateMarketSequenceProgress());
      debugPrint("Called UpdateMarketSequenceBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _emApiRepository.updateMarketSequence(body: event.updateMarketSequenceMap);
          final decoded = jsonDecode(response.bodyString);
          if (kDebugMode) debugPrint(response.bodyString);
          if (decoded['status'] == 200) {
            emit(UpdateMarketSequenceSuccess());
          } else {
            if (kDebugMode) debugPrint("UpdateMarketSequenceBloc  [response error]>> 400");
            emit(UpdateMarketSequenceFailure('${decoded['message']}'));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("UpdateMarketSequenceBloc [Catch Exception] >>error: $e");
          emit(UpdateMarketSequenceFailure(e));
        }
      } else {
        emit(UpdateMarketSequenceFailure("User not in"));
      }
    });
  }
}

//states
abstract class UpdateMarketSequenceState {}

//events
abstract class UpdateMarketSequenceEvent {}

//states implementation
class UpdateMarketSequenceInitial extends UpdateMarketSequenceState {}

class UpdateMarketSequenceProgress extends UpdateMarketSequenceState {}

class UpdateMarketSequenceSuccess extends UpdateMarketSequenceState {}

class UpdateMarketSequenceFailure extends UpdateMarketSequenceState {
  final dynamic error;
  UpdateMarketSequenceFailure(this.error);
}

//events implementation
class UpdateMarketSequence extends UpdateMarketSequenceEvent {
  UpdateMarketSequence({required this.updateMarketSequenceMap});
  final Map<String, dynamic> updateMarketSequenceMap;
}
