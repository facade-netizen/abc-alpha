import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../model/user_details_model.dart';

class FetchCurrentUserDetailsBloc extends Bloc<FetchCurrentUserDetailsEvent, FetchCurrentUserDetailsState> {
  final AccountApiRepository _accountApiRepository;
  FetchCurrentUserDetailsBloc(this._accountApiRepository) : super(FetchCurrentUserDetailsInitial()) {
    on<FetchCurrentUserDetails>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchCurrentUserDetailsBloc');
      emit(FetchCurrentUserDetailsProgress());
      try {
        final Response<UserResponse> response = await _accountApiRepository.getUserDetails();
        if (response.statusCode == 200) {
          UserDetails userDetails = response.body!.data;
          emit(FetchCurrentUserDetailsSuccess(userDetails: userDetails));
        } else {
          if (kDebugMode) debugPrint("FetchCurrentUserDetailsBloc - non 200 response ${response.statusCode}");
          emit(FetchCurrentUserDetailsFailure("Non ${response.statusCode} Status"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FetchCurrentUserDetailsBloc Catch Error $e');
        emit(FetchCurrentUserDetailsFailure(e));
      }
    });
  }
}

//states
abstract class FetchCurrentUserDetailsState {}

//events
abstract class FetchCurrentUserDetailsEvent {}

//states implementation
class FetchCurrentUserDetailsInitial extends FetchCurrentUserDetailsState {}

class FetchCurrentUserDetailsProgress extends FetchCurrentUserDetailsState {}

class FetchCurrentUserDetailsSuccess extends FetchCurrentUserDetailsState {
  final UserDetails userDetails;
  FetchCurrentUserDetailsSuccess({required this.userDetails});
}

class FetchCurrentUserDetailsFailure extends FetchCurrentUserDetailsState {
  final dynamic error;
  FetchCurrentUserDetailsFailure(this.error);
}

//events implementation
class FetchCurrentUserDetails extends FetchCurrentUserDetailsEvent {}
