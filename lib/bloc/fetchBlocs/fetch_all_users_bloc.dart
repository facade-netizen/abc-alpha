import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../model/all_users_model.dart';

class FetchAllUsersBloc extends Bloc<FetchAllUsersEvent, FetchAllUsersState> {
  final AccountApiRepository _accountApiRepository;
  FetchAllUsersBloc(this._accountApiRepository) : super(FetchAllUsersInitial()) {
    on<FetchAllUsers>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchAllUsersBloc');
      emit(FetchAllUsersProgress());
      try {
        final Response<AllUsersResponse> response = await _accountApiRepository.getAllUsers(event.role);
        if (response.statusCode == 200) {
          final users = response.body!.data;
          // if (kDebugMode) debugPrint("Decoded Response: $depositRequest");
          emit(FetchAllUsersSuccess(users: users));
        } else {
          if (kDebugMode) debugPrint("FetchAllUsersBloc - non 200 response ${response.statusCode}");
          emit(FetchAllUsersFailure("Non ${response.statusCode} Status"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FetchAllUsersBloc Catch Error $e');
        emit(FetchAllUsersFailure(e));
      }
    });
  }
}

//states
abstract class FetchAllUsersState {}

//events
abstract class FetchAllUsersEvent {}

//states implementation
class FetchAllUsersInitial extends FetchAllUsersState {}

class FetchAllUsersProgress extends FetchAllUsersState {}

class FetchAllUsersSuccess extends FetchAllUsersState {
  final List<AllUserData> users;
  FetchAllUsersSuccess({required this.users});
}

class FetchAllUsersFailure extends FetchAllUsersState {
  final dynamic error;
  FetchAllUsersFailure(this.error);
}

//events implementation
class FetchAllUsers extends FetchAllUsersEvent {
  final String role;
  FetchAllUsers({required this.role});
}
