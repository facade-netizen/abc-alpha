import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/fetchBlocs/fetch_competitions_by_eventype_bloc.dart';
import '../../../../model/event_type_model.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/event_menu_tile.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import 'competitions_menu_card.dart';
import 'manage_event_screen.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key, required this.eventTypeData, this.initialSportId, this.initialCompetitionId, required this.basePath});

  final List<EventTypes> eventTypeData;
  final String? initialSportId;
  final String? initialCompetitionId;
  final String basePath;

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  String eventTypeId = '';
  String selectedEventType = '';
  List<EventTypes> eventTypes = [];

  void _selectSport(EventTypes eventType) {
    if (eventType.id == eventTypeId) return; // already selected
    setState(() {
      eventTypeId = eventType.id;
      selectedEventType = eventType.name;
    });
    // Pre-warm cache before URL navigation triggers a rebuild
    context.read<FetchCompetitionsByEventTypeBloc>().add(FetchCompetitionsByEventType(sportId: eventType.id, sportName: eventType.name));
    // Navigate: new sport clears competitionId
    context.go('${widget.basePath}?sportId=${eventType.id}');
  }

  @override
  void initState() {
    super.initState();
    eventTypes = widget.eventTypeData;
    if (eventTypes.isEmpty) return;

    // Resolve which sport to highlight from the URL param, falling back to first
    final EventTypes sport;
    final targetId = widget.initialSportId;
    if (targetId != null) {
      sport = eventTypes.firstWhere((e) => e.id == targetId, orElse: () => eventTypes.first);
    } else {
      sport = eventTypes.first;
    }
    eventTypeId = sport.id;
    selectedEventType = sport.name;

    context.read<FetchCompetitionsByEventTypeBloc>().add(FetchCompetitionsByEventType(sportId: eventTypeId, sportName: selectedEventType));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Row(
      children: [
        // Column 1: Sport types
        Expanded(
          flex: 1,
          child: SizedBox(
            height: size.height,
            child: Card(
              color: white,
              shadowColor: grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: eventTypes.length,
                  itemBuilder: (context, index) {
                    final eventType = eventTypes[index];
                    return MenuTileWithLabelAndIcon(
                      key: Key(eventType.name),
                      selectedEditorName: selectedEventType,
                      eventTypeName: eventType.name,
                      eventTypeIcon: eventType.icon,
                      rightClickUrl: '${widget.basePath}?sportId=${eventType.id}',
                      action: () => _selectSport(eventType),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        wb5,
        // Column 2: Competitions for the selected sport
        BlocBuilder<FetchCompetitionsByEventTypeBloc, FetchCompetitionsByEventTypeState>(
          builder: (context, fcs) {
            return fcs is FetchCompetitionsByEventTypeProgress
                ? LoaderContainerWithMessage()
                : fcs is FetchCompetitionsByEventTypeSuccess
                ? Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height,
                      child: CompetitionByEventTypeScreen(
                        competitionByEventType: fcs.competitionByEventType,
                        initialCompetitionId: widget.initialCompetitionId,
                        currentSportId: eventTypeId,
                        basePath: widget.basePath,
                      ),
                    ),
                  )
                : NoData();
          },
        ),
        wb5,
        // Column 3: Events table
        Expanded(
          flex: 6,
          child: Card(
            color: white,
            shadowColor: grey,
            child: ManageEventsScreen(sportName: selectedEventType),
          ),
        ),
      ],
    );
  }
}
