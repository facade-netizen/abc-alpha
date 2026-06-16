import 'package:chopper/chopper.dart';

import '../../../model/net_aggregated_reports_model.dart';
import '../../apiHandlers/api_constants.dart';
import '../../apiHandlers/api_interceptors.dart';
import '../../apiHandlers/json_to_type_converter.dart';

part 'orders_api_services.chopper.dart';

final _ordersApiClient = ChopperClient(
  baseUrl: Uri.parse(OrdersApiConstants.baseUrl),
  converter: JsonSerializableConverter({NetAggregatedResponse: (json) => NetAggregatedResponse.fromJson(json)}),
  interceptors: [ApiAuthInterceptor(), ApiResponseInterceptor(), ApiRequestInterceptor()],
  errorConverter: const JsonConverter(),
);

@ChopperApi(baseUrl: OrdersApiConstants.baseUrl)
abstract class OrdersApiServices extends ChopperService {
  ///Don't modify
  static OrdersApiServices create() {
    return _$OrdersApiServices(_ordersApiClient);
  }

  @GET(path: OrdersApiConstants.wlpnlReport)
  Future<Response<NetAggregatedResponse>> getNAReport();
}
