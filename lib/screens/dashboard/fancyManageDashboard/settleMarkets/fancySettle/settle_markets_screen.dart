import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../bloc/fetchBlocs/fetch_custom_fancy_market_bloc.dart';
import '../../../../../bloc/fetchBlocs/fetch_fancy_bet_events_bloc.dart';
import '../../../../../bloc/updateBlocs/markets_settle_bloc.dart';
import '../../../../../bloc/updateBlocs/save_market_to_settle_bloc.dart';
import '../../../../../model/fancy_bet_list_model.dart';
import '../../../../../reusable/button.dart';
import '../../../../../reusable/calender.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/date_time_formatter.dart';
import '../../../../../reusable/loader.dart';
import '../../../../../reusable/sized_box_hw.dart';
import '../../../../../reusable/snack_bar.dart';
import '../../betlistConstant/betlist_string_constants.dart';
import 'show_settled_history_dialog.dart';

class SettleMarketsScreen extends StatefulWidget {
  const SettleMarketsScreen({super.key, this.initialFromDate, this.initialToDate});

  /// When navigated via GoRouter, dates can come from query params.
  final String? initialFromDate;
  final String? initialToDate;

  @override
  State<SettleMarketsScreen> createState() => _SettleMarketsScreenState();
}

class _SettleMarketsScreenState extends State<SettleMarketsScreen> {
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  Map<String, TextEditingController> runControllers = {};
  Map<String, TextEditingController> resultSourceControllers = {};
  String? expandedEventId;
  final List<int> columnFlex = [1, 2, 3, 3, 1, 2];
  // New: per-market state to track "isNew"
  Map<String, bool> isSettleTypeNewMap = {};
  Map<String, bool> isSettleTypeSettleMap = {};
  Map<String, bool> isVoidTypeMap = {};
  List<FancyBetMarketCatalogue> catalogues = [];
  final Map<String, ValueNotifier<String?>> _settleDropdownValues = {};

  ValueNotifier<String?> _getSettleDropdown(String eventId) {
    if (!_settleDropdownValues.containsKey(eventId)) {
      _settleDropdownValues[eventId] = ValueNotifier<String?>(resultSource.isNotEmpty ? resultSource[0] : null);
    }
    return _settleDropdownValues[eventId]!;
  }

  TextEditingController getRunController(String marketId) {
    if (!runControllers.containsKey(marketId)) {
      runControllers[marketId] = TextEditingController();
    }
    return runControllers[marketId]!;
  }

  TextEditingController getResultSourceController(String marketId) {
    if (!resultSourceControllers.containsKey(marketId)) {
      resultSourceControllers[marketId] = TextEditingController();
    }
    return resultSourceControllers[marketId]!;
  }

  @override
  void initState() {
    super.initState();
    fromDateController = TextEditingController(text: widget.initialFromDate ?? formatDateYYYYMMDD(DateTime.now()));
    toDateController = TextEditingController(text: widget.initialToDate ?? formatDateYYYYMMDD(DateTime.now()));
    // Cache-first: only fetch if BLoC doesn't already have data
    final currentState = context.read<FetchFancyBetEventsBloc>().state;
    if (widget.initialFromDate != null && widget.initialFromDate!.isNotEmpty) {
      if (currentState is! FetchFancyBetEventsSuccess) {
        context.read<FetchFancyBetEventsBloc>().add(
          FetchFancyBetEvents(fancyBetMap: {"fromDate": "${fromDateController.text} 00:00:00.000", "toDate": "${toDateController.text} 23:59:59.999", "sid": 4, "bettingType": 1}),
        );
      }
    } else if (currentState is! FetchFancyBetEventsSuccess) {
      context.read<FetchFancyBetEventsBloc>().add(FetchFancyBetEventsSetToInit());
    }
  }

  @override
  void dispose() {
    for (final notifier in _settleDropdownValues.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SelectableText("Fancy Bet Settle Market", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Container(
              color: lightBlueShade,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SelectableText("From", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb5,
                      DateBox(
                        height: 30,
                        fontSize: 14,
                        width: 150,
                        controller: fromDateController,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => CustomDatePickerDialog(
                              initialDate: DateTime.now(),
                              allowFutureDates: true,
                              onDateSelected: (date) {
                                fromDateController.text = formatDateYYYYMMDD(date!);
                              },
                            ),
                          );
                        },
                      ),
                      wb5,
                      const SelectableText("To", style: TextStyle(fontWeight: FontWeight.w500)),
                      wb5,
                      DateBox(
                        height: 30,
                        fontSize: 14,
                        width: 150,
                        controller: toDateController,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => CustomDatePickerDialog(
                              initialDate: DateTime.now(),
                              allowFutureDates: true,
                              onDateSelected: (date) {
                                toDateController.text = formatDateYYYYMMDD(date!);
                              },
                            ),
                          );
                        },
                      ),
                      wb5,
                      CustomHoverButton(
                        width: 100,
                        height: 30,
                        title: 'Search',
                        textColor: white,
                        onPressed: () {
                          if (fromDateController.text.isEmpty) {
                            return showSnackBar(context, "Please select the date", error: true);
                          }
                          // Update URL with date query params
                          final currentPath = GoRouterState.of(context).matchedLocation;
                          context.go('$currentPath?fromDate=${fromDateController.text}&toDate=${toDateController.text}');
                          context.read<FetchFancyBetEventsBloc>().add(
                            FetchFancyBetEvents(
                              fancyBetMap: {"fromDate": "${fromDateController.text} 00:00:00.000", "toDate": "${toDateController.text} 23:59:59.999", "sid": 4, "bettingType": 1},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SelectableText("Result Source Reference WebSite Example : Sportsadda,Espncricinfo,Cricbuzz,Fancode,BullScore"),
            BlocBuilder<FetchFancyBetEventsBloc, FetchFancyBetEventsState>(
              builder: (context, fbl) {
                if (fbl is FetchFancyBetEventsProgress) {
                  return const LoaderContainerWithMessage();
                }
                List<FancyBetEventData> events = [];
                if (fbl is FetchFancyBetEventsSuccess) {
                  events = fbl.eventDetails;
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border(
                          top: BorderSide(color: grey, width: 0.5),
                          bottom: BorderSide(color: grey, width: 0.5),
                        ),
                      ),
                      child: Row(
                        children: List.generate(
                          fancySettleMarketHeader.length,
                          (index) => Expanded(
                            flex: columnFlex[index],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: SelectableText(
                                fancySettleMarketHeader[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: expandedEventId == event.id ? hover : white,
                                border: Border(bottom: BorderSide(color: grey, width: 0.5)),
                              ),
                              child: Row(
                                children: [
                                  tableCell(event.id, 0),
                                  tableCell(event.openDate != null ? formatDateString(event.openDate!) : "-", 1),
                                  tableCell(event.name, 2),
                                  Expanded(
                                    flex: columnFlex[3],
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 30, width: 120, child: _buildSettleDropdown(event.id, resultSource)),
                                        wb5,
                                        CustomHoverButton(width: 70, height: 25, onPressed: () {}, title: 'Save', textColor: white),
                                      ],
                                    ),
                                  ),
                                  tableCell("1", 4),
                                  Expanded(
                                    flex: columnFlex[5],
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SelectableText("0/0", style: TextStyle(fontSize: 11)),
                                        wb10,
                                        CustomHoverButton(
                                          width: 100,
                                          height: 25,
                                          title: expandedEventId == event.id ? "Close Market" : "Open Market",
                                          textColor: white,
                                          onPressed: () {
                                            setState(() {
                                              expandedEventId == event.id ? expandedEventId = null : expandedEventId = event.id;
                                              context.read<FetchCustomFancyMarketBloc>().add(FetchCustomFancyMarket(eventId: int.tryParse(event.id) ?? 0));
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (expandedEventId == event.id)
                              BlocConsumer<MarketSettleBloc, MarketSettleState>(
                                listener: (context, mss) {
                                  if (mss is MarketSettleSuccess) {
                                    showSnackBar(context, "Market settled successfully");
                                    context.read<FetchCustomFancyMarketBloc>().add(FetchCustomFancyMarket(eventId: int.tryParse(event.id) ?? 0));
                                  }
                                  if (mss is MarketSettleFailure) {
                                    showSnackBar(context, mss.error.toString(), error: true);
                                  }
                                },
                                builder: (context, state) {
                                  return BlocConsumer<SaveMarketToSettleBloc, SaveMarketToSettleState>(
                                    listener: (context, sms) {
                                      if (sms is SaveMarketToSettleSuccess) {
                                        final market = sms.patch;
                                        setState(() {
                                          runControllers[market.marketId] = TextEditingController(text: market.runs.toString());
                                          resultSourceControllers[market.marketId] = TextEditingController(text: market.resultSource);
                                          isSettleTypeNewMap[market.marketId] = market.settleType.toLowerCase().contains("new");
                                          isSettleTypeSettleMap[market.marketId] = market.settleType.toLowerCase().contains("settle");
                                          isVoidTypeMap[market.marketId] = market.status.toLowerCase().contains("void");
                                        });
                                        showSnackBar(context, "Runs saved successfully");
                                        context.read<FetchCustomFancyMarketBloc>().add(FetchCustomFancyMarket(eventId: int.tryParse(event.id) ?? 0));
                                      }
                                      if (sms is SaveMarketToSettleFailure) {
                                        showSnackBar(context, sms.error.toString(), error: true);
                                      }
                                    },
                                    builder: (context, sms) {
                                      return BlocBuilder<FetchCustomFancyMarketBloc, FetchCustomFancyMarketState>(
                                        builder: (context, cms) {
                                          if (cms is FetchCustomFancyMarketProgress) {
                                            return LoaderContainerWithMessage();
                                          } else if (cms is FetchCustomFancyMarketSuccess) {
                                            for (var market in cms.customMarketDate) {
                                              if (!isSettleTypeNewMap.containsKey(market.marketId) ||
                                                  !isSettleTypeSettleMap.containsKey(market.marketId) ||
                                                  !isVoidTypeMap.containsKey(market.marketId)) {
                                                isSettleTypeNewMap[market.marketId] = market.settleType.toLowerCase().contains("new");
                                                isSettleTypeSettleMap[market.marketId] = market.settleType.toLowerCase().contains("settle");
                                                isVoidTypeMap[market.marketId] = market.status.toLowerCase().contains("void");
                                              }
                                              getRunController(market.marketId).text = market.runs.toString();
                                              getResultSourceController(market.marketId).text = market.resultSource;
                                            }
                                            return DataTable(
                                              showCheckboxColumn: false,
                                              headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                                              headingTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                                              dataRowMaxHeight: 60,
                                              dataRowMinHeight: 60,
                                              headingRowHeight: 30,
                                              border: TableBorder(
                                                top: BorderSide(color: grey, width: 0.5),
                                                bottom: BorderSide(color: grey, width: 0.5),
                                              ),
                                              columns: marketSettlingHeaders.map((header) => DataColumn(label: SelectableText(header))).toList(),
                                              rows: cms.customMarketDate.map((market) {
                                                bool isMarketClosed = market.pausebyAlpha;
                                                bool isSettleTypeNew = isSettleTypeNewMap[market.marketId]!;
                                                bool isSettleTypeSettle = isSettleTypeSettleMap[market.marketId]!;
                                                bool isVoided = isVoidTypeMap[market.marketId]!;
                                                return DataRow(
                                                  color: WidgetStateProperty.all(isMarketClosed ? Colors.grey[200] : lightBlueShade),
                                                  cells: [
                                                    DataCell(SelectableText(market.marketId, style: const TextStyle(fontSize: 11))),
                                                    DataCell(SelectableText(market.marketName, style: const TextStyle(fontSize: 11))),
                                                    DataCell(
                                                      isSettleTypeNew || isSettleTypeSettle
                                                          ? SelectableText(
                                                              getRunController(market.marketId).text,
                                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                                            )
                                                          : !isMarketClosed
                                                          ? SelectableText("N/A", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))
                                                          : SizedBox(
                                                              height: 30,
                                                              width: 60,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                                child: TextFormField(
                                                                  controller: getRunController(market.marketId),
                                                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                  style: TextStyle(fontSize: 14),
                                                                  decoration: InputDecoration(
                                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                                                    labelStyle: const TextStyle(fontSize: 14),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: black, width: 2),
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
                                                    ),
                                                    DataCell(
                                                      isSettleTypeNew || isSettleTypeSettle
                                                          ? SelectableText(
                                                              getResultSourceController(market.marketId).text,
                                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                                            )
                                                          : !isMarketClosed
                                                          ? SelectableText("N/A", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))
                                                          : SizedBox(
                                                              height: 30,
                                                              width: 100,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                                child: TextFormField(
                                                                  controller: getResultSourceController(market.marketId),
                                                                  style: TextStyle(fontSize: 14),
                                                                  decoration: InputDecoration(
                                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                                                    labelStyle: const TextStyle(fontSize: 14),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: black, width: 2),
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
                                                    ),
                                                    DataCell(
                                                      Row(
                                                        children: [
                                                          SelectableText(market.updator.isNotEmpty ? market.updator : "", style: const TextStyle(fontSize: 11)),
                                                          wb5,
                                                          Visibility(
                                                            visible: !isSettleTypeNew && isMarketClosed && !isSettleTypeSettle,
                                                            child: CustomHoverButton(
                                                              width: 60,
                                                              height: 20,
                                                              title: 'Save',
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 11,
                                                              textColor: white,
                                                              onPressed: () {
                                                                Map<String, dynamic> saveMarketToSettle = {
                                                                  "marketId": market.marketId,
                                                                  "result": double.tryParse(getRunController(market.marketId).text),
                                                                  "resultSource": getResultSourceController(market.marketId).text,
                                                                  "eventId": event.id,
                                                                  "marketName": market.marketName,
                                                                };
                                                                context.read<SaveMarketToSettleBloc>().add(SaveMarketToSettle(saveMarketToSettle: saveMarketToSettle));
                                                              },
                                                            ),
                                                          ),
                                                          !market.status.toLowerCase().contains("void")
                                                              ? Visibility(
                                                                  visible: isSettleTypeNew || isSettleTypeSettle,
                                                                  child: CustomHoverButton(
                                                                    width: 60,
                                                                    height: 20,
                                                                    title: 'Modify',
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 11,
                                                                    textColor: white,
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        isSettleTypeSettleMap[market.marketId] = false;
                                                                        isSettleTypeNewMap[market.marketId] = false;
                                                                      });
                                                                    },
                                                                  ),
                                                                )
                                                              : SizedBox.shrink(),
                                                        ],
                                                      ),
                                                    ),
                                                    DataCell(SelectableText(market.status, style: const TextStyle(fontSize: 11))),
                                                    DataCell(SelectableText(market.transactionCount.toString(), style: const TextStyle(fontSize: 11))),
                                                    DataCell(
                                                      !market.status.toLowerCase().contains("void")
                                                          ? Visibility(
                                                              visible: (!isVoided && (isSettleTypeNew || isSettleTypeSettle)),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(4),
                                                                child: Column(
                                                                  children: [
                                                                    CustomHoverButton(
                                                                      width: 60,
                                                                      height: 20,
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.w700,
                                                                      title: market.settleType.toLowerCase().contains("settle") ? "reSettle" : 'Settle',
                                                                      textColor: white,
                                                                      onPressed: () {
                                                                        context.read<MarketSettleBloc>().add(
                                                                          MarketSettle(marketSettle: {"marketId": market.marketId, "bettingType": market.bettingType}),
                                                                        );
                                                                      },
                                                                    ),
                                                                    hb5,
                                                                    if (!market.status.toLowerCase().contains("void"))
                                                                      CustomHoverButton(
                                                                        width: 60,
                                                                        height: 20,
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight.w700,
                                                                        title: 'Void',
                                                                        textColor: white,
                                                                        onPressed: () {
                                                                          context.read<MarketSettleBloc>().add(
                                                                            MarketSettle(
                                                                              marketSettle: {"marketId": market.marketId, "bettingType": market.bettingType, "isVoid": true},
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox.shrink(),
                                                    ),
                                                    DataCell(SelectableText(market.operator.isNotEmpty ? market.operator : "", style: const TextStyle(fontSize: 11))),
                                                    DataCell(
                                                      CustomHoverButton(
                                                        width: 110,
                                                        height: 20,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 11,
                                                        title: 'Show Settle Log',
                                                        textColor: white,
                                                        onPressed: () {
                                                          showMarketSettleHistoryDialog(context, market.marketId);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tableCell(String text, int index) {
    return Expanded(
      flex: columnFlex[index],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: SelectableText(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  Widget _buildSettleDropdown(String eventId, List<String> resultSource) {
    final notifier = _getSettleDropdown(eventId);
    return DropdownButtonFormField2<String>(
      valueListenable: notifier,
      isExpanded: true,
      iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: black, size: 13)),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: grey),
        ),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      items: resultSource.map((item) {
        return DropdownItem<String>(
          value: item,
          child: Text(item.toString(), style: const TextStyle(fontSize: 11, color: black)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          notifier.value = value;
        }
      },
    );
  }
}
