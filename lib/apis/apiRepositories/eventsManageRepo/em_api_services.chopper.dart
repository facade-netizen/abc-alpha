// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'em_api_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$EmApiServices extends EmApiServices {
  _$EmApiServices([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = EmApiServices;

  @override
  Future<Response<EventTypesResponse>> getEventType() {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/eventType');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<EventTypesResponse, EventTypesResponse>($request);
  }

  @override
  Future<Response<CompetitionResponseByEventType>> getCompetitionByEventTypeId(
    String sportId,
    String sportName,
  ) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/competitions');
    final Map<String, dynamic> $params = <String, dynamic>{
      'sportId': sportId,
      'sportName': sportName,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CompetitionResponseByEventType,
        CompetitionResponseByEventType>($request);
  }

  @override
  Future<Response<EventByCompetitionResponse>> getEventsByCompId(
    String competitionId,
    String provider,
  ) {
    final Uri $url = Uri.parse('https://abcmanager.dmxchge.com/api/EM/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'competitionId': competitionId,
      'provider': provider,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<EventByCompetitionResponse, EventByCompetitionResponse>($request);
  }

  @override
  Future<Response<dynamic>> eventToggle({required Map<dynamic, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/toggleEvents');
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
  Future<Response<dynamic>> voidMarket(String marketId) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/voidCatalouge');
    final Map<String, dynamic> $params = <String, dynamic>{
      'marketId': marketId
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> toogleFancyMarket(
    String marketId,
    bool? enable,
    bool? isBallRunning,
  ) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/toogleFancy');
    final Map<String, dynamic> $params = <String, dynamic>{
      'marketId': marketId,
      'enable': enable,
      'isBallRunning': isBallRunning,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createFancy({required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/newFancy');
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
  Future<Response<dynamic>> updateFancyMarket(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/fancydata');
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
  Future<Response<dynamic>> updateMarketCondition(
      {required Map<String, dynamic> body}) {
    final Uri $url = Uri.parse(
        'https://abcmanager.dmxchge.com/api/EM/updateMarketCondition');
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
  Future<Response<FancyBetEventResponse>> getFancyBetEvents(
      {required Map<String, dynamic> body}) {
    final Uri $url = Uri.parse('https://abcmanager.dmxchge.com/api/EM/events');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<FancyBetEventResponse, FancyBetEventResponse>($request);
  }

  @override
  Future<Response<FancyBetResponse>> getFancyBetExposure(String marketId) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/betExposure');
    final Map<String, dynamic> $params = <String, dynamic>{
      'marketId': marketId
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FancyBetResponse, FancyBetResponse>($request);
  }

  @override
  Future<Response<FancyBetEventResponse>> updateAllFancyMarketSusBallRun(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/allMarketAction');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<FancyBetEventResponse, FancyBetEventResponse>($request);
  }

  @override
  Future<Response<dynamic>> settleMarket({required Map<String, dynamic> body}) {
    final Uri $url = Uri.parse('https://abcmanager.dmxchge.com/api/EM/settle');
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
  Future<Response<dynamic>> updateFancyThreeSelection(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/parseFormula');
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
  Future<Response<dynamic>> updateMarketSequence(
      {required Map<String, dynamic> body}) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/updateSort');
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
  Future<Response<FancyEventResponse>> getFancyEvent(
    String marketId,
    int sid,
  ) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/eventFancyBet');
    final Map<String, dynamic> $params = <String, dynamic>{
      'Date': marketId,
      'SID': sid,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FancyEventResponse, FancyEventResponse>($request);
  }

  @override
  Future<Response<FancyCatalougesOnMarketTypeResponse>>
      getCatalougesOnMarketType(
    int sid,
    String marketType,
  ) {
    final Uri $url = Uri.parse(
        'https://abcmanager.dmxchge.com/api/EM/catalouges-marketType');
    final Map<String, dynamic> $params = <String, dynamic>{
      'EventId': sid,
      'MarketType': marketType,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FancyCatalougesOnMarketTypeResponse,
        FancyCatalougesOnMarketTypeResponse>($request);
  }

  @override
  Future<Response<dynamic>> updatePremium(
    String eventId,
    String srId,
  ) {
    final Uri $url =
        Uri.parse('https://abcmanager.dmxchge.com/api/EM/setPremium');
    final Map<String, dynamic> $params = <String, dynamic>{
      'eventId': eventId,
      'srId': srId,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
