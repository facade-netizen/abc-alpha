import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/fetchBlocs/fetch_fancy_bet_exposure_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalRStreamers/fancy_live_exposure_data_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_fancy_market_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_fancy_three_selection_bloc.dart';
import '../../../../../../model/fancy_bet_exposure_model.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../../../../reusable/snack_bar.dart';
import '../fancyDialogs/show_runs_odds_history_dialog.dart';
import 'fancy_market_widget.dart';

class ManageThreeSelectionsMarketRateWidget extends StatefulWidget {
  const ManageThreeSelectionsMarketRateWidget({
    super.key,
    required this.catalogue,
    required this.isBallingRun,
    required this.localStatus,
    required this.back1stPrice,
    required this.back1stLine,
    required this.back2ndPrice,
    required this.back2ndLine,
    required this.back3rdPrice,
    required this.back3rdLine,
    required this.lay1stPrice,
    required this.lay1stLine,
    required this.lay2ndPrice,
    required this.lay2ndLine,
    required this.lay3rdPrice,
    required this.lay3rdLine,
  });
  final FancyCatalougesOnMarketType catalogue;
  final bool isBallingRun;
  final String localStatus;
  final String back1stPrice;
  final String back1stLine;
  final String back2ndPrice;
  final String back2ndLine;
  final String back3rdPrice;
  final String back3rdLine;
  final String lay1stPrice;
  final String lay1stLine;
  final String lay2ndPrice;
  final String lay2ndLine;
  final String lay3rdPrice;
  final String lay3rdLine;

  @override
  State<ManageThreeSelectionsMarketRateWidget> createState() => _ManageThreeSelectionsMarketRateWidgetState();
}

class _ManageThreeSelectionsMarketRateWidgetState extends State<ManageThreeSelectionsMarketRateWidget> {
  TextEditingController inputController = TextEditingController();
  final FocusNode inputFocus = FocusNode();
  double yesExp = 0.0;
  double noExp = 0.0;
  String keeps = "";
  bool keep0 = false;
  bool keep1 = false;
  bool keep2 = false;
  String formulaForSuspend = "";
  void updateKeeps() {
    List<String> selected = [];
    if (keep0) selected.add("0");
    if (keep1) selected.add("1");
    if (keep2) selected.add("2");
    keeps = selected.join(",");
  }

  @override
  void dispose() {
    inputController.dispose();
    inputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateFancyThreeSelectionBloc, UpdateFancyThreeSelectionState>(
      listener: (context, tss) {
        if (tss is UpdateFancyThreeSelectionSuccess) {
          final updateFancyMap = {
            "eventID": widget.catalogue.eventId,
            "marketId": widget.catalogue.marketId,
            "marketType": widget.catalogue.marketType,
            "runnerId": widget.catalogue.runners.first.id,
            "back": {"price": double.tryParse(widget.back1stPrice) ?? 0, "size": 0, "line": double.tryParse(widget.back1stLine) ?? 0},
            "lay": {"price": double.tryParse(widget.lay1stPrice) ?? 0, "size": 0, "line": double.tryParse(widget.lay1stLine) ?? 0},
            "status": 0,
            "backs": tss.getMapFromResponse["backs"],
            "lays": tss.getMapFromResponse["lays"],
            "formula": "",
            "isBallRunning": false,
          };
          if (!(formulaForSuspend == "0")) {
            context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
          }
        }
        if (tss is UpdateFancyThreeSelectionFailure) {
          showSnackBar(context, tss.error, error: true);
        }
      },
      builder: (context, tss) {
        return Container(
          width: 800,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(children: [CustomTableCell(text: "Market Name")]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(children: [CustomTableCell(text: "Keep")]),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTableCell(text: "No", bg: Colors.red.shade200, bold: true),
                          ),
                          Expanded(
                            child: CustomTableCell(text: "Yes", bg: Colors.blue.shade300, bold: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CustomTableCell(text: widget.catalogue.marketName),
                              CustomTableCell(text: "Odds"),
                              CustomTableCell(text: "Current Odds Exposure"),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CustomTableCell(text: ""),
                              Checkbox(
                                value: keep0,
                                onChanged: (value) {
                                  setState(() {
                                    keep0 = value ?? false;
                                    updateKeeps();
                                  });
                                },
                              ),
                              CustomTableCell(text: ""),
                            ],
                          ),
                        ),
                        //1st Line
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.lay1stLine}"), value: widget.lay1stLine, isBack: false),
                                      ),
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("back_${widget.back1stLine}"), value: widget.back1stLine, isBack: true),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Visibility(
                                      visible: widget.isBallingRun || !(widget.localStatus.toLowerCase().contains("active") || widget.localStatus.toLowerCase().contains("open")),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                                        child: Center(
                                          child: Text(
                                            widget.isBallingRun ? "Ball Run" : "Suspended",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.lay1stPrice}"), value: widget.lay1stPrice, isBack: false),
                                      ),
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("back_${widget.back1stPrice}"), value: widget.back1stPrice, isBack: true),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Visibility(
                                      visible: widget.isBallingRun || !(widget.localStatus.toLowerCase().contains("active") || widget.localStatus.toLowerCase().contains("open")),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                                        child: Center(
                                          child: Text(
                                            widget.isBallingRun ? "Ball Run" : "Suspended",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Exposure Row
                              BlocBuilder<FetchFancyBetExposureBloc, FetchFancyBetExposureState>(
                                builder: (context, bes) {
                                  List<FancyBetData> fancyBetData = [];
                                  if (bes is FetchFancyBetExposureSuccess) {
                                    fancyBetData = bes.fancyBetData;
                                  }

                                  return BlocBuilder<FancyLiveBetExposureBloc, FancyLiveBetExposureState>(
                                    builder: (context, ble) {
                                      double yesExp = ble is FancyLiveBetExposureSuccess
                                          ? ble.fancyLiveBetExposure.exposureYes
                                          : fancyBetData.isNotEmpty
                                          ? fancyBetData.first.exposureYes
                                          : 0.0;

                                      double noExp = ble is FancyLiveBetExposureSuccess
                                          ? ble.fancyLiveBetExposure.exposureNo
                                          : fancyBetData.isNotEmpty
                                          ? fancyBetData.first.exposureNo
                                          : 0.0;

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: CustomTableCell(text: "$noExp", bg: Colors.red.shade100, bold: true),
                                          ),
                                          Expanded(
                                            child: CustomTableCell(text: "$yesExp", bg: Colors.blue.shade100, bold: true),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(color: black),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CustomTableCell(text: widget.catalogue.marketName),
                              CustomTableCell(text: "Odds"),
                              CustomTableCell(text: "Current Odds Exposure"),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CustomTableCell(text: ""),
                              Checkbox(
                                value: keep1,
                                onChanged: (value) {
                                  setState(() {
                                    keep1 = value ?? false;
                                    updateKeeps();
                                  });
                                },
                              ),
                              CustomTableCell(text: ""),
                            ],
                          ),
                        ),

                        //2nd Line
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.lay2ndLine}"), value: widget.lay2ndLine, isBack: false),
                                      ),
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("back_${widget.back2ndLine}"), value: widget.back2ndLine, isBack: true),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Visibility(
                                      visible:
                                          widget.isBallingRun ||
                                          !(widget.localStatus.toLowerCase().contains("online") ||
                                              widget.localStatus.toLowerCase().contains("active") ||
                                              widget.localStatus.toLowerCase().contains("open")),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                                        child: Center(
                                          child: Text(
                                            widget.isBallingRun ? "Ball Run" : "Suspended",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.lay2ndPrice}"), value: widget.lay2ndPrice, isBack: false),
                                      ),
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("back_${widget.back2ndPrice}"), value: widget.back2ndPrice, isBack: true),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Visibility(
                                      visible:
                                          widget.isBallingRun ||
                                          !(widget.localStatus.toLowerCase().contains("online") ||
                                              widget.localStatus.toLowerCase().contains("active") ||
                                              widget.localStatus.toLowerCase().contains("open")),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                                        child: Center(
                                          child: Text(
                                            widget.isBallingRun ? "Ball Run" : "Suspended",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Exposure Row
                              BlocBuilder<FetchFancyBetExposureBloc, FetchFancyBetExposureState>(
                                builder: (context, bes) {
                                  List<FancyBetData> fancyBetData = [];
                                  if (bes is FetchFancyBetExposureSuccess) {
                                    fancyBetData = bes.fancyBetData;
                                  }

                                  return BlocBuilder<FancyLiveBetExposureBloc, FancyLiveBetExposureState>(
                                    builder: (context, ble) {
                                      double yesExp = ble is FancyLiveBetExposureSuccess
                                          ? ble.fancyLiveBetExposure.exposureYes
                                          : fancyBetData.isNotEmpty
                                          ? fancyBetData.first.exposureYes
                                          : 0.0;

                                      double noExp = ble is FancyLiveBetExposureSuccess
                                          ? ble.fancyLiveBetExposure.exposureNo
                                          : fancyBetData.isNotEmpty
                                          ? fancyBetData.first.exposureNo
                                          : 0.0;

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: CustomTableCell(text: "$noExp", bg: Colors.red.shade100, bold: true),
                                          ),
                                          Expanded(
                                            child: CustomTableCell(text: "$yesExp", bg: Colors.blue.shade100, bold: true),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(color: black),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CustomTableCell(text: widget.catalogue.marketName),
                              CustomTableCell(text: "Odds"),
                              CustomTableCell(text: "Current Odds Exposure"),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CustomTableCell(text: ""),
                              Checkbox(
                                value: keep2,
                                onChanged: (value) {
                                  setState(() {
                                    keep2 = value ?? false;
                                    updateKeeps();
                                  });
                                },
                              ),
                              CustomTableCell(text: ""),
                            ],
                          ),
                        ),

                        //3rd line
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.back3rdLine}"), value: widget.lay3rdLine, isBack: false),
                                      ),
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("back_${widget.back3rdLine}"), value: widget.back3rdLine, isBack: true),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Visibility(
                                      visible: widget.isBallingRun || !(widget.localStatus.toLowerCase().contains("active") || widget.localStatus.toLowerCase().contains("open")),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                                        child: Center(
                                          child: Text(
                                            widget.isBallingRun ? "Ball Run" : "Suspended",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.lay3rdPrice}"), value: widget.lay3rdPrice, isBack: false),
                                      ),
                                      Expanded(
                                        child: FancyMarketRunnerBox(key: ValueKey("back_${widget.back3rdPrice}"), value: widget.back3rdPrice, isBack: true),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Visibility(
                                      visible: widget.isBallingRun || !(widget.localStatus.toLowerCase().contains("active") || widget.localStatus.toLowerCase().contains("open")),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                                        child: Center(
                                          child: Text(
                                            widget.isBallingRun ? "Ball Run" : "Suspended",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Exposure Row
                              BlocBuilder<FetchFancyBetExposureBloc, FetchFancyBetExposureState>(
                                builder: (context, bes) {
                                  List<FancyBetData> fancyBetData = [];
                                  if (bes is FetchFancyBetExposureSuccess) {
                                    fancyBetData = bes.fancyBetData;
                                  }

                                  return BlocBuilder<FancyLiveBetExposureBloc, FancyLiveBetExposureState>(
                                    builder: (context, ble) {
                                      double yesExp = ble is FancyLiveBetExposureSuccess
                                          ? ble.fancyLiveBetExposure.exposureYes
                                          : fancyBetData.isNotEmpty
                                          ? fancyBetData.first.exposureYes
                                          : 0.0;

                                      double noExp = ble is FancyLiveBetExposureSuccess
                                          ? ble.fancyLiveBetExposure.exposureNo
                                          : fancyBetData.isNotEmpty
                                          ? fancyBetData.first.exposureNo
                                          : 0.0;

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: CustomTableCell(text: "$noExp", bg: Colors.red.shade100, bold: true),
                                          ),
                                          Expanded(
                                            child: CustomTableCell(text: "$yesExp", bg: Colors.blue.shade100, bold: true),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(color: black),
                  ],
                ),
                hb8,
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      const Text("Input:", style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          width: 80,
                          child: TextFormField(
                            controller: inputController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(fontSize: 14),
                            autofocus: true,
                            focusNode: inputFocus,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              labelStyle: const TextStyle(fontSize: 14),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: blue, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: grey, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              final formula = inputController.text;
                              setState(() {
                                formulaForSuspend = inputController.text;
                              });
                              if (formula.isEmpty) {
                                final updateFancyMap = {
                                  "eventID": widget.catalogue.eventId,
                                  "marketId": widget.catalogue.marketId,
                                  "marketType": widget.catalogue.marketType,
                                  "runnerId": widget.catalogue.runners.first.id,
                                  "back": {"price": double.tryParse(widget.back1stPrice), "size": 0, "line": double.tryParse(widget.back1stLine)},
                                  "lay": {"price": double.tryParse(widget.lay1stPrice), "size": 0, "line": double.tryParse(widget.lay1stLine)},
                                  "backs": [
                                    {"price": double.tryParse(widget.back1stPrice), "size": 0, "line": double.tryParse(widget.back1stLine)},
                                    {"price": double.tryParse(widget.back2ndPrice), "size": 0, "line": double.tryParse(widget.back2ndLine)},
                                    {"price": double.tryParse(widget.back3rdPrice), "size": 0, "line": double.tryParse(widget.back3rdLine)},
                                  ],
                                  "lays": [
                                    {"price": double.tryParse(widget.lay1stPrice), "size": 0, "line": double.tryParse(widget.lay1stLine)},
                                    {"price": double.tryParse(widget.lay2ndPrice), "size": 0, "line": double.tryParse(widget.lay2ndLine)},
                                    {"price": double.tryParse(widget.lay3rdPrice), "size": 0, "line": double.tryParse(widget.lay3rdLine)},
                                  ],
                                  "status": 0,
                                  "formula": inputController.text,
                                  "isBallRunning": true,
                                };
                                context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                                inputController.clear();
                              } else {
                                final updateFancyThreeSelectionMap = {
                                  "formula": formula,
                                  "keep": keeps,
                                  "marketId": widget.catalogue.marketId,
                                  "marketType": widget.catalogue.marketType,
                                };
                                context.read<UpdateFancyThreeSelectionBloc>().add(UpdateFancyThreeSelection(updateFancyThreeSelectionMap: updateFancyThreeSelectionMap));
                                inputController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      wb8,
                      CustomOutlineTextButton(
                        width: 120,
                        height: 30,
                        onPressed: () {
                          showRunsOddsHistoryDialog(context, widget.catalogue.marketId);
                        },
                        title: 'History',
                        boxColor: blue,
                        textColor: white,
                        borderColor: blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
