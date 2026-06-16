import 'dart:async';
import 'package:flutter/foundation.dart';
import '../bloc/authBlocs/user_changed_bloc.dart';

/// Bridges [UserAuthChangesBloc] stream → [ChangeNotifier] for GoRouter's
/// `refreshListenable`. When auth state changes (login success, logout,
/// token expiry), GoRouter re-evaluates its redirect callback.
class AuthNotifier extends ChangeNotifier {
  late final StreamSubscription<UserAuthChangesState> _subscription;

  AuthNotifier(UserAuthChangesBloc bloc) {
    _subscription = bloc.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
