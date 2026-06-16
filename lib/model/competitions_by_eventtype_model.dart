class CompetitionResponseByEventType {
  final int status;
  final List<CompetitionByEventType> data;
  final String message;

  CompetitionResponseByEventType({required this.status, required this.data, required this.message});

  factory CompetitionResponseByEventType.fromJson(Map<dynamic, dynamic> json) {
    return CompetitionResponseByEventType(status: json['status'], data: (json['data'] as List).map((e) => CompetitionByEventType.fromJson(e)).toList(), message: json['message']);
  }
}

class CompetitionByEventType {
  final String id;
  final String name;
  final String provider;
  final String sportId;

  CompetitionByEventType({required this.id, required this.name, required this.provider, required this.sportId});

  factory CompetitionByEventType.fromJson(Map<String, dynamic> json) {
    return CompetitionByEventType(id: json['id'] ?? '', name: json['name'], provider: json['provider'], sportId: json['sportId'] ?? '');
  }
}
