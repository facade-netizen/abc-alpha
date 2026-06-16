import 'package:chopper/chopper.dart';

import '../../../model/activity_log_model.dart';
import 'auth_api_services.dart';

class AuthApiRepository {
  AuthApiRepository() : _authApiServices = AuthApiServices.create();
  final AuthApiServices _authApiServices;

  Future<Response> createNewUser({required Map<String, dynamic> body}) async {
    return await _authApiServices.createNewUser(body: body);
  }

  Future<ActivityLogsResponse> getUserActivityLogs({required Map<String, dynamic> body}) async {
    return await _authApiServices.getUserActivityLogs(body: body);
  }

  Future<Response> setTOTPLable({required Map<String, dynamic> body}) async {
    return await _authApiServices.setTOTPLable(body: body);
  }

  Future<Response> verifyOTP(@Query("totp") String totp) async {
    try {
      return _authApiServices.verifyOTP(totp);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> check2FAEnabled() async {
    try {
      return _authApiServices.check2FAEnabled();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> changeNewPassword({required Map<String, dynamic> body}) async {
    return await _authApiServices.changeNewPassword(body: body);
  }
}
