import '../../../../model/transactions_model.dart';

final List<String> transactionsColumnNames = ['S.No', 'User Id', 'WL Name', 'Type', 'Amount', 'Status', 'Requested At', 'Approved At', 'Remarks', 'IP'];

List<List<String>> generateTransactionsRows({required List<Transactions> transactions}) {
  return transactions.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final transaction = entry.value;
    return [
      index.toString(),
      transaction.userName,
      transaction.wlName,
      transaction.type,
      transaction.amount.toStringAsFixed(2),
      transaction.status.toUpperCase(),
      transaction.requestAt,
      transaction.responseAt ?? "-",
      transaction.remark ?? "-",
      transaction.ip,
    ];
  }).toList();
}
