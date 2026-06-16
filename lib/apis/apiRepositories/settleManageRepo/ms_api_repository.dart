import 'package:chopper/chopper.dart';

import '../../../model/custom_fancy_market_model.dart';
import '../../../model/settle_history_model.dart';
import 'ms_api_services.dart';

class SettleApiRepository {
  SettleApiRepository() : _msApiServices = SettleApiServices.create();
  final SettleApiServices _msApiServices;

  Future<Response<CustomFancyMarketResponse>> getCustomMarket(@Query('eventId') int eventId) async {
    return await _msApiServices.getCustomMarket(eventId);
  }

  Future<Response> saveMarketTosettle({required Map<String, dynamic> body}) async {
    return await _msApiServices.saveMarketTosettle(body: body);
  }

  Future<Response> marketSettle({required Map<String, dynamic> body}) async {
    return await _msApiServices.marketSettle(body: body);
  }
  
  Future<Response<SettleHistoryResponse>> getSettleHistory(@Query('marketId') String marketId) async {
    return await _msApiServices.getSettleHistory(marketId);
  }
}
