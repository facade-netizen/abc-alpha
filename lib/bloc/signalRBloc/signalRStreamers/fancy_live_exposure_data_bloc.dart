import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/live_fancy_bet_exposure_model.dart';
import '../signalr_hub_listener_bloc.dart';

class FancyLiveBetExposureBloc extends Bloc<FancyLiveBetExposureEvent, FancyLiveBetExposureState> {
  FancyLiveBetExposureBloc() : super(FancyLiveBetExposureInitial()) {
    on<FancyLiveBetExposureListener>((event, emit) async {
      if (kDebugMode) debugPrint("FancyLiveBetExposureListener started");
      emit(FancyLiveBetExposureProgress());

      try {
        await emit.forEach<FancyLiveBetExposure>(
          fblExpStream,
          onData: (msg) {
            return FancyLiveBetExposureSuccess(msg);
          },
          onError: (error, stackTrace) {
            if (kDebugMode) debugPrint("Account SignalR Error: $error");
            return FancyLiveBetExposureFailure(error);
          },
        );
      } catch (e) {
        if (kDebugMode) debugPrint('Error in FancyLiveBetExposureBloc: $e');
        emit(FancyLiveBetExposureFailure(e));
      }
    });

    on<SetToInitialFancyLiveBetExposure>((event, emit) async {
      emit(FancyLiveBetExposureInitial());
    });
  }
}

//states
abstract class FancyLiveBetExposureState {}

//events
abstract class FancyLiveBetExposureEvent {}

//states implementation
class FancyLiveBetExposureInitial extends FancyLiveBetExposureState {}

class FancyLiveBetExposureProgress extends FancyLiveBetExposureState {}

class FancyLiveBetExposureSuccess extends FancyLiveBetExposureState {
  FancyLiveBetExposureSuccess(this.fancyLiveBetExposure);
  final FancyLiveBetExposure fancyLiveBetExposure;
}

class FancyLiveBetExposureFailure extends FancyLiveBetExposureState {
  final dynamic error;
  FancyLiveBetExposureFailure(this.error);
}

//events implementation
class FancyLiveBetExposureListener extends FancyLiveBetExposureEvent {}

class SetToInitialFancyLiveBetExposure extends FancyLiveBetExposureEvent {}
