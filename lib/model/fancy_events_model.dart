
class FancyEventResponse {
  final int status;
  final List<FancyEventData> data;
  final String message;

  FancyEventResponse({required this.status, required this.data, required this.message});

  factory FancyEventResponse.fromJson(Map<dynamic, dynamic> json) {
    return FancyEventResponse(
      status: json['status'] ?? 0,
      data: (json['data'] as List<dynamic>?)?.map((e) => FancyEventData.fromJson(e)).toList() ?? [],
      message: json['message'] ?? '',
    );
  }
}

class FancyEventData {
  final String id;
  final String competitionId;
  final String name;
  final String countryCode;
  final String venue;
  final String? openDate;
  final dynamic metaData;
  final bool inPlay;
  final bool premiumMatch;
  final bool oddsMarket;
  final bool eSportMarket;
  final bool bookMakerMarket;
  final bool fancyMarket;
  final bool closeByAlpha;
  final bool enabledByAlpha;

  FancyEventData({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.venue,
    required this.openDate,
    required this.metaData,
    required this.inPlay,
    required this.premiumMatch,
    required this.oddsMarket,
    required this.eSportMarket,
    required this.bookMakerMarket,
    required this.fancyMarket,
    required this.closeByAlpha,
    required this.enabledByAlpha,
    required this.competitionId,
  });

  factory FancyEventData.fromJson(Map<String, dynamic> json) {
    return FancyEventData(
      id: json['id'] ?? '',
      competitionId: json['CompetitionId'] ?? '',
      name: json['name'] ?? '',
      countryCode: json['countryCode'] ?? '',
      venue: json['venue'] ?? '',
      openDate: json['openDate'] ?? "",
      metaData: json['metaData'],
      inPlay: json['inPlay'] ?? false,
      premiumMatch: json['premiumMatch'] ?? false,
      oddsMarket: json['oddsMarket'] ?? false,
      eSportMarket: json['eSportMarket'] ?? false,
      bookMakerMarket: json['bookMakerMarket'] ?? false,
      fancyMarket: json['fancyMarket'] ?? false,
      closeByAlpha: json['closeByAlpha'] ?? false,
      enabledByAlpha: json['enabledByAlpha'] ?? false,
    );
  }
}

