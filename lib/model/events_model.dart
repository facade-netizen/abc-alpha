class EventByCompetitionResponse {
  final int status;
  final List<EventDetails> data;
  final String message;

  EventByCompetitionResponse({required this.status, required this.data, required this.message});

  factory EventByCompetitionResponse.fromJson(Map<dynamic, dynamic> json) {
    return EventByCompetitionResponse(
      status: int.tryParse(json['status'].toString()) ?? 0,
      data: (json['data'] as List?)?.map((e) => EventDetails.fromJson(e)).toList() ?? [],
      message: json['message']?.toString() ?? '',
    );
  }
}

class EventDetails {
  final String id;
  final String name;
  final String countryCode;
  final String venue;
  final String openDate;
  final dynamic metaData;
  final bool inPlay;
  final bool forceAddInPlay;
  final bool forceRemoveInPlay;
  final bool premiumMatch;
  final bool oddsMarket;
  final bool eSportMarket;
  final bool bookMakerMarket;
  final bool fancyMarket;
  final bool enabledByAlpha;
  final String competitionId;
  final String sid; 
  final String srId; 
  final bool enabledByAdmin;

  EventDetails({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.venue,
    required this.openDate,
    this.metaData,
    required this.inPlay,
    required this.forceAddInPlay,
    required this.forceRemoveInPlay,
    required this.premiumMatch,
    required this.oddsMarket,
    required this.eSportMarket,
    required this.bookMakerMarket,
    required this.fancyMarket,
    required this.enabledByAlpha,
    required this.competitionId,
    required this.sid,
    required this.srId,
    required this.enabledByAdmin,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      countryCode: json['countryCode'] ?? '',
      venue: json['venue'] ?? '',
      openDate: json['openDate'] ?? '',
      metaData: json['metaData'],
      inPlay: json['inPlay'] ?? false,
      forceAddInPlay: json['forceAddInPlay'] ?? false,
      forceRemoveInPlay: json['forceRemoveInPlay'] ?? false,
      premiumMatch: json['premiumMatch'] ?? false,
      oddsMarket: json['oddsMarket'] ?? false,
      eSportMarket: json['eSportMarket'] ?? false,
      bookMakerMarket: json['bookMakerMarket'] ?? false,
      fancyMarket: json['fancyMarket'] ?? false,
      enabledByAlpha: json['enabledByAlpha'] ?? false,
      competitionId: json['CompetitionId'] ?? json['CompetitionId'] ?? '',
      sid: json['sid'] ?? json['sid'] ?? '',
      srId: json['srId'] ?? json['srId'] ?? '',
      enabledByAdmin: json['enabledByAdmin'] ?? false,
    );
  }
}
