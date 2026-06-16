import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateFancyMarketSuspendBallRunBloc extends Bloc<UpdateFancyMarketSuspendBallRunEvent, UpdateFancyMarketSuspendBallRunState> {
  final EMApiRepository _emApiRepository;
  UpdateFancyMarketSuspendBallRunBloc(this._emApiRepository) : super(UpdateFancyMarketSuspendBallRunInitial()) {
    on<UpdateFancyMarketSuspendBallRun>((event, emit) async {
      emit(UpdateFancyMarketSuspendBallRunProgress());
      debugPrint("Called UpdateFancyMarketSuspendBallRunBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _emApiRepository.updateAllFancyMarketSusBallRun(body: event.updateFancyMarketSuspendBallRunMap);
          final decoded = jsonDecode(response.bodyString);
          if (kDebugMode) debugPrint(response.bodyString);
          if (decoded['status'] == 200) {
            emit(UpdateFancyMarketSuspendBallRunSuccess());
          } else {
            if (kDebugMode) debugPrint("UpdateFancyMarketSuspendBallRunBloc  [response error]>> 400");
            emit(UpdateFancyMarketSuspendBallRunFailure('${decoded['message']}'));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("UpdateFancyMarketSuspendBallRunBloc [Catch Exception] >>error: $e");
          emit(UpdateFancyMarketSuspendBallRunFailure(e));
        }
      } else {
        emit(UpdateFancyMarketSuspendBallRunFailure("User not in"));
      }
    });
  }
}

//states
abstract class UpdateFancyMarketSuspendBallRunState {}

//events
abstract class UpdateFancyMarketSuspendBallRunEvent {}

//states implementation
class UpdateFancyMarketSuspendBallRunInitial extends UpdateFancyMarketSuspendBallRunState {}

class UpdateFancyMarketSuspendBallRunProgress extends UpdateFancyMarketSuspendBallRunState {}

class UpdateFancyMarketSuspendBallRunSuccess extends UpdateFancyMarketSuspendBallRunState {}

class UpdateFancyMarketSuspendBallRunFailure extends UpdateFancyMarketSuspendBallRunState {
  final dynamic error;
  UpdateFancyMarketSuspendBallRunFailure(this.error);
}

//events implementation
class UpdateFancyMarketSuspendBallRun extends UpdateFancyMarketSuspendBallRunEvent {
  UpdateFancyMarketSuspendBallRun({required this.updateFancyMarketSuspendBallRunMap});
  final Map<String, dynamic> updateFancyMarketSuspendBallRunMap;
}
