import '../../../../model/user_details_model.dart';

final List<String> alphaFundsColumnNames = ['S.No', 'User Id', 'Amount', 'Type', 'Approved At', 'Remarks'];
List<List<String>> generateAlphaHistoryRows({required List<History> history, required String userName}) {
  return history.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final transHistory = entry.value;

    return [index.toString(), userName, transHistory.amount.toStringAsFixed(2), transHistory.transType.toUpperCase(), transHistory.date, transHistory.comment];
  }).toList();
}
