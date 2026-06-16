import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/updateBlocs/toggle_fancy_market_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_fancy_market_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import 'manual_fancy_widget.dart';

class ManageManualMarketWidget extends StatefulWidget {
  const ManageManualMarketWidget({
    super.key,
    required this.catalogue,
    required this.backPrice,
    required this.backLine,
    required this.layPrice,
    required this.layLine,
    required this.localStatus,
    required this.isBallingRun,
    required this.pauseByAlpha,
  });
  final FancyCatalougesOnMarketType catalogue;
  final String backPrice;
  final String backLine;
  final String layPrice;
  final String layLine;
  final String localStatus;
  final bool isBallingRun;
  final bool pauseByAlpha;
  @override
  State<ManageManualMarketWidget> createState() => _ManageManualMarketWidgetState();
}

class _ManageManualMarketWidgetState extends State<ManageManualMarketWidget> {
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
                      "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                      "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                      "backs": null,
                      "lays": null,
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
                      "backs": null,
                      "lays": null,
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
                      "backs": null,
                      "lays": null,
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
                      "backs": null,
                      "lays": null,
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
