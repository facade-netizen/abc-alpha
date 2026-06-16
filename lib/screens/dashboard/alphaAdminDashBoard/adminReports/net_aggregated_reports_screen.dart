import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_net_agr_report_bloc.dart';
import '../../../../model/net_aggregated_reports_model.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';

class NetAggregatedReportsScreen extends StatefulWidget {
  const NetAggregatedReportsScreen({super.key});

  @override
  State<NetAggregatedReportsScreen> createState() => _NetAggregatedReportsScreenState();
}

class _NetAggregatedReportsScreenState extends State<NetAggregatedReportsScreen> {
  Set<String> expandedRows = {};

  @override
  void initState() {
    context.read<FetchNetAggrtReportBloc>().add(FetchNetAggrtReport());
    super.initState();
  }

  Map<String, Map<String, double>> calculateRunnerTotals(List<WlDetail> wlDetails) {
    final Map<String, Map<String, double>> runnerTotals = {};

    for (var wl in wlDetails) {
      for (var r in wl.runnerPLDetails) {
        if (!runnerTotals.containsKey(r.name)) {
          runnerTotals[r.name] = {'pnl': 0.0, 'pvPnl': 0.0};
        }
        runnerTotals[r.name]!['pnl'] = runnerTotals[r.name]!['pnl']! + r.pnl;
        runnerTotals[r.name]!['pvPnl'] = runnerTotals[r.name]!['pvPnl']! + r.pvPnl;
      }
    }
    return runnerTotals;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchNetAggrtReportBloc, FetchNetAggrtReportState>(
      builder: (context, fnr) {
        return fnr is FetchNetAggrtReportProgress
            ? LoaderContainerWithMessage()
            : fnr is FetchNetAggrtReportSuccess && fnr.naReports.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: fnr.naReports.length,
                          itemBuilder: (context, index) {
                            final naReport = fnr.naReports[index];
                            final rowKey = index.toString();
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: grey)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (expandedRows.contains(rowKey)) {
                                                  expandedRows.remove(rowKey);
                                                } else {
                                                  expandedRows.add(rowKey);
                                                }
                                              });
                                            },
                                            child: expandedRows.contains(rowKey) ? Icon(Icons.indeterminate_check_box, size: 12) : Icon(Icons.add_box_outlined, size: 12),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              naReport.marketName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(naReport.eventName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  AnimatedCrossFade(
                                    crossFadeState: expandedRows.contains(rowKey) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 300),
                                    firstChild: const SizedBox.shrink(),
                                    secondChild: !expandedRows.contains(rowKey)
                                        ? SizedBox.shrink()
                                        : SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: naReport.wlDetails.length,
                                                  itemBuilder: (context, index) {
                                                    final wlData = naReport.wlDetails[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: Container(
                                                        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.3))),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: Text(wlData.wl.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: const [
                                                                        Expanded(
                                                                          child: Text("Name", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: Text("PNL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Expanded(
                                                                          child: Text("PNL With Con", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: wlData.runnerPLDetails.length,
                                                                      itemBuilder: (context, index) {
                                                                        final runnerPLDetails = wlData.runnerPLDetails[index];
                                                                        return Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(runnerPLDetails.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                formattedAmounts(runnerPLDetails.pnl),
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: runnerPLDetails.pnl > 0
                                                                                      ? green
                                                                                      : runnerPLDetails.pnl < 0
                                                                                      ? red
                                                                                      : black,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                formattedAmounts(runnerPLDetails.pvPnl),
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: runnerPLDetails.pvPnl > 0
                                                                                      ? green
                                                                                      : runnerPLDetails.pvPnl < 0
                                                                                      ? red
                                                                                      : black,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    final runnerTotals = calculateRunnerTotals(naReport.wlDetails);
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 10),
                                                          child: Text("Total Across WLs", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(child: SizedBox()),
                                                            Expanded(child: SizedBox()),
                                                            Expanded(child: SizedBox()),
                                                            Expanded(
                                                              child: Text("Teams", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                                            ),
                                                            Expanded(
                                                              child: Text("PNL", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                                            ),
                                                            Expanded(
                                                              child: Text("PNl With Con", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                                            ),
                                                          ],
                                                        ),
                                                        ...runnerTotals.entries.map((entry) {
                                                          final name = entry.key;
                                                          final pnl = entry.value['pnl']!;
                                                          final pvPnl = entry.value['pvPnl']!;
                                                          return Row(
                                                            children: [
                                                              Expanded(child: SizedBox()),
                                                              Expanded(child: SizedBox()),
                                                              Expanded(child: SizedBox()),
                                                              Expanded(child: Text(name, style: TextStyle(fontSize: 12))),
                                                              Expanded(
                                                                child: Text(
                                                                  formattedAmounts(pnl),
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: pnl > 0
                                                                        ? green
                                                                        : pnl < 0
                                                                        ? red
                                                                        : black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  formattedAmounts(pvPnl),
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: pvPnl > 0
                                                                        ? green
                                                                        : pvPnl < 0
                                                                        ? red
                                                                        : black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : NoData();
      },
    );
  }
}
