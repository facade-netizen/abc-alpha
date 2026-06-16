import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../bloc/fetchBlocs/fetch_fancy_events_bloc.dart';
import '../../../../../services/web_utils.dart' as web_utils;
import '../../../../../reusable/button.dart';
import '../../../../../reusable/calender.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/date_time_formatter.dart';
import '../../../../../reusable/loader.dart';
import '../../../../../reusable/sized_box_hw.dart';
import '../../../../../reusable/snack_bar.dart';
import '../../../../../routing/route_paths.dart';
import '../../betlistConstant/betlist_string_constants.dart';

class BmBetlistScreen extends StatefulWidget {
  const BmBetlistScreen({super.key});

  @override
  State<BmBetlistScreen> createState() => _BmBetlistScreenState();
}

class _BmBetlistScreenState extends State<BmBetlistScreen> {
  TextEditingController fromDateController = TextEditingController(text: formatDateYYYYMMDD(DateTime.now()));

  String get _rolePrefix {
    final uri = GoRouterState.of(context).uri.path;
    return uri.startsWith('/fancy') ? 'fancy' : 'alpha';
  }

  String get _basePath => GoRouterState.of(context).matchedLocation;
  @override
  void initState() {
    context.read<FetchFancyEventsBloc>().add(FetchFancyEventsSetToInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CRICKET Book Maker List", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Container(
            color: lightBlueShade,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Date", style: TextStyle(fontWeight: FontWeight.w500)),
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
                    Text("00:00~23.59", style: TextStyle(fontWeight: FontWeight.w500)),
                    wb5,
                    CustomHoverButton(
                      width: 100,
                      height: 30,
                      onPressed: () {
                        if (fromDateController.text.isEmpty) {
                          return showSnackBar(context, "Please select the date", error: true);
                        }
                        context.read<FetchFancyEventsBloc>().add(FetchFancyEvents(selectedDate: "${fromDateController.text} 00:00:00.000"));
                      },
                      title: 'Search',
                      textColor: white,
                    ),
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
                    ? DataTable(
                        showCheckboxColumn: false,
                        headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                        headingTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                        dataRowMinHeight: 30,
                        dataRowMaxHeight: 30,
                        headingRowHeight: 30,
                        border: TableBorder(
                          top: BorderSide(color: grey, width: 0.5),
                          bottom: BorderSide(color: grey, width: 0.5),
                        ),
                        columns: bookMakerBetlist.map((header) => DataColumn(label: Text(header))).toList(),
                        rows: fbl.eventDetails.map((event) {
                          return DataRow(
                            cells: [
                              DataCell(SelectableText('${event.id}', style: TextStyle(fontSize: 11))),
                              DataCell(SelectableText(event.openDate != null ? formatDateString(event.openDate!) : "-", style: const TextStyle(fontSize: 11))),
                              DataCell(SelectableText(event.countryCode, style: const TextStyle(fontSize: 11))),
                              DataCell(SelectableText(event.name, style: const TextStyle(fontSize: 11))),
                              DataCell(
                                InkWell(
                                  onTap: () {
                                    context.go(RoutePaths.fancyMarkets(_rolePrefix, _basePath, event.id));
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
                                    if (pointerEvent.buttons == kSecondaryMouseButton) {
                                      web_utils.openNewTab(RoutePaths.fancyManager(_rolePrefix, _basePath, event.id));
                                    }
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      context.go(RoutePaths.fancyManager(_rolePrefix, _basePath, event.id));
                                    },
                                    child: const Text(
                                      "Manager",
                                      style: TextStyle(color: Colors.blue, fontSize: 11, decoration: TextDecoration.underline, decorationColor: blue, decorationThickness: 0.8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      )
                    : SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
