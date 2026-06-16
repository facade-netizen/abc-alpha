class FancyBetResponse {
  final int status;
  final List<FancyBetData> data;
  final String message;

  FancyBetResponse({required this.status, required this.data, required this.message});

  factory FancyBetResponse.fromJson(Map<dynamic, dynamic> json) {
    return FancyBetResponse(
      status: json['status'] ?? 0,
      data: (json['data'] as List<dynamic>?)?.map((e) => FancyBetData.fromJson(e)).toList() ?? [],
      message: json['message'] ?? '',
    );
  }
}

class FancyBetData {
  final int id;
  final String eventId;
  final String marketId;
  final DateTime createdTime;
  final String creatorName;
  final double runsNo;
  final double runsYes;
  final double oddsNo;
  final double oddsYes;
  final double exposureNo;
  final double exposureYes;

  FancyBetData({
    required this.id,
    required this.eventId,
    required this.marketId,
    required this.createdTime,
    required this.creatorName,
    required this.runsNo,
    required this.runsYes,
    required this.oddsNo,
    required this.oddsYes,
    required this.exposureNo,
    required this.exposureYes,
  });

  factory FancyBetData.fromJson(Map<String, dynamic> json) {
    final rawTime = json['createdTime'] ?? 0;
    int timestamp = rawTime is int ? rawTime : int.tryParse(rawTime.toString()) ?? 0;
    if (timestamp.toString().length == 10) {
      timestamp *= 1000;
    }
    return FancyBetData(
      id: json['id'] ?? 0,
      eventId: json['eventId'] ?? "",
      marketId: json['marketId'] ?? "",
      createdTime: DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true),
      creatorName: json['creatorName'] ?? "",
      runsNo: json['runsNo'] ?? 0,
      runsYes: json['runsYes'] ?? 0,
      oddsNo: json['oddsNo'] ?? 0,
      oddsYes: json['oddsYes'] ?? 0,
      exposureNo: json['exposureNo'] ?? 0,
      exposureYes: json['exposureYes'] ?? 0,
    );
  }
}
