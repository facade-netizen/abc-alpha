import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/fetchBlocs/fetch_events_by_competition_bloc.dart';
import '../../../../model/competitions_by_eventtype_model.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/event_menu_tile.dart';
import '../../../../reusable/sized_box_hw.dart';

class CompetitionByEventTypeScreen extends StatefulWidget {
  const CompetitionByEventTypeScreen({super.key, required this.competitionByEventType, this.initialCompetitionId, required this.currentSportId, required this.basePath});

  final List<CompetitionByEventType> competitionByEventType;
  final String? initialCompetitionId;
  final String currentSportId;
  final String basePath;

  @override
  State<CompetitionByEventTypeScreen> createState() => _CompetitionByEventTypeScreenState();
}

class _CompetitionByEventTypeScreenState extends State<CompetitionByEventTypeScreen> {
  TextEditingController searchController = TextEditingController();
  String competitionId = '';
  String selectedCompName = '';
  List<CompetitionByEventType> filteredCompetitions = [];

  @override
  void initState() {
    super.initState();
    if (widget.competitionByEventType.isEmpty) {
      context.read<FetchEventsByCompetitionBloc>().add(FetchEventsByCompetitionSetToInit());
      return;
    }

    // Resolve which competition to highlight from the URL param, falling back to first
    final CompetitionByEventType comp;
    String? targetId = widget.initialCompetitionId;
    if (targetId != null) {
      comp = widget.competitionByEventType.firstWhere((c) => c.id == targetId, orElse: () => widget.competitionByEventType.first);
    } else {
      comp = widget.competitionByEventType.first;
    }
    competitionId = comp.id;
    selectedCompName = comp.name;
    filteredCompetitions = widget.competitionByEventType;
    context.read<FetchEventsByCompetitionBloc>().add(FetchEventsByCompetition(competitionId: comp.id, provider: comp.provider));
  }

  void filterCompetitions(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCompetitions = widget.competitionByEventType;
      } else {
        filteredCompetitions = widget.competitionByEventType.where((comp) => comp.name.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      shadowColor: grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search competitions',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  filterCompetitions(value);
                },
              ),
            ),
            hb5,
            Expanded(
              child: ListView.builder(
                itemCount: filteredCompetitions.length,
                itemBuilder: (context, index) {
                  final comp = filteredCompetitions[index];
                  return MenuTileWithLabel(
                    key: Key(comp.name),
                    selectedEditorName: selectedCompName,
                    compName: comp.name,
                    compId: comp.id,
                    selectedCompId: competitionId,
                    rightClickUrl: '${widget.basePath}?sportId=${widget.currentSportId}&competitionId=${comp.id}',
                    action: () {
                      setState(() {
                        competitionId = comp.id;
                        selectedCompName = comp.name;
                      });
                      context.read<FetchEventsByCompetitionBloc>().add(FetchEventsByCompetition(competitionId: competitionId, provider: comp.provider));
                      context.go('${widget.basePath}?sportId=${widget.currentSportId}&competitionId=${comp.id}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
