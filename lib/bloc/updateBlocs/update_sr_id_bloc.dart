import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateSrIdBloc extends Bloc<UpdateSrIdEvent, UpdateSrIdState> {
  final EMApiRepository _emApiRepository;
  UpdateSrIdBloc(this._emApiRepository) : super(UpdateSrIdInitial()) {
    on<UpdateSrId>((event, emit) async {
      emit(UpdateSrIdProgress());
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response response = await _emApiRepository.updatePremium(event.eventId, event.srId);
          if (response.statusCode == 200) {
            final market = response.body;
            if (kDebugMode) debugPrint("Decoded Response: $market");
            emit(UpdateSrIdSuccess());
          } else {
            if (kDebugMode) debugPrint("UpdateSrIdBloc - non 200 response ${response.statusCode}");
            emit(UpdateSrIdFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in UpdateSrIdBloc,$e");
          emit(UpdateSrIdFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(UpdateSrIdFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class UpdateSrIdState {}

//events
abstract class UpdateSrIdEvent {}

//states implementation
class UpdateSrIdInitial extends UpdateSrIdState {}

class UpdateSrIdProgress extends UpdateSrIdState {}

class UpdateSrIdSuccess extends UpdateSrIdState {}

class UpdateSrIdFailure extends UpdateSrIdState {
  final dynamic error;
  UpdateSrIdFailure(this.error);
}

//events implementation
class UpdateSrId extends UpdateSrIdEvent {
  final String eventId;
  final String srId;
  UpdateSrId({required this.eventId, required this.srId});
}
