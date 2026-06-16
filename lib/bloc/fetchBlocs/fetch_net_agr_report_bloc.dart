import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/ordersRepo/orders_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/net_aggregated_reports_model.dart';

class FetchNetAggrtReportBloc extends Bloc<FetchNetAggrtReportEvent, FetchNetAggrtReportState> {
  final OrdersApiRepository _ordersApiRepository;
  FetchNetAggrtReportBloc(this._ordersApiRepository) : super(FetchNetAggrtReportInitial()) {
    on<FetchNetAggrtReport>((event, emit) async {
      emit(FetchNetAggrtReportProgress());
      if (kDebugMode) debugPrint('Called FetchNetAggrtReportBloc');
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          final Response<NetAggregatedResponse> response = await _ordersApiRepository.getNAReport();
          if (response.statusCode == 200) {
            final naReports = response.body!.data;
            emit(FetchNetAggrtReportSuccess(naReports: naReports));
          } else {
            if (kDebugMode) debugPrint("FetchNetAggrtReportBloc - None 200 response ${response.statusCode}");
            emit(FetchNetAggrtReportFailure("FetchNetAggrtReportBloc - None  ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint('FetchNetAggrtReportBloc Catch Error >>>  $e');
          emit(FetchNetAggrtReportFailure(e));
        }
      } else {
        emit(FetchNetAggrtReportFailure("User Not Logged in"));
      }
    });
  }
}

//states
abstract class FetchNetAggrtReportState {}

//events
abstract class FetchNetAggrtReportEvent {}

//states implementation
class FetchNetAggrtReportInitial extends FetchNetAggrtReportState {}

class FetchNetAggrtReportProgress extends FetchNetAggrtReportState {}

class FetchNetAggrtReportSuccess extends FetchNetAggrtReportState {
  final List<NetAggregatedData> naReports;
  FetchNetAggrtReportSuccess({required this.naReports});
}

class FetchNetAggrtReportFailure extends FetchNetAggrtReportState {
  final dynamic error;
  FetchNetAggrtReportFailure(this.error);
}

//events implementation
class FetchNetAggrtReport extends FetchNetAggrtReportEvent {}
