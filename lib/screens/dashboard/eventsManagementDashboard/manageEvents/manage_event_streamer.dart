import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_event_type_bloc.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import 'competitions_screen.dart';

class ManageEventStreamer extends StatefulWidget {
  const ManageEventStreamer({super.key, this.initialSportId, this.initialCompetitionId, required this.basePath});

  final String? initialSportId;
  final String? initialCompetitionId;
  final String basePath;

  @override
  State<ManageEventStreamer> createState() => _ManageEventStreamerState();
}

class _ManageEventStreamerState extends State<ManageEventStreamer> {
  @override
  void initState() {
    super.initState();
    // Only fetch event types if not already loaded (they don't change during a session)
    if (context.read<FetchEventTypesBloc>().state is! FetchEventTypesSuccess) {
      context.read<FetchEventTypesBloc>().add(FetchEventTypes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchEventTypesBloc, FetchEventTypesState>(
      builder: (context, ets) {
        if (ets is FetchEventTypesProgress) return LoaderContainerWithMessage();
        if (ets is FetchEventTypesSuccess) {
          return CompetitionsScreen(
            eventTypeData: ets.eventTypes,
            initialSportId: widget.initialSportId,
            initialCompetitionId: widget.initialCompetitionId,
            basePath: widget.basePath,
          );
        }
        return NoData();
      },
    );
  }
}
