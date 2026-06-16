import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/mapped_user_model.dart';

class FetchMappedUsersBloc extends Bloc<FetchMappedUsersEvent, FetchMappedUsersState> {
  final AccountApiRepository _accountApiRepository;
  FetchMappedUsersBloc(this._accountApiRepository) : super(FetchMappedUsersInitial()) {
    on<FetchMappedUsers>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchMappedUsersBloc');
      emit(FetchMappedUsersProgress());
      try {
        SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
        if (savedData != null) {
          final Response<MappedUserResponse> response = await _accountApiRepository.getMappedUsers(
            body: {"userId": event.userId ?? savedData.userId, "userName": event.userName ?? "", "page": event.pageNumber, "limit": event.pageSize},
          );
          final decoded = jsonDecode(response.bodyString);
          if (response.statusCode == 200) {
            List<MappedUserDetails> mappedUsersData = response.body!.data ?? [];
            emit(FetchMappedUsersSuccess(mappedUsersData: mappedUsersData, pageNumber: event.pageNumber ?? 1, totalPages: response.body!.totalPages));
          } else if (decoded["status"] == 400) {
            if (kDebugMode) debugPrint("${decoded["message"]}");
            emit(FetchMappedUsersFailure("${decoded["message"]}"));
          } else {
            if (kDebugMode) debugPrint("FetchMappedUsersBloc - non 200 response ${response.statusCode}");
            emit(FetchMappedUsersFailure("Non ${response.statusCode} Status"));
          }
        } else {
          if (kDebugMode) debugPrint("User Not Logged in");
          emit(FetchMappedUsersFailure("User Not Logged in"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Catch Error >>>  $e');
        emit(FetchMappedUsersFailure(e));
      }
    });
  }
}

//states
abstract class FetchMappedUsersState {}

//events
abstract class FetchMappedUsersEvent {}

//states implementation
class FetchMappedUsersInitial extends FetchMappedUsersState {}

class FetchMappedUsersProgress extends FetchMappedUsersState {}

class FetchMappedUsersSuccess extends FetchMappedUsersState {
  final List<MappedUserDetails> mappedUsersData;
  final int pageNumber;
  final int totalPages;
  FetchMappedUsersSuccess({required this.mappedUsersData, required this.pageNumber, required this.totalPages});
}

class FetchMappedUsersFailure extends FetchMappedUsersState {
  final dynamic error;
  FetchMappedUsersFailure(this.error);
}

//events implementation
class FetchMappedUsers extends FetchMappedUsersEvent {
  final String? userId;
  final String? userName;
  final int? pageNumber;
  final int? pageSize;
  FetchMappedUsers({this.userId, this.userName, this.pageNumber, this.pageSize});
}
