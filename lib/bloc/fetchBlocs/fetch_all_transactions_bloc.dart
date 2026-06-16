import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../apis/apiRepositories/accountsRepo/account_api_repository.dart';
import '../../model/transactions_model.dart';

class FetchTransactionsBloc extends Bloc<FetchTransactionsEvent, FetchTransactionsState> {
  final AccountApiRepository _accountApiRepository;
  FetchTransactionsBloc(this._accountApiRepository) : super(FetchTransactionsInitial()) {
    on<FetchTransactions>((event, emit) async {
      if (kDebugMode) debugPrint('Called FetchTransactionsBloc');
      emit(FetchTransactionsProgress());
      try {
        final Response<TransactionsResponse> response = await _accountApiRepository.getTransactions();
        if (response.statusCode == 200) {
          final transactions = response.body!.data;
          // if (kDebugMode) debugPrint("Decoded Response: $depositRequest");
          emit(FetchTransactionsSuccess(transactions: transactions));
        } else {
          if (kDebugMode) debugPrint("FetchTransactionsBloc - non 200 response ${response.statusCode}");
          emit(FetchTransactionsFailure("Non ${response.statusCode} Status"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FetchTransactionsBloc Catch Error $e');
        emit(FetchTransactionsFailure(e));
      }
    });
  }
}

//states
abstract class FetchTransactionsState {}

//events
abstract class FetchTransactionsEvent {}

//states implementation
class FetchTransactionsInitial extends FetchTransactionsState {}

class FetchTransactionsProgress extends FetchTransactionsState {}

class FetchTransactionsSuccess extends FetchTransactionsState {
  final List<Transactions> transactions;
  FetchTransactionsSuccess({required this.transactions});
}

class FetchTransactionsFailure extends FetchTransactionsState {
  final dynamic error;
  FetchTransactionsFailure(this.error);
}

//events implementation
class FetchTransactions extends FetchTransactionsEvent {}
