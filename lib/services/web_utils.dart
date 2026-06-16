/// WASM-safe web utilities.
///
/// Replaces all `dart:html` usage with `package:web` + `dart:js_interop`
/// so the app can compile to WebAssembly.
library;

import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Opens [url] in a new browser tab.
void openNewTab(String url) {
  web.window.open(url, '_blank');
}

/// Replaces the current browser history entry with [url].
void historyReplaceState(String url) {
  web.window.history.replaceState(''.toJS, '', url);
}

/// Pushes a new browser history entry with [url].
void historyPushState(String url) {
  web.window.history.pushState(''.toJS, '', url);
}

/// Listens for the browser's `popstate` event (back/forward navigation).
/// Returns a teardown function that removes the listener.
void Function() onPopState(void Function() callback) {
  void handler(web.Event event) => callback();
  final jsHandler = handler.toJS;
  web.window.addEventListener('popstate', jsHandler);
  return () => web.window.removeEventListener('popstate', jsHandler);
}

/// Triggers a browser download of [bytes] with the given [fileName] and [mimeType].
void downloadBytes(List<int> bytes, String fileName, {String mimeType = 'application/octet-stream'}) {
  final blob = web.Blob([Uint8List.fromList(bytes).toJS].toJS, web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName;
  anchor.click();
  web.URL.revokeObjectURL(url);
}

/// Triggers a browser download of a base64-encoded data URI.
void downloadBase64(List<int> bytes, String fileName) {
  final anchor = web.HTMLAnchorElement()
    ..href = 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}'
    ..download = fileName;
  anchor.click();
}

/// Opens a file picker for [accept] types (e.g. '.png') and returns the
/// selected file's bytes, or null if cancelled.
Future<List<int>?> pickFileBytes({String accept = '*/*'}) async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = accept;
  input.click();

  // Wait for the user to select a file
  await input.onChange.first;

  final files = input.files;
  if (files == null || files.length == 0) return null;

  final file = files.item(0);
  if (file == null) return null;

  final reader = web.FileReader();
  reader.readAsArrayBuffer(file);
  await reader.onLoadEnd.first;

  final result = reader.result;
  if (result == null) return null;
  return (result as JSArrayBuffer).toDart.asUint8List();
}
