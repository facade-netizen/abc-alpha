import '../bloc/signalRBloc/protoUsage/receive/receive.pb.dart';

class FancyBetEventResponse {
  final int status;
  final List<FancyBetEventData> data;
  final String message;

  FancyBetEventResponse({required this.status, required this.data, required this.message});

  factory FancyBetEventResponse.fromJson(Map<dynamic, dynamic> json) {
    return FancyBetEventResponse(
      status: json['status'] ?? 0,
      data: (json['data'] as List<dynamic>?)?.map((e) => FancyBetEventData.fromJson(e)).toList() ?? [],
      message: json['message'] ?? '',
    );
  }
}

class FancyBetEventData {
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
  final List<FancyBetMarketCatalogue> catalogues;

  FancyBetEventData({
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
    required this.catalogues,
    required this.competitionId,
  });

  factory FancyBetEventData.fromJson(Map<String, dynamic> json) {
    return FancyBetEventData(
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
      catalogues: (json['catalogues'] as List<dynamic>?)?.map((e) => FancyBetMarketCatalogue.fromJson(e)).toList() ?? [],
    );
  }
}

class FancyBetMarketCatalogue {
  final String marketId;
  final String? createdBy;
  final String? marketTime;
  final String marketType;
  final String bettingType;
  final String marketName;
  final String provider;
  final String status;
  final bool inPlay;
  bool? pauseByAlpha;
  bool? createdByAlpha;
  final bool sportingEvent;
  final List<FancyMarketRunner> runners;
  final String? competitionId;
  final String eventId;
  final String? eventName;
  final String? sid;
  int? sorting;
  final String? competitionName;
  final FancyMarketCondition? fancyMarketCondition;

  FancyBetMarketCatalogue({
    required this.marketId,
    this.marketTime,
    this.createdBy,
    required this.marketType,
    required this.bettingType,
    required this.marketName,
    required this.provider,
    this.pauseByAlpha,
    this.createdByAlpha,
    this.fancyMarketCondition,
    required this.status,
    required this.inPlay,
    required this.sportingEvent,
    required this.runners,
    this.competitionId,
    required this.eventId,
    this.eventName,
    this.sid,
    this.sorting,
    this.competitionName,
  });

  factory FancyBetMarketCatalogue.fromJson(Map<String, dynamic> json) {
    final marketTime = (json['marketTime'] != null && json['marketTime'].toString().isNotEmpty) ? DateTime.tryParse(json['marketTime'].toString())?.toIso8601String() : null;
    return FancyBetMarketCatalogue(
      marketId: json['marketId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      marketTime: marketTime,
      marketType: json['marketType'] ?? '',
      bettingType: json['bettingType'] ?? '',
      marketName: json['marketName'] ?? '',
      provider: json['provider'] ?? '',
      fancyMarketCondition: FancyMarketCondition.fromJson(json['marketCondition'] ?? {}),
      status: json['status'] ?? '',
      inPlay: json['inPlay'] ?? false,
      pauseByAlpha: json['pauseByAlpha'] ?? false,
      createdByAlpha: json['createdByAlpha'] ?? false,
      sportingEvent: json['sportingEvent'] ?? false,
      runners: (json['runners'] as List<dynamic>?)?.map((e) => FancyMarketRunner.fromJson(e)).toList() ?? [],
      competitionId: json['competitionId'] ?? 0,
      eventId: json['EventId'] ?? 0,
      eventName: json['eventName'] ?? '',
      sid: json['sid'] ?? 0,
      sorting: json['sorting'] ?? 0,
      competitionName: json['competitionName'] ?? '',
    );
  }
  factory FancyBetMarketCatalogue.fromBuffer(ABCModel fancy) {
    final marketTime = (fancy.marketTime.isNotEmpty) ? DateTime.tryParse(fancy.marketTime)?.toIso8601String() : null;
    return FancyBetMarketCatalogue(
      marketId: fancy.marketId,
      marketType: fancy.marketType,
      bettingType: fancy.bettingType.toString(),
      marketTime: marketTime,
      marketName: fancy.marketName,
      provider: '',
      status: fancy.status.toString(),
      inPlay: fancy.inPlay,
      fancyMarketCondition: FancyMarketCondition(
        marketId: fancy.marketId,
        betLock: fancy.marketCondition.betLock,
        minBet: fancy.marketCondition.minBet.toDouble(),
        maxBet: fancy.marketCondition.maxBet.toDouble(),
        maxProfit: fancy.marketCondition.maxProfit.toDouble(),
        betDelay: fancy.marketCondition.betDelay.toDouble(),
        mtp: fancy.marketCondition.mtp.toDouble(),
        allowUnmatchBet: fancy.marketCondition.allowUnmatchBet,
        potLimit: fancy.marketCondition.potLimit.toDouble(),
        volume: fancy.marketCondition.volume.toDouble(),
      ),
      runners: fancy.runner
          .map(
            (runner) => FancyMarketRunner(
              id: runner.runnerId,
              name: runner.name,
              marketType: '',
              sortPriority: 0,
              metadata: null,
              backs: runner.backs,
              lays: runner.lays,
              status: runner.status.toString(),
            ),
          )
          .toList(),
      eventId: fancy.eventId,
      sportingEvent: fancy.sportingEvent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FancyBetMarketCatalogue && runtimeType == other.runtimeType && marketId == other.marketId && marketName == other.marketName;
  @override
  int get hashCode => marketId.hashCode;
}

class FancyMarketCondition {
  final String marketId;
  final bool betLock;
  final double minBet;
  final double maxBet;
  final double maxProfit;
  final double betDelay;
  final double mtp;
  final bool allowUnmatchBet;
  final double potLimit;
  final double volume;

  FancyMarketCondition({
    required this.marketId,
    required this.betLock,
    required this.minBet,
    required this.maxBet,
    required this.maxProfit,
    required this.betDelay,
    required this.mtp,
    required this.allowUnmatchBet,
    required this.potLimit,
    required this.volume,
  });

  factory FancyMarketCondition.fromJson(Map<String, dynamic> json) {
    return FancyMarketCondition(
      marketId: json['marketId'] ?? '',
      betLock: json['betLock'] ?? false,
      minBet: json['minBet'] ?? 0,
      maxBet: json['maxBet'] ?? 0,
      maxProfit: json['maxProfit'] ?? 0,
      betDelay: json['betDelay'] ?? 0,
      mtp: json['mtp'] ?? 0,
      allowUnmatchBet: json['allowUnmatchBet'] ?? false,
      potLimit: json['potLimit'] ?? 0,
      volume: json['volume'] ?? 0,
    );
  }
}

class FancyMarketRunner {
  final String id;
  final String name;
  final String marketType;
  final String status;
  final int sortPriority;
  final dynamic metadata;
  List<dynamic> backs;
  List<dynamic> lays;

  FancyMarketRunner({
    required this.id,
    required this.name,
    required this.marketType,
    required this.sortPriority,
    required this.metadata,
    required this.backs,
    required this.lays,
    required this.status,
  });

  factory FancyMarketRunner.fromJson(Map<String, dynamic> json) {
    return FancyMarketRunner(
      id: json['id'] ?? '0',
      name: json['name'] ?? '',
      marketType: json['marketType'] ?? '',
      sortPriority: json['sortPriority'] ?? 0,
      metadata: json['metadata'],
      status: json['status'] ?? "",
      backs: [],
      lays: [],
    );
  }
}
