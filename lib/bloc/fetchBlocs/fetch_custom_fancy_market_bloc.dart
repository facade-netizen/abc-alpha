import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/settleManageRepo/ms_api_repository.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/custom_fancy_market_model.dart';

class FetchCustomFancyMarketBloc extends Bloc<FetchCustomFancyMarketEvent, FetchCustomFancyMarketState> {
  final SettleApiRepository _settleApiRepository;
  FetchCustomFancyMarketBloc(this._settleApiRepository) : super(FetchCustomFancyMarketInitial()) {
    on<FetchCustomFancyMarket>((event, emit) async {
      emit(FetchCustomFancyMarketProgress());
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedTokenData != null) {
        try {
          final Response<CustomFancyMarketResponse> response = await _settleApiRepository.getCustomMarket(event.eventId);
          if (response.statusCode == 200) {
            final customMarketDate = response.body!.data;
            // if (kDebugMode) debugPrint("Decoded Response: $customMarketDate");
            emit(FetchCustomFancyMarketSuccess(customMarketDate: customMarketDate));
          } else {
            if (kDebugMode) debugPrint("FetchCustomFancyMarketBloc - non 200 response ${response.statusCode}");
            emit(FetchCustomFancyMarketFailure("Non ${response.statusCode} Status"));
          }
        } catch (e) {
          if (kDebugMode) debugPrint("Error caught in FetchCustomFancyMarketBloc,$e");
          emit(FetchCustomFancyMarketFailure(e));
        }
      } else {
        if (kDebugMode) debugPrint("User Not Logged In");
        emit(FetchCustomFancyMarketFailure("User Not Logged In"));
      }
    });
  }
}

//states
abstract class FetchCustomFancyMarketState {}

//events
abstract class FetchCustomFancyMarketEvent {}

//states implementation
class FetchCustomFancyMarketInitial extends FetchCustomFancyMarketState {}

class FetchCustomFancyMarketProgress extends FetchCustomFancyMarketState {}

class FetchCustomFancyMarketSuccess extends FetchCustomFancyMarketState {
  FetchCustomFancyMarketSuccess({required this.customMarketDate});
  final List<CustomMarket> customMarketDate;
}

class FetchCustomFancyMarketFailure extends FetchCustomFancyMarketState {
  final dynamic error;
  FetchCustomFancyMarketFailure(this.error);
}

//events implementation
class FetchCustomFancyMarket extends FetchCustomFancyMarketEvent {
  FetchCustomFancyMarket({required this.eventId});
  final int eventId;
}
