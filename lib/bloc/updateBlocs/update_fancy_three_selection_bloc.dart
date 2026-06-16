import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateFancyThreeSelectionBloc extends Bloc<UpdateFancyThreeSelectionEvent, UpdateFancyThreeSelectionState> {
  final EMApiRepository _emApiRepository;
  UpdateFancyThreeSelectionBloc(this._emApiRepository) : super(UpdateFancyThreeSelectionInitial()) {
    on<UpdateFancyThreeSelection>((event, emit) async {
      if (kDebugMode) debugPrint('Called UpdateFancyThreeSelectionBloc');
      emit(UpdateFancyThreeSelectionProgress(marketId: event.updateFancyThreeSelectionMap['marketId']));
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final response = await _emApiRepository.updateFancyThreeSelection(body: event.updateFancyThreeSelectionMap);
          final responseData = response.body;
          final status = responseData["status"];
          final data = responseData["data"];
          debugPrint('Market Three Update Data : $responseData');
          if (status == 200) {
            emit(UpdateFancyThreeSelectionSuccess(getMapFromResponse: data));
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            debugPrint('ErrorMsg: $errorMsg');
            if (kDebugMode) debugPrint("Request failure >> $errorMsg");
            emit(UpdateFancyThreeSelectionFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("UpdateFancyThreeSelectionBloc [Catch Exception] >> $e");
          emit(UpdateFancyThreeSelectionFailure(e));
        }
      } else {
        emit(UpdateFancyThreeSelectionFailure("User not logged in"));
      }
    });
  }
}

//states
abstract class UpdateFancyThreeSelectionState {}

//events
abstract class UpdateFancyThreeSelectionEvent {}

//states implementation
class UpdateFancyThreeSelectionInitial extends UpdateFancyThreeSelectionState {}

class UpdateFancyThreeSelectionProgress extends UpdateFancyThreeSelectionState {
  final String marketId;
  UpdateFancyThreeSelectionProgress({required this.marketId});
}

class UpdateFancyThreeSelectionSuccess extends UpdateFancyThreeSelectionState {
  UpdateFancyThreeSelectionSuccess({required this.getMapFromResponse});
  final Map<String, dynamic> getMapFromResponse;
}

class UpdateFancyThreeSelectionFailure extends UpdateFancyThreeSelectionState {
  final dynamic error;
  UpdateFancyThreeSelectionFailure(this.error);
}

//events implementation
class UpdateFancyThreeSelection extends UpdateFancyThreeSelectionEvent {
  UpdateFancyThreeSelection({required this.updateFancyThreeSelectionMap});
  final Map<String, dynamic> updateFancyThreeSelectionMap;
}
