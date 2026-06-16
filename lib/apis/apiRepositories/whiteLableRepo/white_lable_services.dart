import 'package:chopper/chopper.dart';

import '../../../model/white_lable_model.dart';
import '../../../model/wl_full_report_model.dart';
import '../../../model/wl_report_model.dart';
import '../../apiHandlers/api_constants.dart';
import '../../apiHandlers/api_interceptors.dart';
import '../../apiHandlers/json_to_type_converter.dart';

part 'white_lable_services.chopper.dart';

final _whiteLableApiClient = ChopperClient(
  baseUrl: Uri.parse(WlApiConstants.baseUrl),
  converter: JsonSerializableConverter({WhiteLableResponse: (json) => WhiteLableResponse.fromJson(json), WlFullReportsResponse: (json) => WlFullReportsResponse.fromJson(json)}),
  interceptors: [ApiAuthInterceptor(), ApiResponseInterceptor(), ApiRequestInterceptor()],
  errorConverter: const JsonConverter(),
);

@ChopperApi(baseUrl: WlApiConstants.baseUrl)
abstract class WhiteLableApiServices extends ChopperService {
  ///Don't modify
  static WhiteLableApiServices create() {
    return _$WhiteLableApiServices(_whiteLableApiClient);
  }

  @GET(path: WlApiConstants.getAll)
  Future<Response<WhiteLableResponse>> getAllWhiteLables();

  @PUT(path: WlApiConstants.update)
  Future<Response> updateWhiteLable({@Body() required Map<String, dynamic> body});

  @GET(path: WlApiConstants.wlfullReport)
  Future<Response<WlFullReportsResponse>> wlfullReport();

  @GET(path: WlApiConstants.wlnet)
  Future<Response<WLNetReportsResponse>> getWLNetReports();
}
