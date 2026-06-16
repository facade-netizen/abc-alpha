class CategoryResponse {
  final int status;
  final List<CategoryType> data;
  final String message;

  CategoryResponse({required this.status, required this.data, required this.message});

  factory CategoryResponse.fromJson(Map<dynamic, dynamic> json) {
    return CategoryResponse(status: json['status'], data: ((json['data'] as List).map((item) => CategoryType.fromJson(item)).toList()), message: json['message']);
  }
}

class CategoryType {
  final int id;
  final int count;
  final String name;
  final String icon;
  CategoryType({required this.id, required this.name, required this.count, required this.icon});
  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(id: json['id'] ?? 0, count: json['count'] ?? 0, name: json['name'] ?? '', icon: json['icon'] ?? '');
  }
}
