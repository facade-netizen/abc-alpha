import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/fancy_catalouges_on_markettype_model.dart';
import '../signalr_event_listener_bloc.dart';

class SignalRFancyMarketDataBloc extends Bloc<SignalRFancyMarketDataEvent, SignalRFancyMarketDataState> {
  final List<FancyCatalougesOnMarketType> fancyList = [];
  StreamSubscription<FancyCatalougesOnMarketType>? _subscription;
  SignalRFancyMarketDataBloc() : super(SignalRFancyMarketDataInitial()) {
    on<SignalRFancyMarketDataListener>(_onListen);
    on<_EmitFancyInternal>(_onEmitFancy);
    on<_EmitFancyErrorInternal>(_onEmitFancyError);
    on<SetToInitialSignalRFancy>(_onReset);
  }
  Future<void> _onListen(SignalRFancyMarketDataListener event, Emitter<SignalRFancyMarketDataState> emit) async {
    if (kDebugMode) debugPrint("SignalRFancyMarketDataListener started");
    await _subscription?.cancel();
    fancyList.clear();
    emit(SignalRFancyMarketDataProgress());
    _subscription = fancyMarketStream.listen(
      (line) {
        if (line.marketId == "_288245029801984") {
          debugPrint('_288245029801984: ${line.fancyMarketCondition?.maxBet} ${line.fancyMarketCondition?.minBet} ${line.fancyMarketCondition?.betDelay}');
        }
        // if (kDebugMode) {
        //   for (var r in line.runners) {
        //     debugPrint(
        //       "hsgdadghsadfh"
        //       "Event:${line.eventId} "
        //       "Market:${line.marketId} "
        //       "Status:${line.status} "
        //       "Sport:${line.sportingEvent} "
        //       "Runner:${r.id} "
        //       "Back1:${r.backs.isNotEmpty ? r.backs.first.price : '-'} "
        //       "BackLine1:${r.backs.isNotEmpty ? r.backs.first.line : '-'} "
        //       "Lay1:${r.lays.isNotEmpty ? r.lays.first.price : '-'} "
        //       "LayLine1:${r.lays.isNotEmpty ? r.lays.first.line : '-'}",
        //     );
        //   }
        // }
        final index = fancyList.indexWhere((f) => f.marketId == line.marketId);
        bool changed = false;
        if (index != -1) {
          final old = fancyList[index];
          if (_hasChanged(old, line)) {
            fancyList[index] = line;
            changed = true;
          }
        } else {
          fancyList.insert(0, line);
          changed = true;
        }
        if (changed) {
          add(_EmitFancyInternal(List<FancyCatalougesOnMarketType>.from(fancyList)));
        }
      },
      onError: (e) {
        add(_EmitFancyErrorInternal(e));
      },
    );
  }

  void _onEmitFancy(_EmitFancyInternal event, Emitter<SignalRFancyMarketDataState> emit) {
    emit(SignalRFancyMarketDataSuccess(event.catalogues));
  }

  void _onEmitFancyError(_EmitFancyErrorInternal event, Emitter<SignalRFancyMarketDataState> emit) {
    emit(SignalRFancyMarketDataFailure(event.error));
  }

  Future<void> _onReset(SetToInitialSignalRFancy event, Emitter<SignalRFancyMarketDataState> emit) async {
    await _subscription?.cancel();
    _subscription = null;
    fancyList.clear();
    emit(SignalRFancyMarketDataInitial());
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

abstract class SignalRFancyMarketDataEvent {}

class SignalRFancyMarketDataListener extends SignalRFancyMarketDataEvent {}

class SetToInitialSignalRFancy extends SignalRFancyMarketDataEvent {}

class _EmitFancyInternal extends SignalRFancyMarketDataEvent {
  final List<FancyCatalougesOnMarketType> catalogues;
  _EmitFancyInternal(this.catalogues);
}

class _EmitFancyErrorInternal extends SignalRFancyMarketDataEvent {
  final dynamic error;
  _EmitFancyErrorInternal(this.error);
}

//
// STATES
//

abstract class SignalRFancyMarketDataState {}

class SignalRFancyMarketDataInitial extends SignalRFancyMarketDataState {}

class SignalRFancyMarketDataProgress extends SignalRFancyMarketDataState {}

class SignalRFancyMarketDataSuccess extends SignalRFancyMarketDataState {
  final List<FancyCatalougesOnMarketType> fancyCatalogues;
  SignalRFancyMarketDataSuccess(this.fancyCatalogues);
}

class SignalRFancyMarketDataFailure extends SignalRFancyMarketDataState {
  final dynamic error;
  SignalRFancyMarketDataFailure(this.error);
}
