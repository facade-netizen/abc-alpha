class WLNetReportsResponse {
  final int status;
  final List<WLNetReports> data;
  final String message;

  WLNetReportsResponse({required this.status, required this.data, required this.message});

  factory WLNetReportsResponse.fromJson(Map<dynamic, dynamic> json) {
    return WLNetReportsResponse(status: json['status'], data: (json['data'] as List).map((e) => WLNetReports.fromJson(e)).toList(), message: json['message']);
  }
}

class WLNetReports {
  final int sNum;
  final String wlName;
  final String adminName;
  final double points;
  final double pointValue;
  final double value;

  WLNetReports({required this.sNum, required this.wlName, required this.adminName, required this.points, required this.pointValue, required this.value});

  factory WLNetReports.fromJson(Map<String, dynamic> json) {
    return WLNetReports(
      sNum: json['sNum'],
      wlName: json['wlName'],
      adminName: json['adminName'],
      points: json['points'],
      pointValue: (json['pointValue'] as num).toDouble(),
      value: json['value'],
    );
  }
}
