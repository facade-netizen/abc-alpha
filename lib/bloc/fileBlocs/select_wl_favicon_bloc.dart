import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import '../../reusable/pick_file_helper.dart';

class SelectFaviconBloc extends Bloc<SelectFaviconEvent, SelectFaviconState> {
  SelectFaviconBloc() : super(SelectFaviconInitial()) {
    on<SelectFavicon>((event, emit) async {
      emit(SelectFaviconProgress());
      try {
        final bytes = await pickPngFile();
        if (bytes == null) {
          emit(SelectFaviconFailure(error: 'No file selected.'));
          return;
        }

        if (bytes.length > 1024 * 1024) {
          emit(SelectFaviconFailure(error: 'File size exceeds 1MB limit.'));
          return;
        }

        final decodedImage = img.decodeImage(bytes);
        if (decodedImage == null) {
          emit(SelectFaviconFailure(error: 'Invalid image file.'));
          return;
        }

        if (decodedImage.width > 512 || decodedImage.height > 512) {
          emit(SelectFaviconFailure(error: 'Image dimensions must be 512x512 or smaller.\nSelected: ${decodedImage.width}x${decodedImage.height}'));
          return;
        }

        emit(SelectFaviconSuccess(selectedFileBytes: bytes, imageExtension: 'png'));
      } catch (e) {
        if (kDebugMode) debugPrint('select_favicon_bloc.dart [ Exception]>> \n $e');
        emit(SelectFaviconFailure(error: 'select_favicon_bloc.dart [ Exception]>> $e'));
      }
    });

    on<SelectFaviconSetToInitial>((event, emit) {
      if (kDebugMode) debugPrint("Upload image bloc set to initial");
      emit(SelectFaviconInitial());
    });
  }
}

// Event Classes
abstract class SelectFaviconEvent {}

class SelectFavicon extends SelectFaviconEvent {}

class SelectFaviconSetToInitial extends SelectFaviconEvent {}

// State Classes
abstract class SelectFaviconState {}

class SelectFaviconInitial extends SelectFaviconState {}

class SelectFaviconProgress extends SelectFaviconState {}

class SelectFaviconSuccess extends SelectFaviconState {
  final Uint8List selectedFileBytes;
  final String imageExtension;
  SelectFaviconSuccess({required this.selectedFileBytes, required this.imageExtension});
}

class SelectFaviconFailure extends SelectFaviconState {
  final dynamic error;
  SelectFaviconFailure({this.error});
}
