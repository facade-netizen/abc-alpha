import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/apiHandlers/api_constants.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';

class AddNewWhiteLableBloc extends Bloc<AddNewWhiteLableEvent, AddNewWhiteLableState> {
  AddNewWhiteLableBloc() : super(AddNewWhiteLableInitial()) {
    on<AddNewWhiteLable>((event, emit) async {
      emit(AddNewWhiteLableProgress());
      debugPrint("Called AddNewWhiteLableBloc");
      SaveLoginTokenModel? savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (savedData == null) {
        emit(AddNewWhiteLableFailure("User not logged in"));
        return;
      }
      try {
        final dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${savedData.token}";
        dio.options.headers["Accept"] = "application/json";
        dio.options.validateStatus = (status) => status! < 500;
        event.addNewWhiteLableMap["createdByUserId"] = savedData.userId;
        FormData formData = FormData();
        event.addNewWhiteLableMap.forEach((key, value) {
          if (key == "logo" || key == "favicon") {
            if (value != null && value.toString().isNotEmpty) {
              try {
                final bytes = base64Decode(value.toString());
                final filename = key == "logo" ? "logo.png" : "favicon.png";
                formData.files.add(MapEntry(key, MultipartFile.fromBytes(bytes, filename: filename)));
              } catch (e) {
                if (kDebugMode) debugPrint("Error decoding $key: $e");
                emit(AddNewWhiteLableFailure("Catch error 1 >> $emit"));
              }
            }
          } else {
            if (value != null) formData.fields.add(MapEntry(key, value.toString()));
          }
        });
        final response = await dio.post("${WlApiConstants.baseUrl}${WlApiConstants.add}", data: formData);
        if (kDebugMode) debugPrint("Response code: ${response.statusCode}, body: ${response.data}");
        if (response.statusCode == 200) {
          emit(AddNewWhiteLableSuccess());
        } else {
          if (kDebugMode) debugPrint("Response error: ${response.statusCode}, body: ${response.data}");
          emit(AddNewWhiteLableFailure("Response error >> ${response.statusCode}: ${response.data}"));
        }
      } catch (e) {
        if (kDebugMode) debugPrint("Exception catch 2 >> $e");
        emit(AddNewWhiteLableFailure(e));
      }
    });
  }
}

// ------------------ States ------------------
abstract class AddNewWhiteLableState {}

class AddNewWhiteLableInitial extends AddNewWhiteLableState {}

class AddNewWhiteLableProgress extends AddNewWhiteLableState {}

class AddNewWhiteLableSuccess extends AddNewWhiteLableState {}

class AddNewWhiteLableFailure extends AddNewWhiteLableState {
  final dynamic error;
  AddNewWhiteLableFailure(this.error);
}

// ------------------ Events ------------------
abstract class AddNewWhiteLableEvent {}

class AddNewWhiteLable extends AddNewWhiteLableEvent {
  AddNewWhiteLable({required this.addNewWhiteLableMap});
  final Map<String, dynamic> addNewWhiteLableMap;
}
