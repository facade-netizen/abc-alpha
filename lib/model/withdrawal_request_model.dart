class WithdrawalRequestResponse {
  final int status;
  final List<WithdrawalRequest> data;
  final String message;

  WithdrawalRequestResponse({required this.status, required this.data, required this.message});

  factory WithdrawalRequestResponse.fromJson(Map<dynamic, dynamic> json) {
    return WithdrawalRequestResponse(status: json['status'] ?? 0, data: (json['data'] as List? ?? []).map((e) => WithdrawalRequest.fromJson(e)).toList(), message: json['message'] ?? '');
  }
}

class WithdrawalRequest {
  final int id;
  final String userName;
  final String wlName;
  final int amount;
  final String status;
  final String requestAt;
  final String? responseAt;
  final String? remark;
  final String ip;
  final String type;
  final String? approvedBy;

  WithdrawalRequest({
    required this.id,
    required this.userName,
    required this.wlName,
    required this.amount,
    required this.status,
    required this.requestAt,
    required this.type,
    this.responseAt,
    this.remark,
    required this.ip,
    this.approvedBy,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      wlName: json['wlName'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
      requestAt: json['requestAt'] ?? '',
      responseAt: json['responseAt'],
      remark: json['remark'],
      ip: json['ip'] ?? '',
      type: json['type'] ?? '',
      approvedBy: json['approvedBy'],
    );
  }
}
