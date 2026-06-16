// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_api_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$OrdersApiServices extends OrdersApiServices {
  _$OrdersApiServices([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = OrdersApiServices;

  @override
  Future<Response<NetAggregatedResponse>> getNAReport() {
    final Uri $url = Uri.parse('https://abcorder.dmxchge.com/wlpnlReport');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<NetAggregatedResponse, NetAggregatedResponse>($request);
  }
}
