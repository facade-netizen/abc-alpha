import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiHandlers/api_constants.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class UpdateWhiteLableBloc extends Bloc<UpdateWhiteLableEvent, UpdateWhiteLableState> {
  UpdateWhiteLableBloc() : super(UpdateWhiteLableInitial()) {
    on<UpdateWhiteLable>((event, emit) async {
      emit(UpdateWhiteLableProgress());
      debugPrint("Called UpdateWhiteLableBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData == null) {
        emit(UpdateWhiteLableFailure("User not logged in"));
        return;
      }
      try {
        final dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${savedData.token}";
        dio.options.headers["Accept"] = "application/json";
        dio.options.validateStatus = (status) => status! < 500;
        event.updateWhiteLableMap["createdByUserId"] = savedData.userId;
        FormData formData = FormData();
        event.updateWhiteLableMap.forEach((key, value) {
          if (key == "logo" || key == "favicon") {
            if (value != null && value.toString().isNotEmpty) {
              try {
                final bytes = base64Decode(value.toString());
                final filename = key == "logo" ? "logo.png" : "favicon.png";
                formData.files.add(MapEntry(key, MultipartFile.fromBytes(bytes, filename: filename)));
              } catch (e) {
                if (kDebugMode) debugPrint("Error decoding $key: $e");
                emit(UpdateWhiteLableFailure("Catch error 1 >> $emit"));
              }
            }
          } else {
            if (value != null) formData.fields.add(MapEntry(key, value.toString()));
          }
        });
        final response = await dio.put("${WlApiConstants.baseUrl}${WlApiConstants.update}", data: formData);
        if (kDebugMode) debugPrint("Response code: ${response.statusCode}, body: ${response.data}");
        if (response.statusCode == 200) {
          emit(UpdateWhiteLableSuccess());
        } else {
          if (kDebugMode) debugPrint("Response error: ${response.statusCode}, body: ${response.data}");
          emit(UpdateWhiteLableFailure("Response error >> ${response.statusCode}: ${response.data}"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint("Exception catch 2 >> $e");
        emit(UpdateWhiteLableFailure(e));
      }
    });
  }
}

abstract class UpdateWhiteLableState {}

class UpdateWhiteLableInitial extends UpdateWhiteLableState {}

class UpdateWhiteLableProgress extends UpdateWhiteLableState {}

class UpdateWhiteLableSuccess extends UpdateWhiteLableState {}

class UpdateWhiteLableFailure extends UpdateWhiteLableState {
  final dynamic error;
  UpdateWhiteLableFailure(this.error);
}

abstract class UpdateWhiteLableEvent {}

class UpdateWhiteLable extends UpdateWhiteLableEvent {
  UpdateWhiteLable({required this.updateWhiteLableMap});
  final Map<String, dynamic> updateWhiteLableMap;
}
