import 'package:chopper/chopper.dart';
import '../../../model/net_aggregated_reports_model.dart';
import 'orders_api_services.dart';

class OrdersApiRepository {
  OrdersApiRepository() : _ordersApiServices = OrdersApiServices.create();
  final OrdersApiServices _ordersApiServices;

  Future<Response<NetAggregatedResponse>> getNAReport() async {
    try {
      return _ordersApiServices.getNAReport();
    } catch (e) {
      rethrow;
    }
  }


}
