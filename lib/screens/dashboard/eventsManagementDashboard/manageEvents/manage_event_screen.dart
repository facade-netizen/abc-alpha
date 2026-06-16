import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_events_by_competition_bloc.dart';
import '../../../../bloc/updateBlocs/events_enable_and_disable_bloc.dart';
import '../../../../bloc/updateBlocs/update_sr_id_bloc.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/style.dart';

class ManageEventsScreen extends StatefulWidget {
  final String sportName;
  const ManageEventsScreen({super.key, required this.sportName});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  String selectedEventType = '';
  bool selectAll = false;
  final Map<String, TextEditingController> srIdControllers = {};
  Map<dynamic, bool> selectedEventsMap = {};
  Map<dynamic, bool> selectedInPlayEventsMap = {};
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    for (final c in srIdControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocConsumer<EventsEnableAndDisableBloc, EventsEnableAndDisableState>(
      listener: (context, ets) {
        if (ets is EventsEnableAndDisableSuccess) {
          showSnackBar(context, "Events updated successfully");
          context.read<FetchEventsByCompetitionBloc>().add(FetchEventsByCompetition(competitionId: ets.compId, provider: ets.provider, forceRefresh: true));
        } else if (ets is EventsEnableAndDisableFailure) {
          showSnackBar(context, "Error: ${ets.error}");
        }
      },
      builder: (context, ets) {
        return ets is EventsEnableAndDisableProgress
            ? LoaderContainerWithMessage()
            : BlocBuilder<FetchEventsByCompetitionBloc, FetchEventsByCompetitionState>(
                builder: (context, fes) {
                  return fes is FetchEventsByCompetitionProgress
                      ? LoaderContainerWithMessage()
                      : fes is FetchEventsByCompetitionSuccess
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: size.height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search events by name or id',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.grey),
                                        ),
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Builder(
                                        builder: (context) {
                                          final filteredEvents = fes.eventDetails.where((event) {
                                            final query = searchQuery.trim().toLowerCase();
                                            return query.isEmpty || event.name.toLowerCase().contains(query) || event.id.toLowerCase().contains(query);
                                          }).toList();

                                          if (filteredEvents.isEmpty) {
                                            return Center(child: Text(searchQuery.isEmpty ? 'No events available' : 'No events found for "$searchQuery"', style: defaultCellStyle));
                                          }

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: DataTable(
                                              headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                                              headingTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: black),
                                              dataRowMaxHeight: 30,
                                              dataRowMinHeight: 30,
                                              headingRowHeight: 35,
                                              border: TableBorder(
                                                top: BorderSide(color: black, width: 0.5),
                                                bottom: BorderSide(color: black, width: 0.5),
                                                left: BorderSide(color: black, width: 0.5),
                                                right: BorderSide(color: black, width: 0.5),
                                              ),
                                              columns: [
                                                DataColumn(label: Text('S.No')),
                                                DataColumn(label: Text('Event Name')),
                                                DataColumn(label: Text('Event Id')),
                                                DataColumn(label: Text('Update Sr Id')),
                                                DataColumn(label: Text('In Play')),
                                                DataColumn(label: Text('Open Date')),
                                                DataColumn(label: Text('Enabled')),
                                              ],
                                              rows: filteredEvents.asMap().entries.map((entry) {
                                                int index = entry.key;
                                                var bets = entry.value;
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text('${index + 1}', style: defaultCellStyle)),
                                                    DataCell(
                                                      Row(
                                                        children: [
                                                          Checkbox(
                                                            value: selectedEventsMap.containsKey(bets.id) ? selectedEventsMap[bets.id] == true : bets.enabledByAlpha == true,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                selectedEventsMap[bets.id] = val ?? false;
                                                                // If isActive is unchecked, auto-uncheck inPlay too
                                                                if (val == false) {
                                                                  selectedInPlayEventsMap[bets.id] = false;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Text(bets.name, style: defaultCellStyle),
                                                        ],
                                                      ),
                                                    ),
                                                    DataCell(Text(bets.id, style: defaultCellStyle)),

                                                    DataCell(
                                                      BlocBuilder<UpdateSrIdBloc, UpdateSrIdState>(
                                                        builder: (context, state) {
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 100,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                                                  child: TextFormField(
                                                                    key: ValueKey('srId-${bets.id}'),
                                                                    controller: srIdControllers.putIfAbsent(bets.id, () => TextEditingController(text: bets.srId)),
                                                                    style: defaultCellStyle,
                                                                    decoration: tfInputDecoration.copyWith(
                                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                      hintText: "Enter Sr Id",
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              wb5,
                                                              ColoredTextButton(
                                                                name: "Update",
                                                                width: 80,
                                                                height: 30,
                                                                onTap: () {
                                                                  if (srIdControllers[bets.id]?.text.trim().isEmpty ?? true) {
                                                                    showSnackBar(context, "Please enter a valid Sr Id", error: true);
                                                                    return;
                                                                  }
                                                                  context.read<UpdateSrIdBloc>().add(UpdateSrId(eventId: bets.id, srId: srIdControllers[bets.id]!.text.trim()));
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Row(
                                                        children: [
                                                          Checkbox(
                                                            value: selectedInPlayEventsMap.containsKey(bets.id)
                                                                ? selectedInPlayEventsMap[bets.id] == true
                                                                : bets.forceAddInPlay == true,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                selectedInPlayEventsMap[bets.id] = val ?? false;
                                                                if (val == true && selectedEventsMap[bets.id] != true) {
                                                                  selectedEventsMap[bets.id] = true;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Text(bets.forceAddInPlay == true ? "Yes" : "No", style: defaultCellStyle),
                                                        ],
                                                      ),
                                                    ),
                                                    DataCell(Text(formattedDateFromISO(bets.openDate), style: defaultCellStyle)),
                                                    DataCell(Text(bets.enabledByAlpha == true ? "Yes" : "No", style: defaultCellStyle)),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: ColoredTextButton(
                                  name: "Submit",
                                  width: 140,
                                  onTap: () {
                                    if (selectedEventsMap.isEmpty && selectedInPlayEventsMap.isEmpty) {
                                      showSnackBar(context, "Please select at least one event or in-play option", error: true);
                                      return;
                                    }
                                    final toggleEvents = fes.eventDetails
                                        .map((event) {
                                          final bool inPlay = selectedInPlayEventsMap.containsKey(event.id)
                                              ? selectedInPlayEventsMap[event.id] == true
                                              : event.forceAddInPlay == true;
                                          // isActive: user's explicit choice always wins; if inPlay checked and no explicit choice, default true
                                          final bool isActive = selectedEventsMap.containsKey(event.id)
                                              ? selectedEventsMap[event.id] == true
                                              : inPlay
                                              ? true
                                              : event.enabledByAlpha == true;

                                          final bool isPremium = event.venue.toLowerCase().contains("premium");
                                          if (!selectedEventsMap.containsKey(event.id) && !selectedInPlayEventsMap.containsKey(event.id)) return null;
                                          return {"eventID": event.id, "isActive": isActive, "forceAddInPlay": inPlay, "forceRemoveInPlay": !inPlay, "isPremium": isPremium};
                                        })
                                        .whereType<Map<String, dynamic>>()
                                        .toList();
                                    if (toggleEvents.isEmpty) {
                                      showSnackBar(context, "No changes detected to submit", error: true);
                                      return;
                                    }
                                    final payload = {"sportName": widget.sportName, "toggleEvents": toggleEvents};
                                    log("Selected Events: $payload");
                                    context.read<EventsEnableAndDisableBloc>().add(EventsEnableAndDisable(eventsEnableAndDisableMap: payload));
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : NoData();
                },
              );
      },
    );
  }
}
