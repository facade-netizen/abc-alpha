import 'package:chopper/chopper.dart';

import '../../../model/activity_log_model.dart';
import '../../../model/wl_report_model.dart';
import '../../apiHandlers/api_constants.dart';
import '../../apiHandlers/api_interceptors.dart';
import '../../apiHandlers/json_to_type_converter.dart';

part 'auth_api_services.chopper.dart';

final _authApiClient = ChopperClient(
  baseUrl: Uri.parse(AuthApiConstants.baseUrl),
  converter: JsonSerializableConverter({ActivityLogsResponse: (json) => ActivityLogsResponse.fromJson(json), WLNetReportsResponse: (json) => WLNetReportsResponse.fromJson(json)}),
  interceptors: [ApiAuthInterceptor(), ApiResponseInterceptor(), ApiRequestInterceptor()],
  errorConverter: const JsonConverter(),
);

@ChopperApi(baseUrl: AuthApiConstants.baseUrl)
abstract class AuthApiServices extends ChopperService {
  ///Don't modify
  static AuthApiServices create() {
    return _$AuthApiServices(_authApiClient);
  }

  @POST(path: AuthApiConstants.register)
  Future<Response> createNewUser({@Body() required Map<String, dynamic> body});

  @POST(path: AuthApiConstants.activityLog)
  Future<ActivityLogsResponse> getUserActivityLogs({@Body() required Map<String, dynamic> body});

  @POST(path: AuthApiConstants.twofactor)
  Future<Response> setTOTPLable({@Body() required Map<String, dynamic> body});

  @GET(path: AuthApiConstants.enableTotp)
  Future<Response> verifyOTP(@Query("totp") String totp);

  @GET(path: AuthApiConstants.isTotpenable)
  Future<Response> check2FAEnabled();

  @POST(path: AuthApiConstants.changePassword)
  Future<Response> changeNewPassword({@Body() required Map<String, dynamic> body});
}
