import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

import 'save_file_web_service.dart';

Future<bool> generateAndDownloadReportInExcel(
  List<String> columnNames,
  List<List<String>> rowData,
  String reportName, {
  List<int>? numericColumns,
}) async {
  try {
    ///getting the current user
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    String currDateTime = DateTime.now().toIso8601String();
    for (int i = 0; i < columnNames.length; i++) {
      sheet.setColumnWidthInPixels(i + 1, 150);
      sheet.getRangeByIndex(1, i + 1).setText(columnNames[i]);
      sheet.getRangeByIndex(1, i + 1).cellStyle.fontSize = 14;
      sheet.getRangeByIndex(1, i + 1).cellStyle.bold = true;
      sheet.getRangeByIndex(1, i + 1).cellStyle;
    }

    ///table data --- rows generation
    for (int i = 2; i < rowData.length + 2; i++) {
      List<String> thisRow = rowData[i - 2];
      for (int j = 1; j < thisRow.length + 1; j++) {
        if (numericColumns == null || numericColumns.isEmpty) {
          sheet.getRangeByIndex(i, j).setText(thisRow[j - 1]);
        } else {
          if (numericColumns.contains(j)) {
            sheet.getRangeByIndex(i, j).setNumber(double.tryParse(thisRow[j - 1]));
          } else {
            sheet.getRangeByIndex(i, j).setText(thisRow[j - 1]);
          }
        }
      }
    }

    /// set protection in all cell
    final String password = reportName;
    final ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
    options.unlockedCells = false;
    options.all = true;
    sheet.protect(password, options);

    ///---------------------------------------------------------Adding and managing data in the sheet ------ends
    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    // workbook.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, '${reportName}_$currDateTime.xlsx');
    return true;
  } catch (e, stackTrace) {
    // Handle any errors or exceptions
    if (kDebugMode) {
      debugPrint('Error generating Excel: $e');
    }
    if (kDebugMode) {
      debugPrint('Stack trace: $stackTrace');
    }
    return false; // Return false to indicate failure
  }
}
