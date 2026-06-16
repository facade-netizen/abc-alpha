import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/whiteLableRepo/white_lable_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/wl_full_report_model.dart';

class FetchWLFullReportsBloc extends Bloc<FetchWLFullReportsEvent, FetchWLFullReportsState> {
  final WhiteLableRepository _wlFullReports;
  FetchWLFullReportsBloc(this._wlFullReports) : super(FetchWLFullReportsInitial()) {
    on<FetchWLFullReports>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchWLFullReportsBloc');
      emit(FetchWLFullReportsProgress());
      //checking authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final response = await _wlFullReports.wlfullReport();
          if (response.statusCode == 200) {
            // if (kDebugMode) debugPrint(response.bodyString);
            emit(FetchWLFullReportsSuccess(wlFullReports: response.body!.data, wlFullReportsResponse: response.body!));
          } else {
            if (kDebugMode) debugPrint("FetchWLFullReportsBloc None 200 [response error]>> ${response.statusCode}");
            emit(FetchWLFullReportsFailure('FetchWLFullReportsBloc None 200 [response error]>> ${response.statusCode}'));
          }
        } catch (e) {
          if (kDebugMode) debugPrint('FetchWLFullReportsBloc  [Try Block Exception]>> \n $e');
          emit(FetchWLFullReportsFailure(e));
        }
      } else {
        emit(FetchWLFullReportsFailure('User not logged in'));
      }
    });
  }
}

// states
abstract class FetchWLFullReportsState {}

// events
abstract class FetchWLFullReportsEvent {}

// states implementation
class FetchWLFullReportsInitial extends FetchWLFullReportsState {}

class FetchWLFullReportsProgress extends FetchWLFullReportsState {}

class FetchWLFullReportsSuccess extends FetchWLFullReportsState {
  FetchWLFullReportsSuccess({required this.wlFullReports, required this.wlFullReportsResponse});
  final List<WlFullReportsData> wlFullReports;
  final WlFullReportsResponse wlFullReportsResponse;
}

class FetchWLFullReportsFailure extends FetchWLFullReportsState {
  FetchWLFullReportsFailure(this.error);
  final dynamic error;
}

// events implementation
class FetchWLFullReports extends FetchWLFullReportsEvent {}
