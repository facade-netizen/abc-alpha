import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../apis/apiHandlers/api_constants.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/wl_report_model.dart';

class FetchWLNetReportsBloc extends Bloc<FetchWLNetReportsEvent, FetchWLNetReportsState> {
  FetchWLNetReportsBloc() : super(FetchWLNetReportsInitial()) {
    on<FetchWLNetReports>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchWLNetReportsBloc');
      emit(FetchWLNetReportsProgress());

      // check authentication
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;

      if (savedTokenData != null) {
        try {
          final response = await http.get(Uri.parse(WlApiConstants.wlnet), headers: {'Authorization': 'Bearer ${savedTokenData.token}', 'Content-Type': 'application/json'});
          if (response.statusCode == 200) {
            final Map<String, dynamic> jsonData = json.decode(response.body);
            final WLNetReportsResponse parsedResponse = WLNetReportsResponse.fromJson(jsonData);
            emit(FetchWLNetReportsSuccess(wlNetReports: parsedResponse.data));
          } else {
            if (kDebugMode) debugPrint("FetchWLNetReportsBloc None 200 >> ${response.statusCode}");
            emit(FetchWLNetReportsFailure('FetchWLNetReportsBloc None 200 [response error]>> ${response.statusCode}'));
          }
        } catch (e) {
          if (kDebugMode) debugPrint('FetchWLNetReportsBloc Exception >> $e');
          emit(FetchWLNetReportsFailure(e.toString()));
        }
      } else {
        emit(FetchWLNetReportsFailure('User not logged in'));
      }
    });
  }
}

// States
abstract class FetchWLNetReportsState {}

class FetchWLNetReportsInitial extends FetchWLNetReportsState {}

class FetchWLNetReportsProgress extends FetchWLNetReportsState {}

class FetchWLNetReportsSuccess extends FetchWLNetReportsState {
  FetchWLNetReportsSuccess({required this.wlNetReports});
  final List<WLNetReports> wlNetReports;
}

class FetchWLNetReportsFailure extends FetchWLNetReportsState {
  FetchWLNetReportsFailure(this.error);
  final dynamic error;
}

// Events
abstract class FetchWLNetReportsEvent {}

class FetchWLNetReports extends FetchWLNetReportsEvent {}
