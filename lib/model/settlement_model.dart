class SettlementResponse {
  final int status;
  final List<SettlementData> data;
  final String message;

  SettlementResponse({required this.status, required this.data, required this.message});

  factory SettlementResponse.fromJson(Map<dynamic, dynamic> json) {
    return SettlementResponse(status: json['status'], data: (json['data'] as List).map((e) => SettlementData.fromJson(e)).toList(), message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.map((e) => e.toJson()).toList(), 'message': message};
  }
}

class SettlementData {
  final double pointRate;
  final double credit;
  final String userId;
  final double current;
  final double netBalance;
  final String wlName;
  final String wlId;
  final double amt;
  final String active;

  SettlementData({
    required this.pointRate,
    required this.credit,
    required this.userId,
    required this.current,
    required this.netBalance,
    required this.wlName,
    required this.wlId,
    required this.amt,
    required this.active,
  });

  factory SettlementData.fromJson(Map<String, dynamic> json) {
    return SettlementData(
      pointRate: (json['pointRate'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId'] ?? "",
      active: json['status'] ?? "-",
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
      netBalance: (json['netBalance'] as num?)?.toDouble() ?? 0.0,
      wlName: json['wlNmae'] ?? "",
      wlId: json['wlId'] ?? "",
      amt: (json['amt'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'pointRate': pointRate, 'credit': credit, 'userId': userId, 'current': current, 'netBalance': netBalance, 'wlNmae': wlName, 'wlId': wlId, 'amt': amt};
  }
}

final List<String> settlementHeader = ["S No.", 'Wl Name', "Status Id", 'Point Rate', 'Credit', 'Current', 'Net Balance', 'AMT LENA'];

List<List<String>> generateSettlementData({required List<SettlementData> userDetailsList}) {
  return userDetailsList.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final userDetails = entry.value;
    return [
      index.toString(),
      userDetails.wlName,
      userDetails.active,
      userDetails.pointRate.toStringAsFixed(2),
      userDetails.credit.toStringAsFixed(2),
      userDetails.current.toStringAsFixed(2),
      userDetails.netBalance.toStringAsFixed(2),
      userDetails.amt.toStringAsFixed(2),
    ];
  }).toList();
}
