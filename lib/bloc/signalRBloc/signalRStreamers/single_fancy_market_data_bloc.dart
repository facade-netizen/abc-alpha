import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/fancy_catalouges_on_markettype_model.dart';
import '../signalr_single_market_listener_bloc.dart';

class SignalRSingleFancyMarketDataBloc extends Bloc<SignalRSingleFancyMarketDataEvent, SignalRSingleFancyMarketDataState> {
  StreamSubscription<FancyCatalougesOnMarketType>? _subscription;
  FancyCatalougesOnMarketType? _lastFancy;

  SignalRSingleFancyMarketDataBloc() : super(SignalRSingleFancyMarketDataInitial()) {
    on<SignalRSingleFancyMarketDataListener>(_onListen);
    on<_EmitSingleFancyMarketData>(_onEmitFancy);
    on<_EmitSingleFancyMarketDataFailure>(_onEmitError);
    on<SetToInitialSignalRFancy>(_onReset);
  }

  Future<void> _onListen(SignalRSingleFancyMarketDataListener event, Emitter<SignalRSingleFancyMarketDataState> emit) async {
    if (kDebugMode) debugPrint("SignalRSingleFancyMarketDataListener started");
    await _subscription?.cancel();
    _lastFancy = null;
    emit(SignalRSingleFancyMarketDataProgress());

    _subscription = fancySingleMarketStream.listen(
      (line) {
        if (_lastFancy == null || _hasChanged(_lastFancy!, line)) {
          _lastFancy = line;
          // if (kDebugMode) {
          //   log("Main  EventId ${_lastFancy!.eventId} Market ${_lastFancy!.marketId} Status ${_lastFancy!.status}  } ");
          // }
          add(_EmitSingleFancyMarketData(line));
        }
      },
      onError: (e) {
        add(_EmitSingleFancyMarketDataFailure(e));
      },
    );
  }

  void _onEmitFancy(_EmitSingleFancyMarketData event, Emitter<SignalRSingleFancyMarketDataState> emit) {
    emit(SignalRSingleFancyMarketDataSuccess(event.fancyCatalogue));
  }

  void _onEmitError(_EmitSingleFancyMarketDataFailure event, Emitter<SignalRSingleFancyMarketDataState> emit) {
    emit(SignalRSingleFancyMarketDataFailure(event.error));
  }

  Future<void> _onReset(SetToInitialSignalRFancy event, Emitter<SignalRSingleFancyMarketDataState> emit) async {
    await _subscription?.cancel();
    _subscription = null;
    _lastFancy = null;
    emit(SignalRSingleFancyMarketDataInitial());
  }

  bool _hasChanged(FancyCatalougesOnMarketType old, FancyCatalougesOnMarketType updated) {
    if (old.status != updated.status) return true;
    if (old.sportingEvent != updated.sportingEvent) return true;
    if (old.runners.length != updated.runners.length) return true;
    if (old.fancyMarketCondition != updated.fancyMarketCondition) return true;
    for (int i = 0; i < old.runners.length; i++) {
      final o = old.runners[i];
      final u = updated.runners[i];

      // Determine max indices to check (up to 3)
      final maxBackIndex = [o.backs.length, u.backs.length, 3].reduce((a, b) => a < b ? a : b);
      final maxLayIndex = [o.lays.length, u.lays.length, 3].reduce((a, b) => a < b ? a : b);

      // Check backs
      for (int j = 0; j < maxBackIndex; j++) {
        final oldBackPrice = o.backs[j].price;
        final oldBackLine = o.backs[j].line;
        final newBackPrice = u.backs[j].price;
        final newBackLine = u.backs[j].line;

        if (oldBackPrice != newBackPrice || oldBackLine != newBackLine) {
          return true;
        }
      }

      // Check lays
      for (int j = 0; j < maxLayIndex; j++) {
        final oldLayPrice = o.lays[j].price;
        final oldLayLine = o.lays[j].line;
        final newLayPrice = u.lays[j].price;
        final newLayLine = u.lays[j].line;

        if (oldLayPrice != newLayPrice || oldLayLine != newLayLine) {
          return true;
        }
      }
    }

    return false;
  }

  // ---------------- DISPOSE ----------------

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

//
// EVENTS
//

abstract class SignalRSingleFancyMarketDataEvent {}

class SignalRSingleFancyMarketDataListener extends SignalRSingleFancyMarketDataEvent {}

class _EmitSingleFancyMarketData extends SignalRSingleFancyMarketDataEvent {
  final FancyCatalougesOnMarketType fancyCatalogue;
  _EmitSingleFancyMarketData(this.fancyCatalogue);
}

class _EmitSingleFancyMarketDataFailure extends SignalRSingleFancyMarketDataEvent {
  final dynamic error;
  _EmitSingleFancyMarketDataFailure(this.error);
}

class SetToInitialSignalRFancy extends SignalRSingleFancyMarketDataEvent {}

//
// STATES
//

abstract class SignalRSingleFancyMarketDataState {}

class SignalRSingleFancyMarketDataInitial extends SignalRSingleFancyMarketDataState {}

class SignalRSingleFancyMarketDataProgress extends SignalRSingleFancyMarketDataState {}

class SignalRSingleFancyMarketDataSuccess extends SignalRSingleFancyMarketDataState {
  final FancyCatalougesOnMarketType fancyCatalogue;
  SignalRSingleFancyMarketDataSuccess(this.fancyCatalogue);
}

class SignalRSingleFancyMarketDataFailure extends SignalRSingleFancyMarketDataState {
  final dynamic error;
  SignalRSingleFancyMarketDataFailure(this.error);
}
