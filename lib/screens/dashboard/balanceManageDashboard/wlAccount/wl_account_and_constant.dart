import '../../../../model/wl_full_report_model.dart';

final List<String> accountColumnNames = ['Sl No.', 'WL Name', 'Point Value', 'Net Point', 'Net Value', 'Total Win/Loss', 'Net P/L', 'Live Point', 'Live Value', 'Company Value'];

List<List<String>> generateWLaccountRows({required List<WlFullReportsData> wlFullReports}) {
  return wlFullReports.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final report = entry.value;
    return [
      index.toString(),
      report.wlName,
      report.pointValue.toStringAsFixed(2),
      report.netPoint.toStringAsFixed(2),
      report.netValue.toStringAsFixed(2),
      report.totalWL.toStringAsFixed(2),
      report.pnl.toStringAsFixed(2),
      report.livePoint.toStringAsFixed(2),
      report.liveValue.toStringAsFixed(2),
      report.companyValue.toStringAsFixed(2),
    ];
  }).toList();
}
final List<String> accountColumnNonNames = ['', '', '', '', '', '', '', '', '', ''];
