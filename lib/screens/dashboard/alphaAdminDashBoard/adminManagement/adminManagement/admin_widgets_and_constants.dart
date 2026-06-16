import '../../../../../model/mapped_user_model.dart';

final List<String> wlAdminColumnNames = ['S.No', 'User Name', 'First Name', 'Last Name', 'App Name', 'Active', 'Balance', 'Exposure', 'PNL'];
List<List<String>> generateWLAdminDataRows({required List<MappedUserDetails> userDetailsList}) {
  return userDetailsList.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final userDetails = entry.value;
    return [
      index.toString(),
      userDetails.accountDetail.userName,
      // userDetails.account.firstName,
      // userDetails.account.lastName,
      // userDetails.appName.toUpperCase(),
      userDetails.enabled ? "Yes" : "No",
      userDetails.accountDetail.balancePoint.toStringAsFixed(2),
      userDetails.accountDetail.exposure.toStringAsFixed(2),
      userDetails.accountDetail.pnl.toStringAsFixed(2),
    ];
  }).toList();
}
//


final List<String> rbAdminColumnNames = [
  'S.No',
  'User Name',
  'First Name',
  'Last Name',
  'Active',
];
List<List<String>> generateRBAdminDataRows({required List<MappedUserDetails> userDetailsList}) {
  return userDetailsList.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final userDetails = entry.value;
    return [
      index.toString(),
      userDetails.userName,
      userDetails.firstName,
      userDetails.lastName,
      userDetails.enabled ? "Yes" : "No",
    ];
  }).toList();
}