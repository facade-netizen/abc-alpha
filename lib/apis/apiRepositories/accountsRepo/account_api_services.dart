import 'package:chopper/chopper.dart';

import '../../../model/activity_log_model.dart';
import '../../../model/all_users_model.dart';
import '../../../model/deposit_request_model.dart';
import '../../../model/mapped_user_model.dart';
import '../../../model/settlement_model.dart';
import '../../../model/transactions_model.dart';
import '../../../model/user_details_model.dart';
import '../../../model/withdrawal_request_model.dart';
import '../../apiHandlers/api_constants.dart';
import '../../apiHandlers/api_interceptors.dart';
import '../../apiHandlers/json_to_type_converter.dart';

part 'account_api_services.chopper.dart';

final _accountApiClient = ChopperClient(
  baseUrl: Uri.parse(AccountApiConstants.baseUrl),
  converter: JsonSerializableConverter({
    UserResponse: (json) => UserResponse.fromJson(json),
    AllUsersResponse: (json) => AllUsersResponse.fromJson(json),
    MappedUserResponse: (json) => MappedUserResponse.fromJson(json),
    SettlementResponse: (json) => SettlementResponse.fromJson(json),
    ActivityLogsResponse: (json) => ActivityLogsResponse.fromJson(json),
    TransactionsResponse: (json) => TransactionsResponse.fromJson(json),
    DepositRequestResponse: (json) => DepositRequestResponse.fromJson(json),
    WithdrawalRequestResponse: (json) => WithdrawalRequestResponse.fromJson(json),
  }),
  interceptors: [ApiAuthInterceptor(), ApiResponseInterceptor(), ApiRequestInterceptor()],
  errorConverter: const JsonConverter(),
);

@ChopperApi(baseUrl: AccountApiConstants.baseUrl)
abstract class AccountApiServices extends ChopperService {
  ///Don't modify
  static AccountApiServices create() {
    return _$AccountApiServices(_accountApiClient);
  }

  @GET(path: AccountApiConstants.account)
  Future<Response<UserResponse>> getUserDetails();

  @POST(path: AccountApiConstants.mappedUser)
  Future<Response<MappedUserResponse>> getMappedUsers({@Body() required Map<String, dynamic> body});

  @GET(path: AccountApiConstants.creditRequest)
  Future<Response<DepositRequestResponse>> getDepositRequest(@Query("status") String? status);

  @GET(path: AccountApiConstants.creditRequest)
  Future<Response<WithdrawalRequestResponse>> getWithdrawalRequest(@Query("status") String? status);

  @GET(path: AccountApiConstants.creditRequest)
  Future<Response<TransactionsResponse>> getTransactions();

  @PUT(path: AccountApiConstants.creditResponse)
  Future<Response> updateDepositAndWithdrawalRequest({@Body() required Map<String, dynamic> body});

  @POST(path: AccountApiConstants.depositWithdraw)
  Future<Response> depositAndWithdraw({@Body() required Map<String, dynamic> body});

  @GET(path: AccountApiConstants.getUsers)
  Future<Response<AllUsersResponse>> getAllUsers(@Query("role") String? role);

  @POST(path: AccountApiConstants.directdDepositWithdraw)
  Future<Response> directFund({@Body() required Map<String, dynamic> body});

  @POST(path: AccountApiConstants.resetPassword)
  Future<Response> resetPassword({@Body() required Map<String, dynamic> body});

  @GET(path: AccountApiConstants.selttlement)
  Future<Response<SettlementResponse>> getSettlement();

  @POST(path: AccountApiConstants.activityLog)
  Future<ActivityLogsResponse> getUserActivityLogs({@Body() required Map<String, dynamic> body});
}
