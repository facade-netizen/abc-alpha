import 'package:flutter/material.dart';

import '../reusable/colors.dart';
import '../reusable/custom_table.dart';

class ActivityLogsResponse {
  final List<ActivityLogsData> data;
  final int page;
  final int pageSize;
  final int result;
  final String status;
  final int totalPages;
  final int totalRecords;

  ActivityLogsResponse({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.result,
    required this.status,
    required this.totalPages,
    required this.totalRecords,
  });

  factory ActivityLogsResponse.fromJson(Map<dynamic, dynamic> json) {
    return ActivityLogsResponse(
      data: (json['data'] as List? ?? []).map((e) => ActivityLogsData.fromJson(e)).toList(),
      page: json['page'],
      pageSize: json['pageSize'],
      result: json['result'],
      status: json['status'],
      totalPages: json['totalPages'],
      totalRecords: json['totalRecords'],
    );
  }
}

class ActivityLogsData {
  final int id;
  final String loginTime;
  final String loginStatus;
  final String ip;
  final String isp;
  final String address;
  final String agent;
  final String userId;

  ActivityLogsData({
    required this.id,
    required this.loginTime,
    required this.loginStatus,
    required this.ip,
    required this.isp,
    required this.address,
    required this.agent,
    required this.userId,
  });

  factory ActivityLogsData.fromJson(Map<String, dynamic> json) {
    return ActivityLogsData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      loginTime: json['loginTime']?.toString() ?? '',
      loginStatus: json['loginStatus']?.toString() ?? '',
      ip: json['ip']?.toString() ?? '',
      isp: json['isp']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      agent: json['agent']?.toString() ?? '',
      userId: json['UserId']?.toString() ?? '',
    );
  }
}

List<TableColumn<ActivityLogsData>> activityLogColumns = [
  TableColumn(
    label: 'Login Date & Time',
    flex: 1,
    value: (row) => row.loginTime,
  ),
  TableColumn(
    label: 'Login Status',
    flex: 1,
    value: (row) => row.loginStatus,
    color: (row) => row.loginStatus.toLowerCase() == "login success" ? Colors.green : Colors.red,
  ),
  TableColumn(
    label: 'IP Address',
    flex: 1,
    alignRight: true,
    value: (row) => row.ip,
  ),
  TableColumn(
    label: 'ISP',
    flex: 2,
    alignRight: true,
    value: (row) => row.isp,
  ),
  TableColumn(
    label: 'City/State/Country',
    flex: 1,
    alignRight: true,
    value: (row) => row.address,
  ),
  TableColumn(
    label: 'User Agent Type',
    flex: 1,
    alignRight: true,
    value: (row) => row.agent,
  ),
];

class AccountStatementLogModel {
  final int id;
  final String dateTime;
  final String deposit;
  final String withdraw;
  final String remark;
  final String fromTo;
  final String updater;

  AccountStatementLogModel({
    required this.id,
    required this.dateTime,
    required this.deposit,
    required this.withdraw,
    required this.remark,
    required this.fromTo,
    required this.updater,
  });

  factory AccountStatementLogModel.fromJson(Map<String, dynamic> json) {
    return AccountStatementLogModel(
      id: json['id'] ?? 0,
      dateTime: json['dateTime'] ?? '',
      deposit: json['deposit'] ?? '-',
      withdraw: json['withdraw'] ?? '-',
      remark: json['remark'] ?? '',
      fromTo: json['fromTo'] ?? '',
      updater: json['updater'] ?? '',
    );
  }
}

List<AccountStatementLogModel> accountStatementDummyData = [
  AccountStatementLogModel(
    id: 1,
    dateTime: '2026-02-23 14:30:22',
    deposit: '5,000.00',
    withdraw: '-',
    remark: 'Initial Deposit',
    fromTo: 'Bank Transfer',
    updater: 'admin01',
  ),
];

class AccountStatementHeader {
  final String label;
  final double flex;
  final bool alignRight;
  final Color Function(AccountStatementLogModel log)? color;
  final String Function(AccountStatementLogModel log) value;

  const AccountStatementHeader({
    required this.label,
    required this.flex,
    required this.value,
    this.color,
    this.alignRight = true,
  });
}

List<AccountStatementHeader> accountStatementHeaders = [
  AccountStatementHeader(
    label: 'Date/Time',
    flex: 1.8,
    alignRight: false,
    value: (log) => log.dateTime,
  ),
  AccountStatementHeader(
    label: 'Deposit',
    flex: 1,
    value: (log) => log.deposit,
    color: (log) {
      if (log.deposit != '-' && log.deposit.isNotEmpty) {
        return Colors.green;
      }
      return black;
    },
  ),
  AccountStatementHeader(
    label: 'Withdraw',
    flex: 1,
    value: (log) => log.withdraw,
    color: (log) {
      if (log.withdraw != '-' && log.withdraw.isNotEmpty) {
        return Colors.red;
      }
      return black;
    },
  ),
  AccountStatementHeader(
    label: 'Remark',
    flex: 1,
    value: (log) => log.remark,
  ),
  AccountStatementHeader(
    label: 'From/To',
    flex: 1.8,
    value: (log) => log.fromTo,
  ),
  AccountStatementHeader(
    label: 'Updater',
    flex: 1,
    value: (log) => log.updater,
  ),
];

class TransferredLogModel {
  final String dateTime;
  final String beforeSettlement;
  final String settledAmount;
  final String afterSettlement;
  final String fromTo;
  final String remarks;

  TransferredLogModel({
    required this.dateTime,
    required this.beforeSettlement,
    required this.settledAmount,
    required this.afterSettlement,
    required this.fromTo,
    required this.remarks,
  });

  factory TransferredLogModel.fromJson(Map<String, dynamic> json) {
    return TransferredLogModel(
      dateTime: json['dateTime'] ?? '',
      beforeSettlement: json['beforeSettlement'] ?? '',
      settledAmount: json['settledAmount'] ?? '',
      afterSettlement: json['afterSettlement'] ?? '',
      fromTo: json['fromTo'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}

List<TransferredLogModel> transferredDummyData = [
  TransferredLogModel(
    dateTime: '2026-02-23 10:30:15',
    beforeSettlement: '15,000.00',
    settledAmount: '5,000.00',
    afterSettlement: '20,000.00',
    fromTo: 'Master Agent baber2712',
    remarks: 'SR001',
  ),
];

class TransferredLogHeader {
  final String label;
  final double flex;
  final bool alignRight;
  final Color Function(TransferredLogModel log)? color;
  final String Function(TransferredLogModel log) value;

  const TransferredLogHeader({
    required this.label,
    required this.flex,
    required this.value,
    this.color,
    this.alignRight = true,
  });
}

List<TransferredLogHeader> transferredLogHeaders = [
  TransferredLogHeader(
    label: 'Date/Time',
    flex: 1.8,
    alignRight: false,
    value: (log) => log.dateTime,
  ),
  TransferredLogHeader(
    label: 'Before Settlement',
    flex: 1.3,
    value: (log) => log.beforeSettlement,
  ),
  TransferredLogHeader(
    label: 'Settled Amount',
    flex: 1.2,
    value: (log) => log.settledAmount,
    color: (log) {
      if (log.settledAmount.startsWith('(')) {
        return Colors.red;
      } else if (log.settledAmount != '-' && log.settledAmount.isNotEmpty) {
        return Colors.green;
      }
      return black;
    },
  ),
  TransferredLogHeader(
    label: 'After Settlement',
    flex: 1.2,
    value: (log) => log.afterSettlement,
  ),
  TransferredLogHeader(
    label: 'Remarks',
    flex: 0.8,
    alignRight: false,
    value: (log) => log.remarks,
  ),
  TransferredLogHeader(
    label: 'From/To',
    flex: 1.5,
    alignRight: false,
    value: (log) => log.fromTo,
  ),
];

class ChangePasswordLogModel {
  final String dateTime;
  final String ip;
  final String updater;
  final String site;

  ChangePasswordLogModel({
    required this.dateTime,
    required this.ip,
    required this.updater,
    required this.site,
  });

  factory ChangePasswordLogModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordLogModel(
      dateTime: json['dateTime'] ?? '',
      ip: json['ip'] ?? '',
      updater: json['updater'] ?? '',
      site: json['site'] ?? '',
    );
  }
}

List<ChangePasswordLogModel> changePasswordDummyData = [
  ChangePasswordLogModel(
    dateTime: '2026-02-23 09:15:32',
    ip: '192.168.1.105',
    updater: 'admin01',
    site: 'Main Office',
  ),
];

class ChangePasswordLogHeader {
  final String label;
  final double flex;
  final bool alignRight;
  final Color Function(ChangePasswordLogModel log)? color;
  final String Function(ChangePasswordLogModel log) value;

  const ChangePasswordLogHeader({
    required this.label,
    required this.flex,
    required this.value,
    this.color,
    this.alignRight = true,
  });
}

List<ChangePasswordLogHeader> changePasswordLogHeaders = [
  ChangePasswordLogHeader(
    label: 'Date/Time',
    flex: 2,
    alignRight: false,
    value: (log) => log.dateTime,
  ),
  ChangePasswordLogHeader(
    label: 'IP Address',
    flex: 1.5,
    alignRight: false,
    value: (log) => log.ip,
  ),
  ChangePasswordLogHeader(
    label: 'Updater',
    flex: 1.2,
    alignRight: false,
    value: (log) => log.updater,
  ),
  ChangePasswordLogHeader(
    label: 'Site',
    flex: 1.3,
    alignRight: false,
    value: (log) => log.site,
  ),
];

class InitialCreditLimitModel {
  final String dateTime;
  final String beforeInitialCreditLimit;
  final String afterInitialCreditLimit;
  final String remarks;
  final String fromTo;

  InitialCreditLimitModel({
    required this.dateTime,
    required this.beforeInitialCreditLimit,
    required this.afterInitialCreditLimit,
    required this.remarks,
    required this.fromTo,
  });

  factory InitialCreditLimitModel.fromJson(Map<String, dynamic> json) {
    return InitialCreditLimitModel(
      dateTime: json['dateTime'] ?? '',
      beforeInitialCreditLimit: json['beforeInitialCreditLimit'] ?? '',
      afterInitialCreditLimit: json['afterInitialCreditLimit'] ?? '',
      remarks: json['remarks'] ?? '',
      fromTo: json['fromTo'] ?? '',
    );
  }
}

List<InitialCreditLimitModel> initialCreditLimitDummyData = [
  InitialCreditLimitModel(
    dateTime: '2026-02-23 10:30:15',
    beforeInitialCreditLimit: '50,000.00',
    afterInitialCreditLimit: '100,000.00',
    remarks: 'admin01',
    fromTo: 'Master Agent baber2712',
  ),
];

class InitialCreditLimitHeader {
  final String label;
  final double flex;
  final bool alignRight;
  final Color Function(InitialCreditLimitModel log)? color;
  final String Function(InitialCreditLimitModel log) value;

  const InitialCreditLimitHeader({
    required this.label,
    required this.flex,
    required this.value,
    this.color,
    this.alignRight = false,
  });
}

List<InitialCreditLimitHeader> initialCreditLimitHeaders = [
  InitialCreditLimitHeader(
    label: 'Date/Time',
    flex: 1.8,
    value: (log) => log.dateTime,
  ),
  InitialCreditLimitHeader(
    label: 'Before Initial Credit Limit',
    flex: 1.5,
    value: (log) => log.beforeInitialCreditLimit,
  ),
  InitialCreditLimitHeader(
    label: 'After Initial Credit Limit',
    flex: 1.5,
    value: (log) => log.afterInitialCreditLimit,
    color: (log) {
      return Colors.green;
    },
  ),
  InitialCreditLimitHeader(
    label: 'Remarks',
    flex: 1.2,
    value: (log) => log.remarks,
  ),
  InitialCreditLimitHeader(
    label: 'From/To',
    flex: 1.5,
    value: (log) => log.fromTo,
  ),
];

class IspLogModel {
  final String dateTime;
  final String ip;
  final String isp;
  final String updater;
  final String site;

  IspLogModel({
    required this.dateTime,
    required this.ip,
    required this.isp,
    required this.updater,
    required this.site,
  });

  factory IspLogModel.fromJson(Map<String, dynamic> json) {
    return IspLogModel(
      dateTime: json['dateTime'] ?? '',
      ip: json['ip'] ?? '',
      isp: json['isp'] ?? '',
      updater: json['updater'] ?? '',
      site: json['site'] ?? '',
    );
  }
}

List<IspLogModel> ispLogDummyData = [
  IspLogModel(
    dateTime: '2026-02-23 09:15:32',
    ip: '192.168.1.105',
    isp: 'Comcast',
    updater: 'admin01',
    site: 'Main Office',
  ),
];

class IspLogHeader {
  final String label;
  final double flex;
  final Color Function(IspLogModel log)? color;
  final String Function(IspLogModel log) value;

  const IspLogHeader({
    required this.label,
    required this.flex,
    required this.value,
    this.color,
  });
}

List<IspLogHeader> ispLogHeaders = [
  IspLogHeader(label: 'Date/Time', flex: 2, value: (log) => log.dateTime),
  IspLogHeader(label: 'IP Address', flex: 1.5, value: (log) => log.ip),
  IspLogHeader(label: 'ISP', flex: 1.5, value: (log) => log.isp),
  IspLogHeader(label: 'Updater', flex: 1.2, value: (log) => log.updater),
  IspLogHeader(label: 'Site', flex: 1.3, value: (log) => log.site),
];
