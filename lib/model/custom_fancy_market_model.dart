class CustomFancyMarketResponse {
  final int status;
  final List<CustomMarket> data;
  final String message;
  CustomFancyMarketResponse({required this.status, required this.data, required this.message});
  factory CustomFancyMarketResponse.fromJson(Map<dynamic, dynamic> json) {
    return CustomFancyMarketResponse(status: json['status'], data: (json['data'] as List).map((item) => CustomMarket.fromJson(item)).toList(), message: json['message']);
  }
}

class CustomMarket {
  final String marketId;
  final String marketName;
  final int runs;
  final String resultSource;
  final String updator;
  final String status;
  final int transactionCount;
  final String settleVoid;
  final String operator;
  final String settleType;
  final String bettingType;
  final bool pausebyAlpha;

  CustomMarket({
    required this.marketId,
    required this.marketName,
    required this.runs,
    required this.resultSource,
    required this.updator,
    required this.status,
    required this.transactionCount,
    required this.settleVoid,
    required this.operator,
    required this.settleType,
    required this.pausebyAlpha,
    required this.bettingType,
  });

  factory CustomMarket.fromJson(Map<String, dynamic> json) {
    return CustomMarket(
      marketId: json['marketId'] ?? "",
      marketName: json['marketName'] ?? "",
      runs: json['result'] ?? 0,
      resultSource: json['resultSource'] ?? "",
      updator: json['updator'] ?? "",
      status: json['status'] ?? "",
      transactionCount: json['transactionCount'] ?? 0,
      settleVoid: json['settleVoid'] ?? "",
      operator: json['operator'] ?? "",
      settleType: json['settleType'] ?? "",
      bettingType: json['bettingType'] ?? "",
      pausebyAlpha: json['pausebyAlpha'] ?? false,
    );
  }
}
