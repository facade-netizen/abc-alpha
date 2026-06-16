import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiRepositories/authRepo/auth_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class AddNewUserBloc extends Bloc<AddNewUserEvent, AddNewUserState> {
  final AuthApiRepository _authApiRepository;
  AddNewUserBloc(this._authApiRepository) : super(AddNewUserInitial()) {
    on<AddNewUser>((event, emit) async {
      emit(AddNewUserProgress());
      debugPrint(" Called AddNewUserBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData != null) {
        try {
          event.addNewUserMap.addAll({"createdByUserId": savedData.userId});
          final response = await _authApiRepository.createNewUser(body: event.addNewUserMap);
          final responseData = response.body;
          final status = responseData["status"];
          final data = responseData["data"];
          if (status == 200) {
            emit(AddNewUserSuccess());
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            if (kDebugMode) debugPrint("Request failure >> $errorMsg");
            emit(AddNewUserFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("AddNewUserBloc [Catch Exception] >>error: $e");
          emit(AddNewUserFailure(e));
        }
      } else {
        emit(AddNewUserFailure("User not in"));
      }
    });
  }
}

//states
abstract class AddNewUserState {}

//events
abstract class AddNewUserEvent {}

//states implementation
class AddNewUserInitial extends AddNewUserState {}

class AddNewUserProgress extends AddNewUserState {}

class AddNewUserSuccess extends AddNewUserState {}

class AddNewUserFailure extends AddNewUserState {
  final dynamic error;
  AddNewUserFailure(this.error);
}

//events implementation
class AddNewUser extends AddNewUserEvent {
  AddNewUser({required this.addNewUserMap});
  final Map<String, dynamic> addNewUserMap;
}
