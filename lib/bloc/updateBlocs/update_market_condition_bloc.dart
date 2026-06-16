import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateMarketConditionBloc extends Bloc<UpdateMarketConditionEvent, UpdateMarketConditionState> {
  final EMApiRepository _emApiRepository;
  UpdateMarketConditionBloc(this._emApiRepository) : super(UpdateMarketConditionInitial()) {
    on<UpdateMarketCondition>((event, emit) async {
      emit(UpdateMarketConditionProgress(marketId: event.updateMarketConditionMap['marketId']));
      debugPrint("Called UpdateMarketConditionBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _emApiRepository.updateMarketCondition(body: event.updateMarketConditionMap);
          final decoded = jsonDecode(response.bodyString);
          if (kDebugMode) debugPrint(response.bodyString);
          if (decoded['status'] == 200) {
            emit(UpdateMarketConditionSuccess(marketId: event.updateMarketConditionMap['marketId']));
          } else {
            if (kDebugMode) debugPrint("UpdateMarketConditionBloc  [response error]>> 400");
            emit(UpdateMarketConditionFailure('${decoded['message']}',event.updateMarketConditionMap['marketId']));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("UpdateMarketConditionBloc [Catch Exception] >>error: $e");
          emit(UpdateMarketConditionFailure(e,event.updateMarketConditionMap['marketId']));
        }
      } else {
        emit(UpdateMarketConditionFailure("User not in",event.updateMarketConditionMap['marketId']));
      }
    });
  }
}

//states
abstract class UpdateMarketConditionState {}

//events
abstract class UpdateMarketConditionEvent {}

//states implementation
class UpdateMarketConditionInitial extends UpdateMarketConditionState {}

class UpdateMarketConditionProgress extends UpdateMarketConditionState {
  UpdateMarketConditionProgress({required this.marketId});
  final String marketId;
}

class UpdateMarketConditionSuccess extends UpdateMarketConditionState {
  UpdateMarketConditionSuccess({required this.marketId});
  final String marketId;
}

class UpdateMarketConditionFailure extends UpdateMarketConditionState {
  final dynamic error;
  final String marketId;
  UpdateMarketConditionFailure(this.error, this.marketId);
}

//events implementation
class UpdateMarketCondition extends UpdateMarketConditionEvent {
  UpdateMarketCondition({required this.updateMarketConditionMap});
  final Map<String, dynamic> updateMarketConditionMap;
}
