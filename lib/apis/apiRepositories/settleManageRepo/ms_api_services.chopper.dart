// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_api_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SettleApiServices extends SettleApiServices {
  _$SettleApiServices([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SettleApiServices;

  @override
  Future<Response<CustomFancyMarketResponse>> getCustomMarket(int eventId) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/getCustomMarket');
    final Map<String, dynamic> $params = <String, dynamic>{'eventId': eventId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<CustomFancyMarketResponse, CustomFancyMarketResponse>($request);
  }

  @override
  Future<Response<dynamic>> saveMarketTosettle(
      {required Map<dynamic, dynamic> body}) {
    final Uri $url = Uri.parse('https://abcmanager.dmxchge.com/save');
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
  Future<Response<dynamic>> marketSettle(
      {required Map<dynamic, dynamic> body}) {
    final Uri $url = Uri.parse('https://abcmanager.dmxchge.com/settle');
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
  Future<Response<SettleHistoryResponse>> getSettleHistory(String marketId) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/getSettleHistory');
    final Map<String, dynamic> $params = <String, dynamic>{
      'marketId': marketId
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<SettleHistoryResponse, SettleHistoryResponse>($request);
  }
}
