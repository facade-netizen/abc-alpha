import '../bloc/signalRBloc/protoUsage/receive/receive.pb.dart';

class FancyCatalougesOnMarketTypeResponse {
  final int status;
  final List<FancyCatalougesOnMarketType> data;
  final String message;

  FancyCatalougesOnMarketTypeResponse({required this.status, required this.data, required this.message});

  factory FancyCatalougesOnMarketTypeResponse.fromJson(Map<dynamic, dynamic> json) {
    return FancyCatalougesOnMarketTypeResponse(
      status: json['status'] ?? 0,
      data: (json['data'] as List<dynamic>?)?.map((e) => FancyCatalougesOnMarketType.fromJson(e)).toList() ?? [],
      message: json['message'] ?? '',
    );
  }
}

class FancyCatalougesOnMarketType {
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
  final List<MarketRunner> runners;
  final String? competitionId;
  final String eventId;
  final String? eventName;
  final String? sid;
  int? sorting;
  final String? competitionName;
  final MarketCondition? fancyMarketCondition;

  FancyCatalougesOnMarketType({
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

  factory FancyCatalougesOnMarketType.fromJson(Map<String, dynamic> json) {
    final rawMarketTime = json['marketTime']?.toString() ?? json['MarketTime']?.toString() ?? '';
    final marketTime = rawMarketTime.isEmpty ? null : (DateTime.tryParse(rawMarketTime)?.toIso8601String() ?? rawMarketTime);

    final competitionId = json['competitionId'] ?? json['CompetitionId'] ?? '';
    final eventId = json['EventId'] ?? json['eventId'] ?? '';
    final eventName = json['eventName'] ?? json['EventName'] ?? '';
    final competitionName = json['competitionName'] ?? json['CompetitionName'] ?? '';
    final sid = json['sid'] ?? json['SID'] ?? '';
    final sorting = json['sorting'] ?? json['Sorting'] ?? 0;

    return FancyCatalougesOnMarketType(
      marketId: json['marketId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      marketTime: marketTime,
      marketType: json['marketType'] ?? '',
      bettingType: json['bettingType'] ?? '',
      marketName: json['marketName'] ?? '',
      provider: json['provider'] ?? '',
      fancyMarketCondition: MarketCondition.fromJson(json['marketCondition'] ?? {}),
      status: json['status'] ?? '',
      inPlay: json['inPlay'] ?? false,
      pauseByAlpha: json['pauseByAlpha'] ?? false,
      createdByAlpha: json['createdByAlpha'] ?? false,
      sportingEvent: json['sportingEvent'] ?? false,
      runners: (json['runners'] as List<dynamic>?)?.map((e) => MarketRunner.fromJson(e)).toList() ?? [],
      competitionId: competitionId,
      eventId: eventId,
      eventName: eventName,
      sid: sid,
      sorting: sorting,
      competitionName: competitionName,
    );
  }
  factory FancyCatalougesOnMarketType.fromBuffer(ABCModel fancy) {
    final marketTime = (fancy.marketTime.isNotEmpty) ? DateTime.tryParse(fancy.marketTime)?.toIso8601String() : null;
    return FancyCatalougesOnMarketType(
      marketId: fancy.marketId,
      marketType: fancy.marketType,
      bettingType: fancy.bettingType.toString(),
      marketTime: marketTime,
      marketName: fancy.marketName,
      provider: '',
      status: fancy.status.toString(),
      inPlay: fancy.inPlay,
      fancyMarketCondition: MarketCondition(
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
            (runner) => MarketRunner(
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
      identical(this, other) || other is FancyCatalougesOnMarketType && runtimeType == other.runtimeType && marketId == other.marketId && marketName == other.marketName;
  @override
  int get hashCode => marketId.hashCode;
}

class MarketCondition {
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

  MarketCondition({
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

  factory MarketCondition.fromJson(Map<String, dynamic> json) {
    return MarketCondition(
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

class MarketRunner {
  final String id;
  final String name;
  final String marketType;
  final String status;
  final int sortPriority;
  final dynamic metadata;
  List<dynamic> backs;
  List<dynamic> lays;

  MarketRunner({
    required this.id,
    required this.name,
    required this.marketType,
    required this.sortPriority,
    required this.metadata,
    required this.backs,
    required this.lays,
    required this.status,
  });

  factory MarketRunner.fromJson(Map<String, dynamic> json) {
    return MarketRunner(
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
