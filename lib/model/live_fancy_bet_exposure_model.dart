class FancyLiveBetExposure {
  final int id;
  final int eventId;
  final String marketId;
  final int createdTime;
  final String creatorName;
  final double runsNo;
  final double runsYes;
  final double oddsNo;
  final double oddsYes;
  final double exposureNo;
  final double exposureYes;
  final bool isClosed;

  FancyLiveBetExposure({
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
    required this.isClosed,
  });
  factory FancyLiveBetExposure.fromProto(Map<String, dynamic> json) {
    return FancyLiveBetExposure(
      id: json['id'] ?? 0,
      eventId: json['eventId'] ?? 0,
      marketId: json['marketId'] ?? '',
      createdTime: json['createdTime'] ?? 0,
      creatorName: json['creatorName'] ?? '',
      runsNo: (json['runsNo'] ?? 0).toDouble(),
      runsYes: (json['runsYes'] ?? 0).toDouble(),
      oddsNo: (json['oddsNo'] ?? 0).toDouble(),
      oddsYes: (json['oddsYes'] ?? 0).toDouble(),
      exposureNo: (json['exposureNo'] ?? 0).toDouble(),
      exposureYes: (json['exposureYes'] ?? 0).toDouble(),
      isClosed: json['isClosed'] ?? false,
    );
  }
}
