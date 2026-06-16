class WhiteLableResponse {
  final int status;
  final List<WhiteLableAppData> data;
  final String message;
  WhiteLableResponse({required this.status, required this.data, required this.message});
  factory WhiteLableResponse.fromJson(Map<dynamic, dynamic> json) {
    return WhiteLableResponse(status: json['status'], data: List<WhiteLableAppData>.from(json['data'].map((e) => WhiteLableAppData.fromJson(e))), message: json['message']);
  }
}

class WhiteLableAppData {
  final String wlId;
  final String appName;
  final String appColor;
  final String appId;
  final String appTrack;
  final String appVersion;
  final bool inMaintenance;
  final String platform;
  final String releasedOn;
  final String updateOn;
  final String adminDomainUrl;
  final String clientDomainUrl;
  final String adminLocalHost;
  final String clientLocalHost;
  final String favicon;
  final String logo;
  final String privacyPolicy;
  final bool isEnabled;
  final bool hasAdmin;
  final String remarks;

  WhiteLableAppData({
    required this.wlId,
    required this.appName,
    required this.appColor,
    required this.appId,
    required this.appTrack,
    required this.appVersion,
    required this.inMaintenance,
    required this.platform,
    required this.releasedOn,
    required this.updateOn,
    required this.adminDomainUrl,
    required this.clientDomainUrl,
    required this.adminLocalHost,
    required this.clientLocalHost,
    required this.favicon,
    required this.logo,
    required this.privacyPolicy,
    required this.isEnabled,
    required this.hasAdmin,
    required this.remarks,
  });

  factory WhiteLableAppData.fromJson(Map<String, dynamic> json) {
    return WhiteLableAppData(
      wlId: json['id'] ?? "",
      appName: json['appName'] ?? "",
      appColor: json['appColor'] ?? "",
      appId: json['appId'] ?? "",
      appTrack: json['appTrack'] ?? "",
      appVersion: json['appVersion'] ?? "",
      inMaintenance: json['inMaintenance'] ?? false,
      platform: json['platform'] ?? "",
      releasedOn: json['releasedOn'] ?? "",
      updateOn: json['updateOn'] ?? "",
      adminDomainUrl: json['adminDomainUrl'] ?? "",
      clientDomainUrl: json['clientDomainUrl'] ?? "",
      adminLocalHost: json['adminLocalHost'] ?? "",
      clientLocalHost: json['clientLocalHost'] ?? "",
      favicon: json['favicon'] ?? "",
      logo: json['logo'] ?? "",
      privacyPolicy: json['privacyPolicy'] ?? "",
      isEnabled: json['isEnabled'] ?? false,
      hasAdmin: json['hasAdmin'] ?? false,
      remarks: json['remarks'] ?? "",
    );
  }
}
