import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'log_service.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  static const String _tag = 'BLOC';

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      LogService.instance.debug(_tag, '${bloc.runtimeType} created');
    }
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      LogService.instance.info(_tag, '${bloc.runtimeType} event: $event');
    }
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      LogService.instance.debug(_tag, '${bloc.runtimeType}: ${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    LogService.instance.error(_tag, '${bloc.runtimeType} error', error: error, stackTrace: stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      LogService.instance.debug(_tag, '${bloc.runtimeType} closed');
    }
  }
}
