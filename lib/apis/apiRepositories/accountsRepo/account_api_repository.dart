import 'package:chopper/chopper.dart';

import '../../../model/activity_log_model.dart';
import '../../../model/all_users_model.dart';
import '../../../model/deposit_request_model.dart';
import '../../../model/mapped_user_model.dart';
import '../../../model/settlement_model.dart';
import '../../../model/transactions_model.dart';
import '../../../model/user_details_model.dart';
import '../../../model/withdrawal_request_model.dart';
import 'account_api_services.dart';

class AccountApiRepository {
  AccountApiRepository() : _accountApiServices = AccountApiServices.create();
  final AccountApiServices _accountApiServices;

  Future<Response<UserResponse>> getUserDetails() async {
    try {
      return _accountApiServices.getUserDetails();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<MappedUserResponse>> getMappedUsers({required Map<String, dynamic> body}) async {
    try {
      return _accountApiServices.getMappedUsers(body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<DepositRequestResponse>> getDepositRequest(@Query("status") String? status) async {
    try {
      return _accountApiServices.getDepositRequest(status);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<WithdrawalRequestResponse>> getWithdrawalRequest(@Query("status") String? status) async {
    try {
      return _accountApiServices.getWithdrawalRequest(status);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<TransactionsResponse>> getTransactions() async {
    try {
      return _accountApiServices.getTransactions();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateDepositAndWithdrawalRequest({required Map<String, dynamic> body}) async {
    try {
      return _accountApiServices.updateDepositAndWithdrawalRequest(body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> depositAndWithdraw({required Map<String, dynamic> body}) async {
    try {
      return _accountApiServices.depositAndWithdraw(body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<AllUsersResponse>> getAllUsers(@Query("role") String? role) async {
    try {
      return _accountApiServices.getAllUsers(role);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> directFund({required Map<String, dynamic> body}) async {
    return await _accountApiServices.directFund(body: body);
  }

  Future<Response> resetPassword({required Map<String, dynamic> body}) async {
    return await _accountApiServices.resetPassword(body: body);
  }

  Future<Response<SettlementResponse>> getSettlement() async {
    try {
      return _accountApiServices.getSettlement();
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityLogsResponse> getUserActivityLogs({required Map<String, dynamic> body}) async {
    return await _accountApiServices.getUserActivityLogs(body: body);
  }
}
