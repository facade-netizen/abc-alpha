import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../services/log_service.dart';

class ApiResponseInterceptor implements Interceptor {
  static const String _tag = 'HTTP-RES';

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final response = await chain.proceed(chain.request);
    if (kDebugMode) {
      final req = response.base.request;
      final statusCode = response.statusCode;
      final method = req?.method ?? '?';
      final url = req?.url.toString() ?? '?';
      final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
      LogService.instance.log(level, _tag, '$method $url -> $statusCode');
      if (statusCode >= 400) {
        LogService.instance.warning(_tag, 'Response body: ${response.bodyString}');
      }
    }
    return response;
  }
}

class ApiRequestInterceptor implements Interceptor {
  static const String _tag = 'HTTP-REQ';

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    if (kDebugMode) {
      final req = chain.request;
      LogService.instance.info(_tag, '${req.method} ${req.url}');
      if (req.body != null && req.body.toString().isNotEmpty) {
        LogService.instance.debug(_tag, 'Body: ${req.body}');
      }
      if (req.parameters.isNotEmpty) {
        LogService.instance.debug(_tag, 'Params: ${req.parameters}');
      }
    }
    final response = await chain.proceed(chain.request);
    return response;
  }
}

class ApiAuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
    final authToken = savedData!.token ?? '';
    Request request = applyHeader(chain.request, 'Authorization', 'Bearer $authToken', override: true);
    if (request.method == "Get" || request.method == "POST") {
      request = applyHeaders(request, {'Content-Type': 'application/json'});
    }
    final response = await chain.proceed(request);
    if (kDebugMode && response.statusCode != 200) {
      LogService.instance.warning('HTTP-AUTH', '${request.method} ${request.url} -> ${response.statusCode}: ${response.bodyString}');
    }
    return response;
  }
}
