import 'package:intl/intl.dart';

class SettleHistoryResponse {
  final int status;
  final List<SettleHistoryData> data;
  final String? message;

  SettleHistoryResponse({required this.status, required this.data, this.message});

  factory SettleHistoryResponse.fromJson(Map<dynamic, dynamic> json) {
    return SettleHistoryResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? List<SettleHistoryData>.from(json['data'].map((x) => SettleHistoryData.fromJson(x))) : [],
    );
  }
}

class SettleHistoryData {
  final int id;
  final String marketId;
  final int result;
  final String resultSource;
  final String updator;
  final String settleType;
  final int createdDate;
  final String operator;
  final String? message;
  final int eventId;

  SettleHistoryData({
    required this.id,
    required this.marketId,
    required this.result,
    required this.resultSource,
    required this.updator,
    required this.settleType,
    required this.createdDate,
    required this.operator,
    this.message,
    required this.eventId,
  });

  factory SettleHistoryData.fromJson(Map<String, dynamic> json) {
    return SettleHistoryData(
      id: json['id'],
      marketId: json['marketId'],
      result: json['result'],
      resultSource: json['resultSource'],
      updator: json['updator'],
      settleType: json['settleType'],
      createdDate: json['createdDate'],
      operator: json['operator'],
      message: json['message'],
      eventId: json['eventId'],
    );
  }
  String get createdDateUtcString {
    final date = DateTime.fromMillisecondsSinceEpoch(createdDate * 1000, isUtc: true);
    return DateFormat('yyyy/MM/dd HH:mm:ss').format(date);
  }
}
