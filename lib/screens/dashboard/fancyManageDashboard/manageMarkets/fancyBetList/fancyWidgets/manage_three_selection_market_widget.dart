import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/updateBlocs/toggle_fancy_market_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_fancy_market_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import 'manual_fancy_widget.dart';

class ManageManualThreeSelectionMarketWidget extends StatefulWidget {
  const ManageManualThreeSelectionMarketWidget({
    super.key,
    required this.catalogue,
    required this.backPrice,
    required this.backLine,
    required this.layPrice,
    required this.layLine,
    required this.localStatus,
    required this.isBallingRun,
    required this.pauseByAlpha,
    required this.back2ndPrice,
    required this.back2ndLine,
    required this.back3rdPrice,
    required this.back3rdLine,
    required this.lay2ndPrice,
    required this.lay2ndLine,
    required this.lay3rdPrice,
    required this.lay3rdLine,
  });
  final FancyCatalougesOnMarketType catalogue;
  final String backPrice;
  final String backLine;
  final String back2ndPrice;
  final String back2ndLine;
  final String back3rdPrice;
  final String back3rdLine;
  final String layPrice;
  final String layLine;
  final String lay2ndPrice;
  final String lay2ndLine;
  final String lay3rdPrice;
  final String lay3rdLine;

  final String localStatus;
  final bool isBallingRun;
  final bool pauseByAlpha;
  @override
  State<ManageManualThreeSelectionMarketWidget> createState() => _ManageManualThreeSelectionMarketWidgetState();
}

class _ManageManualThreeSelectionMarketWidgetState extends State<ManageManualThreeSelectionMarketWidget> {
  bool pauseByAlpha = false;
  bool isSettle = false;
  @override
  void initState() {
    isSettle = widget.localStatus.toUpperCase().contains("SETTLE") || widget.localStatus.toUpperCase().contains("VOID");
    pauseByAlpha = widget.pauseByAlpha;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleFancyMarketBloc, ToggleFancyMarketState>(
      builder: (context, tms) {
        if (tms is ToggleFancyMarketSuccess && tms.marketId == widget.catalogue.marketId) {
          pauseByAlpha = tms.isEnabled;
        }
        return ManualFancyWidget(
          titleStart: 'Start Market',
          titleSusp: widget.localStatus.toUpperCase().contains("SUSPENDED") ? 'Un Suspend' : 'Suspend',
          titleBall: widget.isBallingRun ? 'UnBall Run' : 'Ball Run',
          titleClose: 'Close',
          onTapStart: isSettle || !pauseByAlpha
              ? () {}
              : () {
                  context.read<ToggleFancyMarketBloc>().add(ToggleFancyMarket(marketId: widget.catalogue.marketId, enable: false, isBallRunning: false));
                },
          onTapSuspend: isSettle
              ? () {}
              : () {
                  if (widget.localStatus.toUpperCase().contains("SUSPENDED")) {
                    final updateFancyMap = {
                      "eventID": widget.catalogue.eventId,
                      "marketId": widget.catalogue.marketId,
                      "marketType": widget.catalogue.marketType,
                      "runnerId": widget.catalogue.runners.first.id,
                      "formula": "",
                      "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backPrice)},
                      "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                      "backs": [
                        {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                        {"price": double.tryParse(widget.back2ndPrice), "size": 0, "line": double.tryParse(widget.back2ndLine)},
                        {"price": double.tryParse(widget.back3rdPrice), "size": 0, "line": double.tryParse(widget.back3rdLine)},
                      ],
                      "lays": [
                        {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                        {"price": double.tryParse(widget.lay2ndPrice), "size": 0, "line": double.tryParse(widget.lay2ndLine)},
                        {"price": double.tryParse(widget.lay3rdPrice), "size": 0, "line": double.tryParse(widget.lay3rdLine)},
                      ],
                      "status": 0,
                      "isBallRunning": false,
                    };
                    context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                  } else {
                    final updateFancyMap = {
                      "eventID": widget.catalogue.eventId,
                      "marketId": widget.catalogue.marketId,
                      "marketType": widget.catalogue.marketType,
                      "runnerId": widget.catalogue.runners.first.id,
                      "backs": [
                        {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                        {"price": double.tryParse(widget.back2ndPrice), "size": 0, "line": double.tryParse(widget.back2ndLine)},
                        {"price": double.tryParse(widget.back3rdPrice), "size": 0, "line": double.tryParse(widget.back3rdLine)},
                      ],
                      "lays": [
                        {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                        {"price": double.tryParse(widget.lay2ndPrice), "size": 0, "line": double.tryParse(widget.lay2ndLine)},
                        {"price": double.tryParse(widget.lay3rdPrice), "size": 0, "line": double.tryParse(widget.lay3rdLine)},
                      ],
                      "formula": "",
                      "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                      "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                      "status": 1,
                      "isBallRunning": false,
                    };
                    context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                  }
                },
          onTapBallRunn: isSettle
              ? () {}
              : () {
                  if (widget.isBallingRun) {
                    final updateFancyMap = {
                      "eventID": widget.catalogue.eventId,
                      "marketId": widget.catalogue.marketId,
                      "marketType": widget.catalogue.marketType,
                      "runnerId": widget.catalogue.runners.first.id,
                      "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                      "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                      "backs": [
                        {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                        {"price": double.tryParse(widget.back2ndPrice), "size": 0, "line": double.tryParse(widget.back2ndLine)},
                        {"price": double.tryParse(widget.back3rdPrice), "size": 0, "line": double.tryParse(widget.back3rdLine)},
                      ],
                      "lays": [
                        {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                        {"price": double.tryParse(widget.lay2ndPrice), "size": 0, "line": double.tryParse(widget.lay2ndLine)},
                        {"price": double.tryParse(widget.lay3rdPrice), "size": 0, "line": double.tryParse(widget.lay3rdLine)},
                      ],
                      "formula": "",
                      "status": 0,
                      "isBallRunning": false,
                    };
                    context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                    return;
                  } else {
                    final updateFancyMap = {
                      "eventID": widget.catalogue.eventId,
                      "marketId": widget.catalogue.marketId,
                      "marketType": widget.catalogue.marketType,
                      "runnerId": widget.catalogue.runners.first.id,
                      "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                      "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                      "backs": [
                        {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                        {"price": double.tryParse(widget.back2ndPrice), "size": 0, "line": double.tryParse(widget.back2ndLine)},
                        {"price": double.tryParse(widget.back3rdPrice), "size": 0, "line": double.tryParse(widget.back3rdLine)},
                      ],
                      "lays": [
                        {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                        {"price": double.tryParse(widget.lay2ndPrice), "size": 0, "line": double.tryParse(widget.lay2ndLine)},
                        {"price": double.tryParse(widget.lay3rdPrice), "size": 0, "line": double.tryParse(widget.lay3rdLine)},
                      ],
                      "formula": "",
                      "status": 0,
                      "isBallRunning": true,
                    };
                    context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                  }
                },
          onTapClose: isSettle
              ? () {}
              : () {
                  context.read<ToggleFancyMarketBloc>().add(ToggleFancyMarket(marketId: widget.catalogue.marketId, enable: true, isBallRunning: false));
                },
          isDisabledStart: !pauseByAlpha || isSettle,
          isDisabledSuspn: pauseByAlpha || isSettle,
          isDisabledClose: pauseByAlpha || isSettle,
          isDisabledBallRun: pauseByAlpha || isSettle,
        );
      },
    );
  }
}
