import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

import '../../reusable/pick_file_helper.dart';

class SelectWLLogoBloc extends Bloc<SelectWLLogoEvent, SelectWLLogoState> {
  SelectWLLogoBloc() : super(SelectWLLogoInitial()) {
    on<SelectWLLogo>((event, emit) async {
      emit(SelectWLLogoProgress());
      try {
        final bytes = await pickPngFile();
        if (bytes == null) {
          emit(SelectWLLogoFailure(error: 'No file selected.'));
          return;
        }

        if (bytes.length > 1024 * 1024) {
          emit(SelectWLLogoFailure(error: 'File size exceeds 1MB limit.'));
          return;
        }

        final decodedImage = img.decodeImage(bytes);
        if (decodedImage == null) {
          emit(SelectWLLogoFailure(error: 'Invalid image file.'));
          return;
        }

        if (decodedImage.width > 512 || decodedImage.height > 512) {
          emit(SelectWLLogoFailure(error: 'Image dimensions must be 512x512 or smaller.\nSelected: ${decodedImage.width}x${decodedImage.height}'));
          return;
        }

        emit(SelectWLLogoSuccess(selectedFileBytes: bytes, imageExtension: 'png'));
      } catch (e) {
        emit(SelectWLLogoFailure(error: e.toString()));
      }
    });

    on<SelectWLLogoSetToInitial>((event, emit) {
      emit(SelectWLLogoInitial());
    });
  }
}

// Event Classes
abstract class SelectWLLogoEvent {}

class SelectWLLogo extends SelectWLLogoEvent {}

class SelectWLLogoSetToInitial extends SelectWLLogoEvent {}

// State Classes
abstract class SelectWLLogoState {}

class SelectWLLogoInitial extends SelectWLLogoState {}

class SelectWLLogoProgress extends SelectWLLogoState {}

class SelectWLLogoSuccess extends SelectWLLogoState {
  final Uint8List? selectedFileBytes;
  final String imageExtension;
  SelectWLLogoSuccess({required this.selectedFileBytes, required this.imageExtension});
}

class SelectWLLogoFailure extends SelectWLLogoState {
  final dynamic error;
  SelectWLLogoFailure({this.error});
}


