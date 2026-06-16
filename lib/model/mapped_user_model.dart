class MappedUserResponse {
  final String? status;
  final String? message;
  final List<MappedUserDetails>? data;
  final int page;
  final int pageSize;
  final int result;
  final int totalPages;
  final int totalRecords;

  MappedUserResponse({
    required this.status,
    required this.totalRecords,
    this.message,
    this.data,
    required this.page,
    required this.pageSize,
    required this.result,
    required this.totalPages,
  });

  factory MappedUserResponse.fromJson(Map<dynamic, dynamic> json) {
    return MappedUserResponse(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      data: json['data'] is List ? (json['data'] as List).map((e) => MappedUserDetails.fromJson(e)).toList() : [],
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      result: json['result'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalRecords: json['totalRecords'] ?? 0,
    );
  }
}

class MappedUserDetails {
  final String firstName;
  final String lastName;
  final String timezone;
  final String userStatus;
  final String createdByUserId;
  final bool enabled;
  final dynamic createdByUser;
  final dynamic createdUsers;
  final String role;
  final int childCount;
  final String accountId;
  final AccountModel accountDetail;
  final String id;
  final String userName;
  final String normalizedUserName;
  final String? email;
  final String? normalizedEmail;
  final bool emailConfirmed;
  final String passwordHash;
  final String securityStamp;
  final String concurrencyStamp;
  final String? phoneNumber;
  final bool phoneNumberConfirmed;
  final bool twoFactorEnabled;
  final String? lockoutEnd;
  final bool lockoutEnabled;
  final int accessFailedCount;

  MappedUserDetails({
    required this.firstName,
    required this.lastName,
    required this.timezone,
    required this.createdByUserId,
    required this.enabled,
    this.createdByUser,
    this.createdUsers,
    required this.role,
    required this.childCount,
    required this.accountId,
    required this.accountDetail,
    required this.id,
    required this.userName,
    required this.normalizedUserName,
    this.email,
    this.normalizedEmail,
    required this.emailConfirmed,
    required this.passwordHash,
    required this.securityStamp,
    required this.concurrencyStamp,
    this.phoneNumber,
    required this.phoneNumberConfirmed,
    required this.twoFactorEnabled,
    this.lockoutEnd,
    required this.lockoutEnabled,
    required this.accessFailedCount,
    required this.userStatus,
  });

  factory MappedUserDetails.fromJson(Map<String, dynamic> json) => MappedUserDetails(
    firstName: json['firstName'] ?? "",
    lastName: json['lastName'] ?? "",
    timezone: json['timezone'] ?? "",
    createdByUserId: json['createdByUserId'] ?? "",
    enabled: json['enabled'] ?? false,
    createdByUser: json['createdByUser'],
    createdUsers: json['createdUsers'],
    role: json['role'] ?? "",
    childCount: json['childCount'] ?? 0,
    accountId: json['accountId'] ?? "",
    userStatus: json['userStatus'] ?? "",
    accountDetail: AccountModel.fromJson(json['account'] ?? {}),
    id: json['Id'] ?? "",
    userName: json['UserName'] ?? "",
    normalizedUserName: json['NormalizedUserName'] ?? "",
    email: json['Email'],
    normalizedEmail: json['NormalizedEmail'],
    emailConfirmed: json['EmailConfirmed'] ?? false,
    passwordHash: json['PasswordHash'] ?? "",
    securityStamp: json['SecurityStamp'] ?? "",
    concurrencyStamp: json['ConcurrencyStamp'] ?? "",
    phoneNumber: json['PhoneNumber'],
    phoneNumberConfirmed: json['PhoneNumberConfirmed'] ?? false,
    twoFactorEnabled: json['TwoFactorEnabled'] ?? false,
    lockoutEnd: json['LockoutEnd'],
    lockoutEnabled: json['LockoutEnabled'] ?? false,
    accessFailedCount: json['AccessFailedCount'] ?? 0,
  );
}

class AccountModel {
  final String accountId;
  final String wlId;
  final String wlName;
  final String role;
  final double distributedPoint;
  final double receivedPoint;
  final double depositPoint;
  final double withdrawalPoint;
  final double exposure;
  final double exposureLimit;
  final double creditRef;
  final double pnl;
  final double commissionRate;
  final double commission;
  final double pointValue;
  final double soldPoint;
  final double netPoint;
  final double balancePoint;
  final List<dynamic> users;
  final List<dynamic> history;
  final String userName;
  final String firstName;
  final String lastName;
  final String userId;

  AccountModel({
    required this.accountId,
    required this.wlId,
    required this.wlName,
    required this.role,
    required this.distributedPoint,
    required this.receivedPoint,
    required this.depositPoint,
    required this.withdrawalPoint,
    required this.exposure,
    required this.exposureLimit,
    required this.creditRef,
    required this.pnl,
    required this.commissionRate,
    required this.commission,
    required this.pointValue,
    required this.soldPoint,
    required this.netPoint,
    required this.balancePoint,
    required this.users,
    required this.history,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.userId,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    accountId: json['accountId'] ?? '',
    wlId: json['wlId'] ?? '',
    wlName: json['wlName'] ?? '',
    role: json['role'] ?? '',
    distributedPoint: (json['distributedPoint'] ?? 0).toDouble(),
    receivedPoint: (json['receivedPoint'] ?? 0).toDouble(),
    depositPoint: (json['depositPoint'] ?? 0).toDouble(),
    withdrawalPoint: (json['withdrawalPoint'] ?? 0).toDouble(),
    exposure: (json['exposure'] ?? 0).toDouble(),
    exposureLimit: (json['exposureLimit'] ?? 0).toDouble(),
    creditRef: (json['creditRef'] ?? 0).toDouble(),
    pnl: (json['pnl'] ?? 0).toDouble(),
    commissionRate: (json['commissionRate'] ?? 0).toDouble(),
    commission: (json['commission'] ?? 0).toDouble(),
    pointValue: (json['pointValue'] ?? 0).toDouble(),
    soldPoint: (json['soldPoint'] ?? 0).toDouble(),
    netPoint: (json['netPoint'] ?? 0).toDouble(),
    balancePoint: (json['balancePoint'] ?? 0).toDouble(),
    users: json['users'] ?? [],
    history: json['history'] ?? [],
    userName: json['userName'] ?? '',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    userId: json['userId'] ?? '',
  );
}
