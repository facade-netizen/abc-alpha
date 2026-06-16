class EventTypesResponse {
  final int status;
  final List<EventTypes> data;
  final String message;
  EventTypesResponse({required this.status, required this.data, required this.message});
  factory EventTypesResponse.fromJson(Map<dynamic, dynamic> json) {
    return EventTypesResponse(status: json['status'], data: (json['data'] as List).map((e) => EventTypes.fromJson(e)).toList(), message: json['message']);
  }
}

class EventTypes {
  final String id;
  final String name;
  final String icon;
  final int count;
  EventTypes({required this.id, required this.name, required this.icon, required this.count});
  factory EventTypes.fromJson(Map<String, dynamic> json) {
    return EventTypes(id: json['id'] ?? '', name: json['name'], icon: json['icon'] ?? '', count: json['count'] ?? 0);
  }
}
