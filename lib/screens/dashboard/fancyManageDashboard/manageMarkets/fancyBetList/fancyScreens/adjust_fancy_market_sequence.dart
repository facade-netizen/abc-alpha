import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/fetchBlocs/fetch_catalouges_on_markettype_bloc.dart';
import '../../../../../../bloc/fetchBlocs/fetch_fancy_events_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_market_sequence_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../model/fancy_events_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/date_time_formatter.dart';
import '../../../../../../reusable/loader.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../betlistConstant/betlist_string_constants.dart';
import '../fancyWidgets/fancy_market_widget.dart';

class AdjustFancyMarketSequence extends StatefulWidget {
  const AdjustFancyMarketSequence({super.key, this.toggleScreen, this.fancyEventData, this.eventId});
  final FancyEventData? fancyEventData;
  final Function(FancyEventData fancyBetEventData)? toggleScreen;

  /// When navigated via GoRouter, eventId is passed as path param instead of fancyEventData.
  final String? eventId;
  @override
  State<AdjustFancyMarketSequence> createState() => _AdjustFancyMarketSequenceState();
}

class _AdjustFancyMarketSequenceState extends State<AdjustFancyMarketSequence> {
  String get _effectiveEventId => widget.fancyEventData?.id ?? widget.eventId ?? '';

  @override
  void initState() {
    super.initState();
    context.read<FetchCatalougeOnMarketTypeBloc>().add(FetchCatalougeOnMarketType(eventId: int.tryParse(_effectiveEventId) ?? 0, marketType: ""));
    // For URL navigation (no fancyEventData passed): eagerly fetch today's fancy events
    if (widget.fancyEventData == null) {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00.000';
      context.read<FetchFancyEventsBloc>().add(FetchFancyEvents(selectedDate: dateStr));
    }
  }

  FancyCatalougesOnMarketType? fancyBetMarketCatalogue;
  final Map<String, TextEditingController> sequenceControllers = {};
  List<FancyCatalougesOnMarketType> cataloguesMarkets = [];

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

    final resolvedStartDate = event?.openDate;
    final resolvedCompetition = event?.id != null ? event!.id.toString() : '-';
    return BlocBuilder<FetchCatalougeOnMarketTypeBloc, FetchCatalougeOnMarketTypeState>(
      builder: (context, cms) {
        if (cms is FetchCatalougeOnMarketTypeSuccess) {
          cataloguesMarkets = cms.catalougeDetails;
          cataloguesMarkets = cataloguesMarkets.where((m) {
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
          cataloguesMarkets.sort(_sortMarketsBySequence);
        }
        return cms is FetchCatalougeOnMarketTypeProgress
            ? LoaderContainerWithMessage()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    FancyBetListHeader(title: "Sequence Manager", onTap: () {}),
                    Expanded(
                      child: SingleChildScrollView(
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
                              columns: fancyMarketListHeaderSequence
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
                                                    context.read<UpdateMarketSequenceBloc>().add(UpdateMarketSequence(updateMarketSequenceMap: updateMarketSequenceMap));
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
                              rows: cataloguesMarkets.map((markets) {
                                return DataRow(
                                  color: WidgetStateProperty.all(markets.marketId.toLowerCase().contains("_") ? const Color.fromARGB(232, 160, 209, 250) : transparent),
                                  cells: [
                                    DataCell(SelectableText(resolvedStartDate != null ? formatDateString(resolvedStartDate) : "-", style: const TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(resolvedCompetition, style: const TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(markets.marketId, style: const TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(markets.marketName, style: const TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(markets.marketType, style: const TextStyle(fontSize: 11))),
                                    DataCell(
                                      SizedBox(
                                        height: 30,
                                        width: 45,
                                        child: TextFormField(
                                          controller: sequenceControllers.putIfAbsent(markets.marketId, () => TextEditingController(text: markets.sorting?.toString() ?? '')),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          style: const TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(SelectableText(markets.status, style: const TextStyle(fontSize: 11))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
