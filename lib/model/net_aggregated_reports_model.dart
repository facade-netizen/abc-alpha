class NetAggregatedResponse {
  final int status;
  final List<NetAggregatedData> data;
  final String message;
  NetAggregatedResponse({required this.status, required this.data, required this.message});
  factory NetAggregatedResponse.fromJson(Map<dynamic, dynamic> json) {
    return NetAggregatedResponse(status: json['status'], data: (json['data'] as List).map((item) => NetAggregatedData.fromJson(item)).toList(), message: json['message']);
  }
}

class NetAggregatedData {
  final String eventName;
  final String marketName;
  final List<WlDetail> wlDetails;
  NetAggregatedData({required this.eventName, required this.marketName, required this.wlDetails});
  factory NetAggregatedData.fromJson(Map<String, dynamic> json) {
    return NetAggregatedData(eventName: json['eventName'], marketName: json['marketName'], wlDetails: (json['wlDetails'] as List).map((item) => WlDetail.fromJson(item)).toList());
  }
}

class WlDetail {
  final String wl;
  final List<RunnerPlDetail> runnerPLDetails;
  WlDetail({required this.wl, required this.runnerPLDetails});
  factory WlDetail.fromJson(Map<String, dynamic> json) {
    return WlDetail(wl: json['wl'], runnerPLDetails: (json['runnerPLDetails'] as List).map((item) => RunnerPlDetail.fromJson(item)).toList());
  }
}

class RunnerPlDetail {
  final String name;
  final double pnl;
  final double pvPnl;
  RunnerPlDetail({required this.name, required this.pnl, required this.pvPnl});
  factory RunnerPlDetail.fromJson(Map<String, dynamic> json) {
    return RunnerPlDetail(name: json['name'], pnl: json['pnl'], pvPnl: json['pv_Pnl']);
  }
}
