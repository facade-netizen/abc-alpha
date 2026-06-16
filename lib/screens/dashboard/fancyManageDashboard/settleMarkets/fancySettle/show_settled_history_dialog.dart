import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/fetchBlocs/fetch_settle_history_bloc.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../reusable/loader.dart';
import '../../betlistConstant/betlist_string_constants.dart';

Future showMarketSettleHistoryDialog(BuildContext context, String marketId) {
  return showDialog(
    context: context,
    builder: (context) => ShowSettledHistoryDialogBody(marketId: marketId),
  );
}

class ShowSettledHistoryDialogBody extends StatefulWidget {
  const ShowSettledHistoryDialogBody({super.key, required this.marketId});
  final String marketId;

  @override
  State<ShowSettledHistoryDialogBody> createState() => _ShowSettledHistoryDialogBodyState();
}

class _ShowSettledHistoryDialogBodyState extends State<ShowSettledHistoryDialogBody> {
  @override
  void initState() {
    super.initState();
    context.read<FetchSettleHistoryBloc>().add(FetchSettleHistory(marketId: widget.marketId));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.6;
    final dialogHeight = size.height * 0.7;
    return CustomAlertDialog(
      title: 'Settle Logs',
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: BlocBuilder<FetchSettleHistoryBloc, FetchSettleHistoryState>(
          builder: (context, shs) {
            if (shs is FetchSettleHistoryProgress) {
              return const LoaderContainerWithMessage();
            } else if (shs is! FetchSettleHistorySuccess || shs.settleHistory.isEmpty) {
              return const Center(child: SelectableText("No settle history found"));
            }
            return Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                    headingTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                    dataRowMinHeight: 30,
                    dataRowMaxHeight: 30,
                    headingRowHeight: 30,
                    border: TableBorder(
                      top: BorderSide(color: grey, width: 0.5),
                      bottom: BorderSide(color: grey, width: 0.5),
                    ),
                    columns: fancySettleHis.map((header) => DataColumn(label: SelectableText(header))).toList(),
                    rows: shs.settleHistory.map((market) {
                      return DataRow(
                        cells: [
                          DataCell(SelectableText(market.id.toString(), style: const TextStyle(fontSize: 11))),
                          DataCell(SelectableText(market.marketId, style: const TextStyle(fontSize: 11))),
                          DataCell(SelectableText(market.result.toString(), style: const TextStyle(fontSize: 11))),
                          DataCell(SelectableText(market.settleType.toString(), style: const TextStyle(fontSize: 11))),
                          DataCell(SelectableText(market.createdDateUtcString, style: const TextStyle(fontSize: 11))),
                          DataCell(SelectableText(market.operator, style: const TextStyle(fontSize: 11))),
                          DataCell(const SelectableText("Change summary balance log completed", style: TextStyle(fontSize: 11))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
