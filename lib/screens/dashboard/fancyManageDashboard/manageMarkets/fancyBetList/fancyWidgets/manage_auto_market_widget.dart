import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/updateBlocs/toggle_fancy_market_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_fancy_market_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';

class ManageAutoMarketWidget extends StatefulWidget {
  const ManageAutoMarketWidget({
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
  State<ManageAutoMarketWidget> createState() => _ManageAutoMarketWidgetState();
}

class _ManageAutoMarketWidgetState extends State<ManageAutoMarketWidget> {
  bool pauseByAlpha = false;
  @override
  void initState() {
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
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: white,
            border: Border(bottom: BorderSide()),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 110,
                  child: CheckboxListTile(
                    value: pauseByAlpha,
                    onChanged: (value) {
                      setState(() {
                        pauseByAlpha = value!;
                      });
                      context.read<ToggleFancyMarketBloc>().add(ToggleFancyMarket(marketId: widget.catalogue.marketId, enable: value!, isBallRunning: false));
                    },
                    title: Text(pauseByAlpha ? "Manual" : "Auto", style: const TextStyle(fontSize: 12)),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                CustomHoverButton(
                  width: 120,
                  height: 30,
                  isDisabled: !pauseByAlpha,
                  onPressed: () {
                    if (widget.localStatus.toUpperCase().contains("SUSPENDED")) {
                      final updateFancyMap = {
                        "eventID": widget.catalogue.eventId,
                        "marketId": widget.catalogue.marketId,
                        "marketType": widget.catalogue.marketType,
                        "runnerId": widget.catalogue.runners.first.id,
                        "formula": "",
                        "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                        "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                        "status": 0,
                        "isBallRunning": false,
                        "backs": null,
                        "lays": null,
                      };
                      context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                    } else {
                      final updateFancyMap = {
                        "eventID": widget.catalogue.eventId,
                        "marketId": widget.catalogue.marketId,
                        "marketType": widget.catalogue.marketType,
                        "runnerId": widget.catalogue.runners.first.id,
                        "formula": "",
                        "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                        "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                        "status": 1,
                        "isBallRunning": false,
                        "backs": null,
                        "lays": null,
                      };
                      context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                    }
                  },
                  title: widget.localStatus.toUpperCase().contains("SUSPENDED") ? 'Un Suspend' : 'Suspend',
                  textColor: white,
                ),
                CustomHoverButton(
                  width: 120,
                  height: 30,
                  isDisabled: !pauseByAlpha,
                  onPressed: () {
                    if (widget.isBallingRun) {
                      final updateFancyMap = {
                        "eventID": widget.catalogue.eventId,
                        "marketId": widget.catalogue.marketId,
                        "marketType": widget.catalogue.marketType,
                        "runnerId": widget.catalogue.runners.first.id,
                        "back": {"price": double.tryParse(widget.backPrice), "size": 0, "line": double.tryParse(widget.backLine)},
                        "lay": {"price": double.tryParse(widget.layPrice), "size": 0, "line": double.tryParse(widget.layLine)},
                        "formula": "",
                        "status": 0,
                        "isBallRunning": false,
                        "backs": null,
                        "lays": null,
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
                        "formula": "",
                        "status": 0,
                        "isBallRunning": true,
                        "backs": null,
                        "lays": null,
                      };
                      context.read<UpdateFancyMarketBloc>().add(UpdateFancyMarket(updateFancyMap: updateFancyMap));
                    }
                  },
                  title: widget.isBallingRun ? 'UnBall Run' : 'Ball Run',
                  textColor: white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
