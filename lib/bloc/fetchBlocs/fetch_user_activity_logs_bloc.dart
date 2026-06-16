import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/activity_log_model.dart';

class FetchUserActivityLogsBloc extends Bloc<FetchUserActivityLogsEvent, FetchUserActivityLogsState> {
  final AccountApiRepository _accountApiRepository;
  FetchUserActivityLogsBloc(this._accountApiRepository) : super(FetchUserActivityLogsInitial()) {
    on<FetchUserActivityLogs>((event, emit) async {
      emit(FetchUserActivityLogsProgress());
      debugPrint("Called FetchUserActivityLogsBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      try {
        if (savedData != null) {
          int limit = event.limit ?? 25;
          int page = event.page ?? 1;

          Map<String, dynamic> userActivityLogsMap = {"userName": event.userId, "from": event.from, "to": event.to, "limit": limit, "page": page};
          final response = await _accountApiRepository.getUserActivityLogs(body: userActivityLogsMap);
          if (response.status == "success") {
            // if (kDebugMode) debugPrint(response.data.toString());
            emit(FetchUserActivityLogsSuccess(activityLogsResponse: response));
          } else {
            if (kDebugMode) debugPrint("fetch_user_activity_logs_bloc.dart [response error]>> \\${response.status}");
            emit(FetchUserActivityLogsFailure('fetch_user_activity_logs_bloc.dart [response error]>> \\${response.status}'));
          }
        } else {
          emit(FetchUserActivityLogsFailure("User not in"));
        }
      } catch (e) {
        debugPrint("fetch_user_activity_logs_bloc.dart 1 [Platform Exception] >>error: $e");
        emit(FetchUserActivityLogsFailure(e));
      }
    });
     on<FetchUserActivityLogsInt>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchUserActivityLogsInt');
      emit(FetchUserActivityLogsInitial());
    });
  }
}

//states
abstract class FetchUserActivityLogsState {}

//events
abstract class FetchUserActivityLogsEvent {}

//states implementation
class FetchUserActivityLogsInitial extends FetchUserActivityLogsState {}

class FetchUserActivityLogsProgress extends FetchUserActivityLogsState {}

class FetchUserActivityLogsSuccess extends FetchUserActivityLogsState {
  final ActivityLogsResponse activityLogsResponse;
  FetchUserActivityLogsSuccess({required this.activityLogsResponse});
}

class FetchUserActivityLogsFailure extends FetchUserActivityLogsState {
  final dynamic error;
  FetchUserActivityLogsFailure(this.error);
}

// events implementation
class FetchUserActivityLogs extends FetchUserActivityLogsEvent {
  String? userId;
  String? from;
  String? to;
  int? limit;
  int? page;

  FetchUserActivityLogs({this.userId, this.from, this.to, this.limit, this.page});
}
class FetchUserActivityLogsInt extends FetchUserActivityLogsEvent {}
