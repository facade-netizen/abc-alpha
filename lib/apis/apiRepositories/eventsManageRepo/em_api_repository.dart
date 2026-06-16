import 'package:chopper/chopper.dart';

import '../../../model/competitions_by_eventtype_model.dart';
import '../../../model/event_type_model.dart';
import '../../../model/events_model.dart';
import '../../../model/fancy_bet_exposure_model.dart';
import '../../../model/fancy_bet_list_model.dart';
import '../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../model/fancy_events_model.dart';
import 'em_api_services.dart';

class EMApiRepository {
  EMApiRepository() : _emApiServices = EmApiServices.create();
  final EmApiServices _emApiServices;

  Future<Response<EventTypesResponse>> getEventType() async {
    try {
      return _emApiServices.getEventType();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<CompetitionResponseByEventType>> getCompetitionByEventTypeId(@Query('sportId') String sportId, @Query('sportName') String sportName) async {
    try {
      return _emApiServices.getCompetitionByEventTypeId(sportId, sportName);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<EventByCompetitionResponse>> getEventsByCompId(@Query('competitionId') String competitionId, @Query('provider') String provider) async {
    try {
      return _emApiServices.getEventsByCompId(competitionId, provider);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> eventToggle({required Map<dynamic, dynamic> body}) async {
    return await _emApiServices.eventToggle(body: body);
  }

  Future<Response> voidMarket(@Query('marketId') String marketId) async {
    try {
      return _emApiServices.voidMarket(marketId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> toogleFancyMarket(@Query('marketId') String marketId, @Query('enable') bool? enable, @Query('isBallRunning') bool? isBallRunning) async {
    try {
      return _emApiServices.toogleFancyMarket(marketId, enable, isBallRunning);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createFancy({required Map<String, dynamic> body}) async {
    return await _emApiServices.createFancy(body: body);
  }

  Future<Response> updateFancyMarket({required Map<String, dynamic> body}) async {
    return await _emApiServices.updateFancyMarket(body: body);
  }

  Future<Response> updateFancyThreeSelection({required Map<String, dynamic> body}) async {
    return await _emApiServices.updateFancyThreeSelection(body: body);
  }

  Future<Response> updateMarketCondition({required Map<String, dynamic> body}) async {
    return await _emApiServices.updateMarketCondition(body: body);
  }

  Future<Response<FancyBetEventResponse>> getFancyBetEvents({required Map<String, dynamic> body}) async {
    return await _emApiServices.getFancyBetEvents(body: body);
  }

  Future<Response<FancyBetResponse>> getFancyBetExposure(@Query('marketId') String marketId) async {
    return await _emApiServices.getFancyBetExposure(marketId);
  }

  Future<Response> updateAllFancyMarketSusBallRun({required Map<String, dynamic> body}) async {
    return await _emApiServices.updateAllFancyMarketSusBallRun(body: body);
  }

  Future<Response> settleMarket({required Map<String, dynamic> body}) async {
    return await _emApiServices.settleMarket(body: body);
  }

  Future<Response> updateMarketSequence({required Map<String, dynamic> body}) async {
    return await _emApiServices.updateMarketSequence(body: body);
  }

  Future<Response<FancyEventResponse>> getFancyEvent(String date, int sid) async {
    return await _emApiServices.getFancyEvent(date, sid);
  }

  Future<Response<FancyCatalougesOnMarketTypeResponse>> getCatalougesOnMarketType(int eventId, String marketType) async {
    return await _emApiServices.getCatalougesOnMarketType(eventId, marketType);
  }

  Future<Response> updatePremium(@Query('eventId') String eventId, @Query('srId') String srId) async {
    return await _emApiServices.updatePremium(eventId, srId);
  }
}
