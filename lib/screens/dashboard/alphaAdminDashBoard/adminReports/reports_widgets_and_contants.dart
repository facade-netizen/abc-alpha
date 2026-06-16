import '../../../../model/wl_report_model.dart';

final List<String> wlReportsColumnNames = ['S.No', 'White Name', 'Admin Name', 'Points', 'Point Value', 'Value'];
List<List<String>> generateWLReportsDataRows({required List<WLNetReports> wlNetReports}) {
  return wlNetReports.asMap().entries.map((entry) {
    final index = entry.key + 1;
    final wlDetails = entry.value;
    return [
      index.toString(),
      wlDetails.wlName.toUpperCase(),
      wlDetails.adminName,
      wlDetails.points.toStringAsFixed(2),
      wlDetails.pointValue.toStringAsFixed(2),
      wlDetails.value.toStringAsFixed(2),
    ];
  }).toList();
}
