import 'package:chopper/chopper.dart';

import '../../../model/white_lable_model.dart';
import '../../../model/wl_full_report_model.dart';
import '../../../model/wl_report_model.dart';
import 'white_lable_services.dart';

class WhiteLableRepository {
  WhiteLableRepository() : _whiteLableApiServices = WhiteLableApiServices.create();
  final WhiteLableApiServices _whiteLableApiServices;

  Future<Response<WhiteLableResponse>> getAllWhiteLables() async {
    try {
      return _whiteLableApiServices.getAllWhiteLables();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateWhiteLable({required Map<String, dynamic> body}) async {
    return await _whiteLableApiServices.updateWhiteLable(body: body);
  }

  Future<Response<WlFullReportsResponse>> wlfullReport() async {
    try {
      return _whiteLableApiServices.wlfullReport();
    } catch (e) {
      rethrow;
    }
  }
  Future<Response<WLNetReportsResponse>> getWLNetReports() async {
    try {
      return _whiteLableApiServices.getWLNetReports();
    } catch (e) {
      rethrow;
    }
  }
}
