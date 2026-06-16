import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/fetchBlocs/fetch_catalouges_on_markettype_bloc.dart';
import '../../../../../../bloc/fetchBlocs/fetch_fancy_events_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalr_event_listener_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalRStreamers/fancy_market_signalr_data_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_suspend_ballrun_all_fancy_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../model/fancy_events_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/date_time_formatter.dart';
import '../../../../../../reusable/loader.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../fancyDialogs/update_market_time_dialog.dart';
import '../fancyWidgets/fancy_bet_tile.dart';
import '../fancyWidgets/fancy_market_widget.dart';

class FancyManagerScreen extends StatefulWidget {
  const FancyManagerScreen({super.key, this.toggleScreen, this.fancyEventData, this.eventId});
  final FancyEventData? fancyEventData;
  final Function(FancyEventData fancyBetEventData)? toggleScreen;

  /// When navigated via GoRouter, eventId is passed as path param instead of fancyEventData.
  final String? eventId;

  @override
  State<FancyManagerScreen> createState() => _FancyManagerScreenState();
}

class _FancyManagerScreenState extends State<FancyManagerScreen> {
  String get _effectiveEventId => widget.fancyEventData?.id ?? widget.eventId ?? "0";

  @override
  void initState() {
    super.initState();
    context.read<FetchCatalougeOnMarketTypeBloc>().add(FetchCatalougeOnMarketType(eventId: int.tryParse(_effectiveEventId) ?? 0, marketType: ""));
    context.read<SignalREventListenerBloc>().add(SignalREventListener(eventId: _effectiveEventId));
    context.read<SignalRFancyMarketDataBloc>().add(SignalRFancyMarketDataListener());

    // For URL navigation (no fancyEventData passed): eagerly fetch today's fancy events
    if (widget.fancyEventData == null) {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00.000';
      context.read<FetchFancyEventsBloc>().add(FetchFancyEvents(selectedDate: dateStr));
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- Resolve event data ---
    FancyEventData? event = widget.fancyEventData;

    if (event == null) {
      // Watch the bloc so the widget auto-rebuilds when the fetch completes
      final fancyState = context.watch<FetchFancyEventsBloc>().state;
      if (fancyState is FetchFancyEventsSuccess) {
        for (final e in fancyState.eventDetails) {
          if (e.id == _effectiveEventId) {
            event = e;
            break;
          }
        }
      }
    }

    final resolvedEventName = event?.name ?? '-';
    final resolvedStartDate = event?.openDate;
    final resolvedCompetition = event?.competitionId != null ? event!.competitionId.toString() : '-';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FancyBetListHeader(
            title: "Manager Page",
            onTap: () {
              context.read<SignalREventListenerBloc>().add(SignalREventDisconnect(eventId: _effectiveEventId));
              context.read<SignalRFancyMarketDataBloc>().add(SetToInitialSignalRFancy());
            },
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: lightBlueShade,
              border: Border(bottom: BorderSide(color: black, width: 0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hb5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText("Event Id:", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb2,
                      SelectableText('$_effectiveEventId', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  hb5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText("Market Day:", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb2,
                      SelectableText("1", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  hb5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText("Event Start Date:", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb2,
                      SelectableText(resolvedStartDate != null ? formatDateString(resolvedStartDate) : "-", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  hb5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText("Competition:", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb2,
                      SelectableText(resolvedCompetition, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  hb5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText("Event Name:", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb2,
                      SelectableText(resolvedEventName, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  hb5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText("Market Start Date :", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb2,
                      SelectableText(resolvedStartDate != null ? formatDateString(resolvedStartDate) : "-", style: TextStyle(fontSize: 14)),
                      wb10,
                      CustomHoverButton(
                        width: 70,
                        height: 25,
                        onPressed: () {
                          showUpdateMarketTimeDialog(context, event);
                        },
                        title: 'Edit',
                        textColor: white,
                      ),
                    ],
                  ),
                  hb5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomHoverButton(
                        width: 70,
                        height: 25,
                        onPressed: () {
                          context.read<UpdateFancyMarketSuspendBallRunBloc>().add(
                            UpdateFancyMarketSuspendBallRun(updateFancyMarketSuspendBallRunMap: {'eventId': _effectiveEventId, 'isBallRunning': false, "isPause": true}),
                          );
                        },
                        title: 'Suspend',
                        textColor: white,
                      ),
                      wb10,
                      CustomHoverButton(
                        width: 80,
                        height: 25,
                        onPressed: () {
                          context.read<UpdateFancyMarketSuspendBallRunBloc>().add(
                            UpdateFancyMarketSuspendBallRun(updateFancyMarketSuspendBallRunMap: {'eventId': _effectiveEventId, 'isBallRunning': false, "isPause": false}),
                          );
                        },
                        title: 'UnSuspend',
                        textColor: white,
                      ),
                      wb10,
                      CustomHoverButton(
                        width: 70,
                        height: 25,
                        onPressed: () {
                          context.read<UpdateFancyMarketSuspendBallRunBloc>().add(
                            UpdateFancyMarketSuspendBallRun(updateFancyMarketSuspendBallRunMap: {'eventId': _effectiveEventId, 'isBallRunning': true, "isPause": true}),
                          );
                        },
                        title: 'Ball Run',
                        textColor: white,
                      ),
                      wb10,
                      CustomHoverButton(
                        width: 120,
                        height: 25,
                        onPressed: () {
                          context.read<UpdateFancyMarketSuspendBallRunBloc>().add(
                            UpdateFancyMarketSuspendBallRun(updateFancyMarketSuspendBallRunMap: {'eventId': _effectiveEventId, 'isBallRunning': false, "isPause": false}),
                          );
                        },
                        title: 'UnBall Runn',
                        textColor: white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          hb40,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(color: fancyOpac),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SelectableText(
                    "Fancy",
                    style: TextStyle(fontWeight: FontWeight.w500, color: white),
                  ),
                ),
              ),
              Container(color: fancyOpac, width: double.infinity, height: 2),
            ],
          ),
          BlocBuilder<FetchCatalougeOnMarketTypeBloc, FetchCatalougeOnMarketTypeState>(
            builder: (context, cms) {
              List<FancyCatalougesOnMarketType> catalogues = [];
              if (cms is FetchCatalougeOnMarketTypeSuccess) {
                catalogues = cms.catalougeDetails;
              }
              return BlocBuilder<SignalRFancyMarketDataBloc, SignalRFancyMarketDataState>(
                builder: (context, frd) {
                  List<FancyCatalougesOnMarketType> mergedList = [...catalogues];
                  if (frd is SignalRFancyMarketDataSuccess) {
                    for (var item in frd.fancyCatalogues) {
                      final index = mergedList.indexWhere((f) => f.marketId == item.marketId);
                      if (index != -1) {
                        mergedList[index] = item;
                      } else {
                        final sameTypeExists = mergedList.any((f) => f.marketType == item.marketType);
                        if (sameTypeExists) {
                          mergedList.insert(0, item);
                        }
                      }
                    }
                  }
                  mergedList = mergedList.where((m) {
                    final status = m.status.toString().toLowerCase();
                    return status != 'closed' &&
                        status != 'removed' &&
                        status != 'removed_vacant' &&
                        status != 'inactive' &&
                        status != 'void' &&
                        status != 'voided' &&
                        status != 'settled' &&
                        status != 'offline' &&
                        status != 'settle_processing' &&
                        status != 'void_processing';
                  }).toList();
                  return Expanded(
                    child: cms is FetchCatalougeOnMarketTypeProgress
                        ? LoaderContainerWithMessage()
                        : SingleChildScrollView(
                            child: Column(
                              children: List.generate(mergedList.length, (i) => FancyBetTile(fancyBet: mergedList[i], idx: i, activeIndex: 1, action: (idx) {})),
                            ),
                          ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
