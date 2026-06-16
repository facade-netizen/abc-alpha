// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'white_lable_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$WhiteLableApiServices extends WhiteLableApiServices {
  _$WhiteLableApiServices([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = WhiteLableApiServices;

  @override
  Future<Response<WhiteLableResponse>> getAllWhiteLables() {
    final Uri $url = Uri.parse('https://abcuser.dmxchge.com/api/WL/getAll');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<WhiteLableResponse, WhiteLableResponse>($request);
  }

  @override
  Future<Response<dynamic>> updateWhiteLable(
      {required Map<String, dynamic> body}) {
    final Uri $url = Uri.parse('https://abcuser.dmxchge.com/api/WL/update');
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
  Future<Response<WlFullReportsResponse>> wlfullReport() {
    final Uri $url = Uri.parse('https://abcuser.dmxchge.com/api/wlfullReport');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<WlFullReportsResponse, WlFullReportsResponse>($request);
  }

  @override
  Future<Response<WLNetReportsResponse>> getWLNetReports() {
    final Uri $url = Uri.parse('https://abcuser.dmxchge.com/api/wlnet');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<WLNetReportsResponse, WLNetReportsResponse>($request);
  }
}
