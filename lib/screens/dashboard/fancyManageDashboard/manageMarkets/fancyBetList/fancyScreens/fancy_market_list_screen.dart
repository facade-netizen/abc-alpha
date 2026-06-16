import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../bloc/addBlocs/add_new_fancy_bloc.dart';
import '../../../../../../services/web_utils.dart' as web_utils;
import '../../../../../../bloc/fetchBlocs/fetch_catalouges_on_markettype_bloc.dart';
import '../../../../../../bloc/fetchBlocs/fetch_fancy_events_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalr_event_listener_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalRStreamers/fancy_market_signalr_data_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_market_sequence_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../model/fancy_events_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/date_time_formatter.dart';
import '../../../../../../reusable/loader.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../betlistConstant/betlist_string_constants.dart';
import '../fancyDialogs/create_new_fancy_market.dart';
import '../fancyWidgets/fancy_market_widget.dart';
import '../fancyDialogs/fancy_remark_dailog.dart';
import 'manage_fancy_market_screen.dart';

class FancyMarketListScreen extends StatefulWidget {
  const FancyMarketListScreen({super.key, this.fancyEventData, this.toggleScreen, this.marketType = '', this.eventId});
  final FancyEventData? fancyEventData;
  final String marketType;
  final Function(String marketType)? toggleScreen;

  /// When navigated via GoRouter, eventId is passed as path param instead of fancyEventData.
  final String? eventId;

  @override
  State<FancyMarketListScreen> createState() => _FancyMarketListScreenState();
}

class _FancyMarketListScreenState extends State<FancyMarketListScreen> {
  List<FancyCatalougesOnMarketType> cataloguesMarkets = [];
  FancyCatalougesOnMarketType? fancyBetMarketCatalogue;
  final Map<String, TextEditingController> sequenceControllers = {};
  bool showFancyMarketScreen = false;

  String get _effectiveEventId => widget.fancyEventData?.id ?? widget.eventId ?? "0";

  FancyEventData? get _resolvedFancyEventData {
    if (widget.fancyEventData != null) return widget.fancyEventData;
    // Use watch so the widget rebuilds when FetchFancyEventsBloc updates
    final state = context.watch<FetchFancyEventsBloc>().state;
    if (state is FetchFancyEventsSuccess) {
      for (final event in state.eventDetails) {
        if (event.id == _effectiveEventId) return event;
      }
    }
    return null;
  }

  /// Path of the markets list screen (without query params), e.g. /alpha/fancy-bet-list/35429332/markets
  String get _marketsBasePath => GoRouterState.of(context).matchedLocation;

  void toggleBetSlipScreen(FancyCatalougesOnMarketType catalogue) {
    setState(() {
      showFancyMarketScreen = !showFancyMarketScreen;
      fancyBetMarketCatalogue = showFancyMarketScreen ? catalogue : null;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<FetchCatalougeOnMarketTypeBloc>().add(FetchCatalougeOnMarketType(eventId: int.tryParse(_effectiveEventId) ?? 0, marketType: widget.marketType));
    context.read<SignalREventListenerBloc>().add(SignalREventListener(eventId: _effectiveEventId));
    context.read<SignalRFancyMarketDataBloc>().add(SignalRFancyMarketDataListener());
    // If opened directly (no event data supplied), fetch today's fancy events
    // so event metadata (openDate, name, etc.) becomes available after load.
    if (widget.fancyEventData == null) {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00.000';
      context.read<FetchFancyEventsBloc>().add(FetchFancyEvents(selectedDate: dateStr));
    }
  }

  @override
  void didUpdateWidget(covariant FancyMarketListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the eventId or marketType changes (e.g., navigating in-app), re-fetch
    // to ensure we have fresh catalogue data rather than stale cache.
    if (oldWidget.eventId != widget.eventId || oldWidget.marketType != widget.marketType) {
      context.read<FetchCatalougeOnMarketTypeBloc>().add(FetchCatalougeOnMarketType(eventId: int.tryParse(_effectiveEventId) ?? 0, marketType: widget.marketType));
      context.read<SignalREventListenerBloc>().add(SignalREventListener(eventId: _effectiveEventId));
      context.read<SignalRFancyMarketDataBloc>().add(SetToInitialSignalRFancy());
      context.read<SignalRFancyMarketDataBloc>().add(SignalRFancyMarketDataListener());
    }
  }

  int _sortMarketsBySequence(FancyCatalougesOnMarketType a, FancyCatalougesOnMarketType b) {
    final aSorting = a.sorting ?? 0;
    final bSorting = b.sorting ?? 0;

    if (aSorting == 0 && bSorting != 0) {
      return 1;
    }
    if (aSorting != 0 && bSorting == 0) {
      return -1;
    }

    return aSorting.compareTo(bSorting);
  }

  void updateSequenceAndSort(List<FancyCatalougesOnMarketType> listToSort) {
    setState(() {
      for (var market in listToSort) {
        final controller = sequenceControllers[market.marketId];
        if (controller != null) {
          market.sorting = int.tryParse(controller.text) ?? 0;
        }
      }

      listToSort.sort(_sortMarketsBySequence);
    });
  }

  @override
  void dispose() {
    for (var c in sequenceControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchCatalougeOnMarketTypeBloc, FetchCatalougeOnMarketTypeState>(
      builder: (context, cms) {
        if (cms is FetchCatalougeOnMarketTypeSuccess) {
          cataloguesMarkets = cms.catalougeDetails;
          cataloguesMarkets.sort(_sortMarketsBySequence);
        }
        return BlocListener<AddNewFancyMarketBloc, AddNewFancyMarketState>(
          listener: (context, fms) {
            if (fms is AddNewFancyMarketSuccess) {
              setState(() {
                cataloguesMarkets.add(fms.createdMarket);
                cataloguesMarkets.sort(_sortMarketsBySequence);
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: showFancyMarketScreen
                ? ManageFancyMarketScreen(catalogue: fancyBetMarketCatalogue, toggleScreen: toggleBetSlipScreen, fancyEventData: widget.fancyEventData)
                : cms is FetchCatalougeOnMarketTypeProgress
                ? LoaderContainerWithMessage()
                : cms is FetchCatalougeOnMarketTypeSuccess
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FancyBetListHeader(
                        onTap: () {
                          context.read<SignalREventListenerBloc>().add(SignalREventDisconnect(eventId: _effectiveEventId));
                          context.read<SignalRFancyMarketDataBloc>().add(SetToInitialSignalRFancy());
                          widget.toggleScreen?.call(widget.marketType);
                        },
                        title: "Fancy Bet List",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomHoverButton(
                          width: 130,
                          height: 30,
                          onPressed: () {
                            showCreateNewFancyMarketDialog(context, _effectiveEventId, widget.marketType);
                          },
                          title: 'Add New Market',
                          textColor: white,
                        ),
                      ),
                      BlocBuilder<SignalRFancyMarketDataBloc, SignalRFancyMarketDataState>(
                        builder: (context, frd) {
                          List<FancyCatalougesOnMarketType> mergedList = [...cataloguesMarkets];
                          if (frd is SignalRFancyMarketDataSuccess) {
                            for (var item in frd.fancyCatalogues) {
                              final index = mergedList.indexWhere((f) => f.marketId == item.marketId);
                              if (index != -1) {
                                final old = mergedList[index];
                                // Prefer the most recent marketTime between catalogue and SignalR
                                String? chosenMarketTime = item.marketTime;
                                try {
                                  if ((item.marketTime ?? '').isNotEmpty && (old.marketTime ?? '').isNotEmpty) {
                                    final dtItem = DateTime.tryParse(item.marketTime!);
                                    final dtOld = DateTime.tryParse(old.marketTime!);
                                    if (dtItem != null && dtOld != null && dtOld.isAfter(dtItem)) {
                                      chosenMarketTime = old.marketTime;
                                    }
                                  } else if ((item.marketTime ?? '').isEmpty && (old.marketTime ?? '').isNotEmpty) {
                                    chosenMarketTime = old.marketTime;
                                  }
                                } catch (_) {
                                  chosenMarketTime = item.marketTime ?? old.marketTime;
                                }

                                mergedList[index] = FancyCatalougesOnMarketType(
                                  marketId: item.marketId,
                                  createdBy: item.createdBy ?? old.createdBy,
                                  marketTime: chosenMarketTime,
                                  marketType: item.marketType.isNotEmpty ? item.marketType : old.marketType,
                                  bettingType: item.bettingType.isNotEmpty ? item.bettingType : old.bettingType,
                                  marketName: item.marketName.isNotEmpty ? item.marketName : old.marketName,
                                  provider: item.provider.isNotEmpty ? item.provider : old.provider,
                                  pauseByAlpha: old.pauseByAlpha,
                                  createdByAlpha: old.createdByAlpha,
                                  fancyMarketCondition: item.fancyMarketCondition ?? old.fancyMarketCondition,
                                  status: item.status.isNotEmpty ? item.status : old.status,
                                  inPlay: item.inPlay,
                                  sportingEvent: item.sportingEvent,
                                  runners: item.runners.isNotEmpty ? item.runners : old.runners,
                                  competitionId: old.competitionId,
                                  eventId: item.eventId,
                                  eventName: old.eventName ?? item.eventName,
                                  sid: old.sid,
                                  sorting: old.sorting,
                                  competitionName: old.competitionName,
                                );
                              } else {
                                final sameTypeExists = mergedList.any((f) => f.marketType == item.marketType);
                                if (sameTypeExists) mergedList.insert(0, item);
                              }
                            }
                          }
                          mergedList = mergedList.where((m) {
                            final status = m.status.toLowerCase();
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
                          mergedList.sort(_sortMarketsBySequence);
                          return Expanded(
                            child: mergedList.isEmpty
                                ? const SizedBox.shrink()
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                                        child: DataTable(
                                          showCheckboxColumn: false,
                                          headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                                          headingTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                                          dataRowMinHeight: 35,
                                          dataRowMaxHeight: 35,
                                          headingRowHeight: 55,
                                          border: TableBorder(
                                            top: BorderSide(color: grey, width: 0.5),
                                            bottom: BorderSide(color: grey, width: 0.5),
                                            horizontalInside: BorderSide.none,
                                            verticalInside: BorderSide.none,
                                          ),
                                          columns: fancyMarketListHeader
                                              .map(
                                                (header) => DataColumn(
                                                  label: header.toLowerCase().contains("sequence")
                                                      ? Column(
                                                          children: [
                                                            SelectableText(header),
                                                            hb4,
                                                            CustomHoverButton(
                                                              width: 60,
                                                              height: 30,
                                                              onPressed: () {
                                                                updateSequenceAndSort(cataloguesMarkets);
                                                                final List<Map<String, dynamic>> dataList = cataloguesMarkets.map((market) {
                                                                  final controller = sequenceControllers[market.marketId];
                                                                  return {"marketId": market.marketId, "index": int.tryParse(controller?.text ?? '0') ?? 0};
                                                                }).toList();
                                                                final updateMarketSequenceMap = {"eventId": widget.fancyEventData?.id ?? 0, "data": dataList};
                                                                log("UpdateMarketSequenceMap: $updateMarketSequenceMap");
                                                                context.read<UpdateMarketSequenceBloc>().add(
                                                                  UpdateMarketSequence(updateMarketSequenceMap: updateMarketSequenceMap),
                                                                );
                                                                setState(() {
                                                                  cataloguesMarkets.sort(_sortMarketsBySequence);
                                                                });
                                                              },
                                                              title: 'Save',
                                                              textColor: white,
                                                              fontSize: 10,
                                                            ),
                                                          ],
                                                        )
                                                      : SelectableText(header),
                                                ),
                                              )
                                              .toList(),
                                          rows: mergedList.map((markets) {
                                            final event = _resolvedFancyEventData;
                                            return DataRow(
                                              color: WidgetStateProperty.all(markets.marketId.toLowerCase().contains("_") ? const Color.fromARGB(232, 160, 209, 250) : transparent),
                                              cells: [
                                                DataCell(SelectableText(event?.openDate != null ? formatDateString(event!.openDate!) : "-", style: const TextStyle(fontSize: 11))),
                                                DataCell(SelectableText('$_effectiveEventId', style: const TextStyle(fontSize: 11))),
                                                DataCell(
                                                  SelectableText(markets.marketTime != null ? formatDateString(markets.marketTime!) : "-", style: const TextStyle(fontSize: 11)),
                                                ),
                                                DataCell(SelectableText(markets.marketId, style: const TextStyle(fontSize: 11))),
                                                DataCell(SelectableText("1", style: TextStyle(fontSize: 11))),
                                                DataCell(SelectableText(markets.marketName, style: const TextStyle(fontSize: 11))),
                                                DataCell(SelectableText(markets.marketType, style: const TextStyle(fontSize: 11))),
                                                DataCell(
                                                  SizedBox(
                                                    height: 30,
                                                    width: 45,
                                                    child: TextFormField(
                                                      controller: sequenceControllers.putIfAbsent(
                                                        markets.marketId,
                                                        () => TextEditingController(text: markets.sorting?.toString() ?? ''),
                                                      ),
                                                      keyboardType: TextInputType.number,
                                                      style: const TextStyle(fontSize: 14),
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(SelectableText(markets.status, style: const TextStyle(fontSize: 11))),
                                                DataCell(SelectableText(markets.createdBy ?? '', style: const TextStyle(fontSize: 11))),
                                                DataCell(
                                                  Listener(
                                                    onPointerDown: (PointerDownEvent event) {
                                                      if (event.buttons == kSecondaryMouseButton) {
                                                        web_utils.openNewTab('$_marketsBasePath/${markets.marketId}');
                                                      }
                                                    },
                                                    child: InkWell(
                                                      onTap: () {
                                                        // Navigate via GoRouter so URL updates
                                                        context.go('$_marketsBasePath/${markets.marketId}');
                                                      },
                                                      child: const Text(
                                                        "OPEN",
                                                        style: TextStyle(color: Colors.blue, fontSize: 11, decoration: TextDecoration.underline),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  CustomHoverButton(
                                                    width: 60,
                                                    height: 25,
                                                    onPressed: () {
                                                      showFancyRemarkDialog(context);
                                                    },
                                                    title: 'Remark',
                                                    textColor: white,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
