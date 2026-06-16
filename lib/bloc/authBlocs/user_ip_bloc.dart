import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../apis/apiHandlers/api_constants.dart';
import '../../constants/app_constant.dart';

class UserIPBloc extends Bloc<UserIPEvent, UserIPState> {
  UserIPBloc() : super(UserIPInitial()) {
    on<UserIP>((event, emit) async {
      emit(UserIPProgress());
      try {
        final responseIsp = await http.get(Uri.parse(AuthApiConstants.isp));
        final reposeIp = await http.get(Uri.parse(AuthApiConstants.ip));
        Map<String, dynamic> decodedIspData = {};
        if (responseIsp.statusCode == 200) {
          decodedIspData = jsonDecode(responseIsp.body);
        }
        Map<String, dynamic> decodedIPData = {};
        if (reposeIp.statusCode == 200) {
          decodedIPData = jsonDecode(reposeIp.body);
        }
        ip = ValueNotifier(decodedIPData['ip']);
        isp = ValueNotifier(decodedIspData['org']);
        agent = ValueNotifier(decodedIspData['region_code']);
        address = ValueNotifier(decodedIspData['country_name']);
        if (kDebugMode) debugPrint("user ip--${ip.value}");
        if (kDebugMode) debugPrint("user isp--${isp.value}");
        emit(UserIPSuccess());
      } catch (e) {
        debugPrint("USer Ip Error => $e");
        emit(UserIPFailure("USer Ip user"));
      }
    });
    on<SetLoginToInitial>((event, emit) async {
      emit(UserIPInitial());
    });
  }
}

//event
abstract class UserIPEvent {}

//state
abstract class UserIPState {}

//event impl
class UserIP extends UserIPEvent {}

//states impl
class UserIPInitial extends UserIPState {}

class UserIPProgress extends UserIPState {}

class UserIPSuccess extends UserIPState {}

class UserIPFailure extends UserIPState {
  final String error;
  UserIPFailure(this.error);
}

class SetLoginToInitial extends UserIPEvent {}
