import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../bloc/fetchBlocs/fetch_fancy_events_bloc.dart';
import '../../../../../../services/web_utils.dart' as web_utils;
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/calender.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/date_time_formatter.dart';
import '../../../../../../reusable/loader.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../../../../reusable/snack_bar.dart';
import '../../../../../../routing/route_paths.dart';
import '../../../betlistConstant/betlist_string_constants.dart';
import '../fancyDialogs/show_fancy_market_type_dailog.dart';

class FancyBetListScreen extends StatefulWidget {
  const FancyBetListScreen({super.key, this.initialDate});

  /// When navigated via GoRouter, date can come from query param.
  final String? initialDate;

  @override
  State<FancyBetListScreen> createState() => _FancyBetListScreenState();
}

class _FancyBetListScreenState extends State<FancyBetListScreen> {
  late TextEditingController fromDateController;
  final Map<String, ValueNotifier<String?>> _ratingNotifiers = {};

  ValueNotifier<String?> _getRatingNotifier(String eventId) {
    return _ratingNotifiers.putIfAbsent(eventId, () => ValueNotifier<String?>("1"));
  }

  /// Determine the role prefix from the current URL (alpha or fancy).
  String get _rolePrefix {
    final uri = GoRouterState.of(context).uri.path;
    return uri.startsWith('/fancy') ? 'fancy' : 'alpha';
  }

  /// The base path for this betlist screen (e.g. '/alpha/fancy-bet-list').
  String get _basePath => GoRouterState.of(context).matchedLocation;

  @override
  void initState() {
    super.initState();
    fromDateController = TextEditingController(text: widget.initialDate ?? formatDateYYYYMMDD(DateTime.now()));
    // Only fetch data when a date query param is explicitly present in the URL.
    // No ?date= → show empty screen (user must click Search to load data).
    final currentState = context.read<FetchFancyEventsBloc>().state;
    if (widget.initialDate != null && widget.initialDate!.isNotEmpty) {
      if (currentState is! FetchFancyEventsSuccess) {
        context.read<FetchFancyEventsBloc>().add(FetchFancyEvents(selectedDate: "${widget.initialDate} 00:00:00.000"));
      }
    } else {
      // Always reset to init when no date param (even if cached data exists)
      context.read<FetchFancyEventsBloc>().add(FetchFancyEventsSetToInit());
    }
  }

  @override
  void dispose() {
    fromDateController.dispose();
    for (final notifier in _ratingNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  void _searchWithDate() {
    if (fromDateController.text.isEmpty) {
      return showSnackBar(context, "Please select the date", error: true);
    }
    // Update URL with date query param
    final currentPath = _basePath;
    context.go('$currentPath?date=${fromDateController.text}');
    context.read<FetchFancyEventsBloc>().add(FetchFancyEvents(selectedDate: "${fromDateController.text} 00:00:00.000"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText("Fancy Bet List", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Container(
            color: lightBlueShade,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SelectableText("Date", style: TextStyle(fontWeight: FontWeight.w500)),
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
                    SelectableText("00:00~23.59", style: TextStyle(fontWeight: FontWeight.w500)),
                    wb5,
                    CustomHoverButton(width: 100, height: 30, onPressed: _searchWithDate, title: 'Search', textColor: white),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<FetchFancyEventsBloc, FetchFancyEventsState>(
            builder: (context, fbl) {
              return SizedBox(
                width: double.infinity,
                child: fbl is FetchFancyEventsProgress
                    ? const LoaderContainerWithMessage()
                    : fbl is FetchFancyEventsSuccess
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                              headingTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: black),
                              dataRowMinHeight: 30,
                              dataRowMaxHeight: 30,
                              headingRowHeight: 30,
                              border: TableBorder(
                                top: BorderSide(color: grey, width: 0.5),
                                bottom: BorderSide(color: grey, width: 0.5),
                              ),
                              columns: fancyBetListHeader.map((header) => DataColumn(label: SelectableText(header))).toList(),
                              rows: fbl.eventDetails.map((betEvent) {
                                return DataRow(
                                  cells: [
                                    DataCell(SelectableText('${betEvent.id}', style: TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(betEvent.openDate != null ? formatDateString(betEvent.openDate!) : "-", style: const TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(betEvent.countryCode, style: const TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(betEvent.name, style: const TextStyle(fontSize: 11))),
                                    DataCell(SelectableText(betEvent.openDate != null ? formatDateString(betEvent.openDate!) : "-", style: const TextStyle(fontSize: 11))),
                                    DataCell(SizedBox(height: 30, width: 100, child: _buildEventRatingDropdown(betEvent.id))),
                                    DataCell(SelectableText("1-500/%0", style: TextStyle(fontSize: 11))),
                                    DataCell(
                                      InkWell(
                                        onTap: () async {
                                          // Capture router and messenger before async gap to avoid
                                          // using BuildContext after awaiting (lint: use_build_context_synchronously).
                                          final router = GoRouter.of(context);
                                          final messenger = ScaffoldMessenger.of(context);
                                          final Map<String, String>? selectedMarketType = await showFancyMarketTypeDailog(context);
                                          if (!mounted) return;
                                          final mt = selectedMarketType?['marketType'];
                                          if (mt != null && mt.isNotEmpty) {
                                            // Navigate to markets sub-route via GoRouter
                                            router.go(RoutePaths.fancyMarkets(_rolePrefix, _basePath, betEvent.id, marketType: mt));
                                          } else {
                                            // Surface why navigation didn't happen
                                            messenger.showSnackBar(const SnackBar(content: Text('No market type selected — navigation cancelled')));
                                          }
                                        },
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(color: Colors.blue, fontSize: 11, decoration: TextDecoration.underline, decorationColor: blue, decorationThickness: 0.8),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Listener(
                                        onPointerDown: (PointerDownEvent pointerEvent) {
                                          // buttons == 2 is the secondary (right) mouse button
                                          if (pointerEvent.buttons == kSecondaryMouseButton) {
                                            final path = RoutePaths.sequenceManager(_rolePrefix, _basePath, betEvent.id);
                                            web_utils.openNewTab(path);
                                          }
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            // Navigate to manager sub-route via GoRouter
                                            context.go(RoutePaths.sequenceManager(_rolePrefix, _basePath, betEvent.id));
                                          },
                                          child: const Text(
                                            "Sequence",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 11,
                                              decoration: TextDecoration.underline,
                                              decorationColor: blue,
                                              decorationThickness: 0.8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      // Listener bypasses the gesture arena so right-click
                                      // is always caught even inside a DataTable row.
                                      Listener(
                                        onPointerDown: (PointerDownEvent pointerEvent) {
                                          // buttons == 2 is the secondary (right) mouse button
                                          if (pointerEvent.buttons == kSecondaryMouseButton) {
                                            final path = RoutePaths.fancyManager(_rolePrefix, _basePath, betEvent.id);
                                            web_utils.openNewTab(path);
                                          }
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            // Navigate to manager sub-route via GoRouter
                                            context.go(RoutePaths.fancyManager(_rolePrefix, _basePath, betEvent.id));
                                          },
                                          child: const Text(
                                            "Manager",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 11,
                                              decoration: TextDecoration.underline,
                                              decorationColor: blue,
                                              decorationThickness: 0.8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventRatingDropdown(String eventId) {
    final notifier = _getRatingNotifier(eventId);
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      items: ["1"].map((item) {
        return DropdownItem<String>(
          value: item,
          child: SelectableText(item, style: const TextStyle(fontSize: 11, color: black)),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          notifier.value = newValue;
        }
      },
    );
  }
}
