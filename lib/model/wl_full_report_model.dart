class WlFullReportsResponse {
  final int status;
  final List<WlFullReportsData> data;
  final String message;

  WlFullReportsResponse({required this.status, required this.data, required this.message});

  factory WlFullReportsResponse.fromJson(Map<dynamic, dynamic> json) => WlFullReportsResponse(
    status: json['status'] ?? 0,
    data: (json['data'] as List<dynamic>?)?.map((e) => WlFullReportsData.fromJson(e)).toList() ?? [],
    message: json['message'] ?? '',
  );

  double get totalPointValue => data.fold(0, (sum, e) => sum + e.pointValue);
  double get totalNetPoint => data.fold(0, (sum, e) => sum + e.netPoint);
  double get totalNetValue => data.fold(0, (sum, e) => sum + e.netValue);
  double get totalWL => data.fold(0, (sum, e) => sum + e.totalWL);
  double get totalPnl => data.fold(0, (sum, e) => sum + e.pnl);
  double get totalLivePoint => data.fold(0, (sum, e) => sum + e.livePoint);
  double get totalLiveValue => data.fold(0, (sum, e) => sum + e.liveValue);
  double get totalCompanyValue => data.fold(0, (sum, e) => sum + e.companyValue);
}

class WlFullReportsData {
  final int sNum;
  final String wlName;
  final double netPoint;
  final double pointValue;
  final double netValue;
  final double totalWL;
  final double livePoint;
  final double liveValue;
  final double pnl;
  final double companyValue;
  WlFullReportsData({
    required this.sNum,
    required this.wlName,
    required this.netPoint,
    required this.pointValue,
    required this.netValue,
    required this.totalWL,
    required this.livePoint,
    required this.liveValue,
    required this.pnl,
    required this.companyValue,
  });

  factory WlFullReportsData.fromJson(Map<String, dynamic> json) => WlFullReportsData(
    sNum: json['sNum'] ?? 0,
    wlName: json['wlName'] ?? "",
    netPoint: (json['netPoint'] ?? 0).toDouble(),
    pointValue: (json['pointValue'] ?? 0).toDouble(),
    netValue: (json['netValue'] ?? 0).toDouble(),
    totalWL: (json['totalWL'] ?? 0).toDouble(),
    livePoint: (json['livePoint'] ?? 0).toDouble(),
    liveValue: (json['liveValue'] ?? 0).toDouble(),
    pnl: (json['pnl'] ?? 0).toDouble(),
    companyValue: (json['companyValue'] ?? 0).toDouble(),
  );
}
