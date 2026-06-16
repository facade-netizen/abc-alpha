import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/fancy_catalouges_on_markettype_model.dart';

class AddNewFancyMarketBloc extends Bloc<AddNewFancyMarketEvent, AddNewFancyMarketState> {
  final EMApiRepository _emApiRepository;
  AddNewFancyMarketBloc(this._emApiRepository) : super(AddNewFancyMarketInitial()) {
    on<AddNewFancyMarket>((event, emit) async {
      if (kDebugMode) debugPrint('Called AddNewFancyMarketBloc');
      emit(AddNewFancyMarketProgress());
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;

      if (savedData != null) {
        try {
          final Map<String, dynamic> finalUpdateMap = {};
          finalUpdateMap.addAll(event.addNewFancyMap);
          finalUpdateMap.addAll({"createdBy": savedData.userName});
          final response = await _emApiRepository.createFancy(body: finalUpdateMap);
          final responseData = response.body;
          debugPrint("AddNewFancyMarketBloc [API Response] >> $responseData");
          final status = responseData["status"];
          final data = responseData["data"];
          debugPrint("AddNewFancyMarketBloc status >> $status");
          debugPrint("AddNewFancyMarketBloc data [API Response] >> $data");

          if (status == 200) {
            emit(AddNewFancyMarketSuccess(createdMarket: FancyCatalougesOnMarketType.fromJson(data)));
          } else {
            final errorMsg = data is String ? data : "Something went wrong";
            if (kDebugMode) debugPrint("Request failure >> $errorMsg");
            emit(AddNewFancyMarketFailure(errorMsg));
          }
        } catch (e) {
          debugPrint("AddNewFancyMarketBloc [Catch Exception] >> $e");
          emit(AddNewFancyMarketFailure(e));
        }
      } else {
        emit(AddNewFancyMarketFailure("User not logged in"));
      }
    });
  }
}

//states
abstract class AddNewFancyMarketState {}

//events
abstract class AddNewFancyMarketEvent {}

//states implementation
class AddNewFancyMarketInitial extends AddNewFancyMarketState {}

class AddNewFancyMarketProgress extends AddNewFancyMarketState {}

class AddNewFancyMarketSuccess extends AddNewFancyMarketState {
  AddNewFancyMarketSuccess({required this.createdMarket});
  final FancyCatalougesOnMarketType createdMarket;
}

class AddNewFancyMarketFailure extends AddNewFancyMarketState {
  final dynamic error;
  AddNewFancyMarketFailure(this.error);
}

//events implementation
class AddNewFancyMarket extends AddNewFancyMarketEvent {
  AddNewFancyMarket({required this.addNewFancyMap});
  final Map<String, dynamic> addNewFancyMap;
}
