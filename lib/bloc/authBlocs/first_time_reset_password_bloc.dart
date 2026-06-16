import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiHandlers/api_constants.dart';

class FirstTimeResetPasswordBloc extends Bloc<FirstTimeResetPasswordEvent, FirstTimeResetPasswordState> {
  FirstTimeResetPasswordBloc() : super(FirstTimeResetPasswordInitial()) {
    on<FirstTimeResetPassword>((event, emit) async {
      emit(FirstTimeResetPasswordProgress());
      debugPrint(" Called FirstTimeResetPasswordBloc");
      try {
        final response = await http.post(Uri.parse(AuthApiConstants.resetPassword), headers: {'Content-Type': 'application/json'}, body: jsonEncode(event.firstTimeResetPassword));
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final data = decoded["data"];
          if (decoded["status"] == 200) {
            final data = decoded["data"];
            emit(FirstTimeResetPasswordSuccess(userName: data["username"], password: data["password"]));
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            if (kDebugMode) debugPrint("Request failure >> $errorMsg");
            emit(FirstTimeResetPasswordFailure(errorMsg));
          }
        } else {
          emit(FirstTimeResetPasswordFailure("${response.reasonPhrase}"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint("FirstTimeResetPasswordBloc [Catch Exception] >>error: $e");
        emit(FirstTimeResetPasswordFailure(e));
      }
    });
  }
}

//states
abstract class FirstTimeResetPasswordState {}

//events
abstract class FirstTimeResetPasswordEvent {}

//states implementation
class FirstTimeResetPasswordInitial extends FirstTimeResetPasswordState {}

class FirstTimeResetPasswordProgress extends FirstTimeResetPasswordState {}

class FirstTimeResetPasswordSuccess extends FirstTimeResetPasswordState {
  FirstTimeResetPasswordSuccess({required this.userName, required this.password});
  final String userName;
  final String password;
}

class FirstTimeResetPasswordFailure extends FirstTimeResetPasswordState {
  final dynamic error;
  FirstTimeResetPasswordFailure(this.error);
}

//events implementation
class FirstTimeResetPassword extends FirstTimeResetPasswordEvent {
  FirstTimeResetPassword({required this.firstTimeResetPassword});
  final Map<String, dynamic> firstTimeResetPassword;
}
