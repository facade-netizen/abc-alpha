import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/whiteLableRepo/white_lable_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/white_lable_model.dart';

class FetchAllWLBloc extends Bloc<FetchAllWLEvent, FetchAllWLState> {
  final WhiteLableRepository _whiteLableRepository;
  FetchAllWLBloc(this._whiteLableRepository) : super(FetchAllWLInitial()) {
    on<FetchAllWL>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchAllWLBloc');
      emit(FetchAllWLProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final response = await _whiteLableRepository.getAllWhiteLables();
          if (response.statusCode == 200) {
            // if (kDebugMode) debugPrint(response.bodyString);
            emit(FetchAllWLSuccess(wlData: response.body!.data));
          } else {
            if (kDebugMode) debugPrint("FetchAllWLBloc None 200  [response error]>> ${response.statusCode}");
            emit(FetchAllWLFailure('FetchAllWLBloc None 200 [response error]>> ${response.statusCode}'));
          }
        } catch (e) {
          if (kDebugMode) debugPrint('FetchAllWLBloc [Try Block Exception]>> \n $e');
          emit(FetchAllWLFailure(e));
        }
      } else {
        emit(FetchAllWLFailure('User not logged in'));
      }
    });
  }
}

// states
abstract class FetchAllWLState {}

// events
abstract class FetchAllWLEvent {}

// states implementation
class FetchAllWLInitial extends FetchAllWLState {}

class FetchAllWLProgress extends FetchAllWLState {}

class FetchAllWLSuccess extends FetchAllWLState {
  FetchAllWLSuccess({required this.wlData});
  final List<WhiteLableAppData> wlData;
}

class FetchAllWLFailure extends FetchAllWLState {
  FetchAllWLFailure(this.error);
  final dynamic error;
}

// events implementation
class FetchAllWL extends FetchAllWLEvent {}
