import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/fetchBlocs/fetch_fancy_bet_exposure_bloc.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../../reusable/loader.dart';
import '../../../betlistConstant/betlist_string_constants.dart';

Future showRunsOddsHistoryDialog(BuildContext context, String marketId) {
  final exposureBloc = context.read<FetchFancyBetExposureBloc>();
  return showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: exposureBloc,
      child: ShowRunsOddsHistoryDialogBody(marketId: marketId),
    ),
  );
}

class ShowRunsOddsHistoryDialogBody extends StatefulWidget {
  const ShowRunsOddsHistoryDialogBody({super.key, required this.marketId});
  final String marketId;
  @override
  State<ShowRunsOddsHistoryDialogBody> createState() => _ShowRunsOddsHistoryDialogBodyState();
}

class _ShowRunsOddsHistoryDialogBodyState extends State<ShowRunsOddsHistoryDialogBody> {
  @override
  void initState() {
    context.read<FetchFancyBetExposureBloc>().add(FetchFancyBetExposure(marketId: widget.marketId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Runs Odds History',
      content: BlocBuilder<FetchFancyBetExposureBloc, FetchFancyBetExposureState>(
        builder: (context, bes) {
          return SizedBox(
            height: 500,
            child: bes is FetchFancyBetExposureProgress
                ? LoaderContainerWithMessage()
                : bes is FetchFancyBetExposureSuccess
                ? Column(
                    children: [
                      DataTable(
                        showCheckboxColumn: false,
                        headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                        headingTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                        dataRowMinHeight: 35,
                        dataRowMaxHeight: 35,
                        headingRowHeight: 30,
                        border: TableBorder(
                          top: BorderSide(color: grey, width: 0.5),
                          bottom: BorderSide(color: grey, width: 0.5),
                        ),
                        columns: runsOddHisTitle.map((header) => DataColumn(label: Text(header))).toList(),
                        rows: bes.fancyBetData.map((event) {
                          return DataRow(
                            cells: [
                              DataCell(Text('${event.runsNo}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('${event.runsYes}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('${event.oddsNo}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('${event.oddsYes}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('${event.exposureNo}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('${event.exposureNo}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('${event.createdTime}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text(event.creatorName, style: const TextStyle(fontSize: 12))),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
