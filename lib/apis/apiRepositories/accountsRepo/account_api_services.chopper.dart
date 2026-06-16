// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_api_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AccountApiServices extends AccountApiServices {
  _$AccountApiServices([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AccountApiServices;

  @override
  Future<Response<UserResponse>> getUserDetails() {
    final Uri $url = Uri.parse('https://abcuser.dmxchge.com/api/Account');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<UserResponse, UserResponse>($request);
  }

  @override
  Future<Response<MappedUserResponse>> getMappedUsers(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/mappedUser');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<MappedUserResponse, MappedUserResponse>($request);
  }

  @override
  Future<Response<DepositRequestResponse>> getDepositRequest(String? status) {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/creditRequest');
    final Map<String, dynamic> $params = <String, dynamic>{'status': status};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<DepositRequestResponse, DepositRequestResponse>($request);
  }

  @override
  Future<Response<WithdrawalRequestResponse>> getWithdrawalRequest(
      String? status) {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/creditRequest');
    final Map<String, dynamic> $params = <String, dynamic>{'status': status};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<WithdrawalRequestResponse, WithdrawalRequestResponse>($request);
  }

  @override
  Future<Response<TransactionsResponse>> getTransactions() {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/creditRequest');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<TransactionsResponse, TransactionsResponse>($request);
  }

  @override
  Future<Response<dynamic>> updateDepositAndWithdrawalRequest(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/creditResponse');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> depositAndWithdraw(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/depositWithdraw');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<AllUsersResponse>> getAllUsers(String? role) {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/getUsers');
    final Map<String, dynamic> $params = <String, dynamic>{'role': role};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<AllUsersResponse, AllUsersResponse>($request);
  }

  @override
  Future<Response<dynamic>> directFund({required Map<String, dynamic> body}) {
    final Uri $url = Uri.parse(
        'https://abcuser.dmxchge.com/api/Account/directdDepositWithdraw');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> resetPassword(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/resetPassword');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<SettlementResponse>> getSettlement() {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/selttlement');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<SettlementResponse, SettlementResponse>($request);
  }

  @override
  Future<ActivityLogsResponse> getUserActivityLogs(
      {required Map<String, dynamic> body}) async {
    final Uri $url =
        Uri.parse('https://abcuser.dmxchge.com/api/Account/activityLog');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    final Response $response =
        await client.send<ActivityLogsResponse, ActivityLogsResponse>($request);
    return $response.bodyOrThrow;
  }
}
