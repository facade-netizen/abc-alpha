import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/fetchBlocs/fetch_fancy_bet_exposure_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalRStreamers/fancy_live_exposure_data_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_fancy_market_bloc.dart';
import '../../../../../../model/fancy_bet_exposure_model.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../fancyDialogs/show_runs_odds_history_dialog.dart' show showRunsOddsHistoryDialog;
import 'fancy_market_widget.dart';

class MarketRunnerRateWidget extends StatefulWidget {
  const MarketRunnerRateWidget({
    super.key,
    required this.catalogue,
    required this.backPrice,
    required this.backLine,
    required this.layPrice,
    required this.layLine,
    required this.isBallingRun,
    required this.localStatus,
  });
  final FancyCatalougesOnMarketType catalogue;
  final String backPrice;
  final String backLine;
  final String layPrice;
  final String layLine;
  final bool isBallingRun;
  final String localStatus;

  @override
  State<MarketRunnerRateWidget> createState() => _MarketRunnerRateWidgetState();
}

class _MarketRunnerRateWidgetState extends State<MarketRunnerRateWidget> {
  TextEditingController inputController = TextEditingController();
  final FocusNode inputFocus = FocusNode();
  double yesExp = 0.0;
  double noExp = 0.0;

  @override
  void initState() {
    super.initState();
    inputFocus.onKeyEvent = _handleKeyEvent;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _submitInput();
      return KeyEventResult.handled; // Prevent default unfocus behavior
    }
    return KeyEventResult.ignored;
  }

  void _submitInput() {
    final text = inputController.text;
    Map<String, dynamic> updateFancyMap;

    if (text.isEmpty) {
      updateFancyMap = {
        "eventID": widget.catalogue.eventId,
        "marketId": widget.catalogue.marketId,
        "marketType": widget.catalogue.marketType,
        "runnerId": widget.catalogue.runners.first.id,
        "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
        "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
        "status": 0,
        "formula": text,
        "isBallRunning": true,
        "backs": null,
        "lays": null,
      };
    } else if (text == "0") {
      updateFancyMap = {
        "eventID": widget.catalogue.eventId,
        "marketId": widget.catalogue.marketId,
        "marketType": widget.catalogue.marketType,
        "runnerId": widget.catalogue.runners.first.id,
        "back": {"price": double.tryParse(widget.backPrice) ?? "0", "size": 0, "line": double.tryParse(widget.backLine) ?? "0"},
        "lay": {"price": double.tryParse(widget.layPrice) ?? "0", "size": 0, "line": double.tryParse(widget.layLine) ?? "0"},
        "status": 1,
        "formula": "",
        "isBallRunning": false,
        "backs": null,
        "lays": null,
      };
    } else if (text == "00") {
      updateFancyMap = {
        "eventID": widget.catalogue.eventId,
        "marketId": widget.catalogue.marketId,
        "marketType": widget.catalogue.marketType,
        "runnerId": widget.catalogue.runners.first.id,
        "back": {"price": double.tryParse(widget.backPrice) ?? "0", "size": 0, "line": double.tryParse(widget.backLine) ?? "0"},
        "lay": {"price": double.tryParse(widget.layPrice) ?? "0", "size": 0, "line": double.tryParse(widget.layLine) ?? "0"},
        "status": 0,
        "formula": "",
        "isBallRunning": false,
        "backs": null,
        "lays": null,
      };
    } else {
      updateFancyMap = {
        "eventID": widget.catalogue.eventId,
        "marketId": widget.catalogue.marketId,
        "marketType": widget.catalogue.marketType,
        "runnerId": widget.catalogue.runners.first.id,
        "back": {"price": double.tryParse(widget.backPrice) ?? "0", "size": 0, "line": double.tryParse(widget.backLine) ?? "0"},
        "lay": {"price": double.tryParse(widget.layPrice) ?? "0", "size": 0, "line": double.tryParse(widget.layLine) ?? "0"},
        "status": 0,
        "formula": text,
        "isBallRunning": false,
        "backs": null,
        "lays": null,
      };
    }

    context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
    inputController.clear();
    // Focus stays because we returned KeyEventResult.handled — no re-request needed
  }

  @override
  void dispose() {
    inputController.dispose();
    inputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text("")),
              Expanded(
                child: CustomTableCell(text: "No", bg: Colors.red.shade200, bold: true),
              ),
              Expanded(
                child: CustomTableCell(text: "Yes", bg: Colors.blue.shade300, bold: true),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: CustomTableCell(text: widget.catalogue.marketName)),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.layPrice}"), value: widget.layLine, isBack: false),
                        ),
                        Expanded(
                          child: FancyMarketRunnerBox(key: ValueKey("back_${widget.backPrice}"), value: widget.backLine, isBack: true),
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
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("")),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FancyMarketRunnerBox(key: ValueKey("lay_${widget.layPrice}"), value: widget.layPrice, isBack: false),
                        ),
                        Expanded(
                          child: FancyMarketRunnerBox(key: ValueKey("back_${widget.backPrice}"), value: widget.backPrice, isBack: true),
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
              ),
            ],
          ),
          BlocBuilder<FetchFancyBetExposureBloc, FetchFancyBetExposureState>(
            builder: (context, bes) {
              List<FancyBetData> fancyBetData = [];
              if (bes is FetchFancyBetExposureSuccess) {
                fancyBetData = bes.fancyBetData;
              }
              return BlocBuilder<FancyLiveBetExposureBloc, FancyLiveBetExposureState>(
                builder: (context, ble) {
                  yesExp = ble is FancyLiveBetExposureSuccess
                      ? ble.fancyLiveBetExposure.exposureYes
                      : fancyBetData.isNotEmpty
                      ? fancyBetData.first.exposureYes
                      : 0.0;
                  noExp = ble is FancyLiveBetExposureSuccess
                      ? ble.fancyLiveBetExposure.exposureNo
                      : fancyBetData.isNotEmpty
                      ? fancyBetData.first.exposureNo
                      : 0.0;
                  return Row(
                    children: [
                      Expanded(child: CustomTableCell(text: "Current Odds Exposure")),
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
                      autofocus: true,
                      focusNode: inputFocus,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(fontSize: 14),
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
                    ),
                  ),
                ),
                wb8,
                CustomOutlineTextButton(
                  width: 120,
                  height: 30,
                  onPressed: () {
                    showRunsOddsHistoryDialog(context, widget.catalogue.marketId).whenComplete(() {
                      if (mounted) inputFocus.requestFocus();
                    });
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
    );
  }
}
