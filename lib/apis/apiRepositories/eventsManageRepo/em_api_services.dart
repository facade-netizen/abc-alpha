import 'package:chopper/chopper.dart';

import '../../../model/competitions_by_eventtype_model.dart';
import '../../../model/event_type_model.dart';
import '../../../model/events_model.dart';
import '../../../model/fancy_bet_exposure_model.dart';
import '../../../model/fancy_bet_list_model.dart';
import '../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../model/fancy_events_model.dart';
import '../../apiHandlers/api_constants.dart';
import '../../apiHandlers/api_interceptors.dart';
import '../../apiHandlers/json_to_type_converter.dart';

part 'em_api_services.chopper.dart';

final _emApiClient = ChopperClient(
  baseUrl: Uri.parse(EventManagementApiConstants.baseUrl),
  converter: JsonSerializableConverter({
    FancyBetResponse: (json) => FancyBetResponse.fromJson(json),
    FancyEventResponse: (json) => FancyEventResponse.fromJson(json),
    EventTypesResponse: (json) => EventTypesResponse.fromJson(json),
    FancyBetEventResponse: (json) => FancyBetEventResponse.fromJson(json),
    EventByCompetitionResponse: (json) => EventByCompetitionResponse.fromJson(json),
    CompetitionResponseByEventType: (json) => CompetitionResponseByEventType.fromJson(json),
    FancyCatalougesOnMarketTypeResponse: (json) => FancyCatalougesOnMarketTypeResponse.fromJson(json),
  }),
  interceptors: [ApiAuthInterceptor(), ApiResponseInterceptor(), ApiRequestInterceptor()],
  errorConverter: const JsonConverter(),
);

@ChopperApi(baseUrl: EventManagementApiConstants.baseUrl)
abstract class EmApiServices extends ChopperService {
  ///Don't modify
  static EmApiServices create() {
    return _$EmApiServices(_emApiClient);
  }

  @GET(path: EventManagementApiConstants.eventTypes)
  Future<Response<EventTypesResponse>> getEventType();

  @GET(path: EventManagementApiConstants.competitions)
  Future<Response<CompetitionResponseByEventType>> getCompetitionByEventTypeId(@Query('sportId') String sportId, @Query('sportName') String sportName);

  @GET(path: EventManagementApiConstants.events)
  Future<Response<EventByCompetitionResponse>> getEventsByCompId(@Query('competitionId') String competitionId, @Query('provider') String provider);

  @POST(path: EventManagementApiConstants.toggleEvents)
  Future<Response> eventToggle({@Body() required Map<dynamic, dynamic> body});

  @GET(path: EventManagementApiConstants.voidCatalouge)
  Future<Response> voidMarket(@Query('marketId') String marketId);

  @GET(path: EventManagementApiConstants.toogleFancy)
  Future<Response> toogleFancyMarket(@Query('marketId') String marketId, @Query('enable') bool? enable, @Query('isBallRunning') bool? isBallRunning);

  @POST(path: EventManagementApiConstants.newFancy)
  Future<Response> createFancy({@Body() required Map<String, dynamic> body});

  @POST(path: EventManagementApiConstants.fancydata)
  Future<Response> updateFancyMarket({@Body() required Map<String, dynamic> body});

  @PUT(path: EventManagementApiConstants.updateMarketCondition)
  Future<Response> updateMarketCondition({@Body() required Map<String, dynamic> body});

  @POST(path: EventManagementApiConstants.events)
  Future<Response<FancyBetEventResponse>> getFancyBetEvents({@Body() required Map<String, dynamic> body});

  @GET(path: EventManagementApiConstants.betExposure)
  Future<Response<FancyBetResponse>> getFancyBetExposure(@Query('marketId') String marketId);

  @POST(path: EventManagementApiConstants.allMarketAction)
  Future<Response<FancyBetEventResponse>> updateAllFancyMarketSusBallRun({@Body() required Map<String, dynamic> body});

  @POST(path: EventManagementApiConstants.settleMarket)
  Future<Response> settleMarket({@Body() required Map<String, dynamic> body});

  @PUT(path: EventManagementApiConstants.parseFormula)
  Future<Response> updateFancyThreeSelection({@Body() required Map<String, dynamic> body});

  @PUT(path: EventManagementApiConstants.updateSort)
  Future<Response> updateMarketSequence({@Body() required Map<String, dynamic> body});

  @GET(path: EventManagementApiConstants.eventFancyBet)
  Future<Response<FancyEventResponse>> getFancyEvent(@Query('Date') String marketId, @Query('SID') int sid);

  @GET(path: EventManagementApiConstants.catalougesMarketType)
  Future<Response<FancyCatalougesOnMarketTypeResponse>> getCatalougesOnMarketType(@Query('EventId') int sid, @Query('MarketType') String marketType);
  
  @PUT(path: EventManagementApiConstants.setPremium)
  Future<Response> updatePremium(@Query('eventId') String eventId, @Query('srId') String srId);
}
