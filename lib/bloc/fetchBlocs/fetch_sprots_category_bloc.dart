import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../apis/apiHandlers/api_constants.dart';
import '../../model/sport_category_model.dart';

class FetchSportsCategoryBloc extends Bloc<FetchSportsCategoryEvent, FetchSportsCategoryState> {
  FetchSportsCategoryBloc() : super(FetchSportsCategoryInitial()) {
    on<FetchSportsCategory>((event, emit) async {
      emit(FetchSportsCategoryProgress());
      try {
        var request = http.Request('GET', Uri.parse(SportsApiConstants.eventTypes));
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          final bodyString = await response.stream.bytesToString();
          final decoded = jsonDecode(bodyString);
          // debugPrint(decoded.toString());
          CategoryResponse eventResponse = CategoryResponse.fromJson(decoded);
          emit(FetchSportsCategorySuccess(categoryResponse: eventResponse,));
        } else {
          if (kDebugMode) debugPrint("FetchSportEventsBloc - non 200 response ${response.statusCode}");
          emit(FetchSportsCategoryFailure("Non ${response.statusCode} Status"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint("Error caught in FetchSportsCategoryBloc,$e");
        emit(FetchSportsCategoryFailure(e));
      }
    });
  }
}

//states
abstract class FetchSportsCategoryState {}

//events
abstract class FetchSportsCategoryEvent {}

//states implementation
class FetchSportsCategoryInitial extends FetchSportsCategoryState {}

class FetchSportsCategoryProgress extends FetchSportsCategoryState {}

class FetchSportsCategorySuccess extends FetchSportsCategoryState {
  final CategoryResponse categoryResponse;
  FetchSportsCategorySuccess({required this.categoryResponse});
}

class FetchSportsCategoryFailure extends FetchSportsCategoryState {
  final dynamic error;
  FetchSportsCategoryFailure(this.error);
}

//events implementation
class FetchSportsCategory extends FetchSportsCategoryEvent {}
