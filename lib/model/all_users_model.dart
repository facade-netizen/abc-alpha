class AllUsersResponse {
  final int status;
  final List<AllUserData> data;
  final String message;

  AllUsersResponse({required this.status, required this.data, required this.message});

  factory AllUsersResponse.fromJson(Map<dynamic, dynamic> json) {
    return AllUsersResponse(status: json['status'] ?? 0, data: (json['data'] as List<dynamic>? ?? []).map((e) => AllUserData.fromJson(e)).toList(), message: json['message'] ?? '');
  }
}

class AllUserData {
  final String username;
  final String role;
  final String userId;
  final String wlName;
  final String wlId;
  final String active;
  final double pnl;
  final double exposure;
  final double balance;

  AllUserData({
    required this.username,
    required this.role,
    required this.userId,
    required this.wlName,
    required this.wlId,
    required this.active,
    required this.pnl,
    required this.exposure,
    required this.balance,
  });

  factory AllUserData.fromJson(Map<String, dynamic> json) {
    return AllUserData(
      username: json['username'] ?? "",
      role: json['role'] ?? "",
      userId: json['userId'] ?? "",
      wlName: json['wlNmae'] ?? "",
      wlId: json['wlId'] ?? "",
      active: json['active'] ?? "",
      pnl: (json['pnl'] as num?)?.toDouble() ?? 0.0,
      exposure: (json['exposure'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

final List<String> wlAdminColumnNames = ['S.No', 'User Name', 'App Name', 'Active', 'Balance', 'Exposure', 'PNL'];

List<List<String>> generateRBAdminData({required List<AllUserData> userDetailsList}) {
  return userDetailsList.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final userDetails = entry.value;
    return [
      index.toString(),
      userDetails.wlName,
      userDetails.active,
      userDetails.balance.toStringAsFixed(2),
      userDetails.exposure.toStringAsFixed(2),
      userDetails.pnl.toStringAsFixed(2),
    ];
  }).toList();
}
