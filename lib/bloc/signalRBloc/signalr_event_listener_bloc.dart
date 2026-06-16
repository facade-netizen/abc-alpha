import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../apis/apiHandlers/api_constants.dart';
import '../../model/fancy_catalouges_on_markettype_model.dart';
import 'protoUsage/receive/receive.pb.dart';

/// reconnection Listener
final StreamController<String> connectionStateController = StreamController<String>.broadcast();
Stream<String> get connectionStateStream => connectionStateController.stream;

// Facy Market Streamer
final StreamController<FancyCatalougesOnMarketType> fancyMarketStreamController = StreamController.broadcast();
Stream<FancyCatalougesOnMarketType> get fancyMarketStream => fancyMarketStreamController.stream;

class SignalREventListenerBloc extends Bloc<SignalREventListenerEvent, SignalREventListenerState> {
  HubConnection hubConnection = HubConnectionBuilder()
      .withUrl(SportsApiConstants.bmSignalRUrl, options: HttpConnectionOptions(transport: HttpTransportType.WebSockets, requestTimeout: 35000))
      .withAutomaticReconnect()
      .build();
  String? eventIDN;
  SignalREventListenerBloc() : super(SignalREventListenerInitial()) {
    on<SignalREventListener>((event, emit) async {
      debugPrint("SignalREventListenerBloc Called");
      connectionStateController.add('connecting');
      emit(SignalREventListenerProgress());
      String eventId = event.eventId;
      eventIDN = eventId;
      try {
        if (hubConnection.state == HubConnectionState.Connected || hubConnection.state == HubConnectionState.Connecting) {
          await send(eventId);
        } else {
          await connect(eventId);
        }
      } catch (e) {
        connectionStateController.add('disconnected');
        emit(SignalREventListenerFailure(e.toString()));
      }
    });

    on<SignalREventDisconnect>((event, emit) async {
      debugPrint("SignalREventDisconnect Called for EventId: ${event.eventId}");
      try {
        if (hubConnection.state == HubConnectionState.Connected) {
          await hubConnection.invoke("UnsubscribeEvent", args: [event.eventId]);
          debugPrint("Unsubscribed from EventId: ${event.eventId}");
        }
      } catch (e) {
        debugPrint("SignalR unsubscribe failed: $e");
      }
    });

    /// Handling Reconnection Events
    hubConnection.onreconnecting(({Exception? error}) async {
      if (kDebugMode) debugPrint("Listener SignalR reconnecting");
      connectionStateController.add('reconnecting');
    });

    hubConnection.onreconnected(({String? connectionId}) async {
      if (kDebugMode) debugPrint("Listener SignalR reconnected $connectionId");
      connectionStateController.add('reconnected');
      await send(eventIDN!);
    });

    /// Listener method called line
    hubConnection.on('line', (message) {
      parseProtoToFancyMarketModel(message, isLine: true);
    });

    hubConnection.on('lines', (message) {
      parseProtoToFancyMarketModel(message);
    });
  }

  void parseProtoToFancyMarketModel(List<Object?>? message, {bool isLine = false}) {
    if (message != null && message.isNotEmpty) {
      try {
        if (message.runtimeType.toString() == "Uint8List" || message.runtimeType.toString().contains("minified") || message.runtimeType == List<Object?>) {
          if (isLine) {
            final String base64String = message.first as String;
            final Uint8List bytes = base64.decode(base64String);
            final ABCModel model = ABCModel.fromBuffer(bytes);
            FancyCatalougesOnMarketType fancyData = FancyCatalougesOnMarketType.fromBuffer(model);
            fancyMarketStreamController.sink.add(fancyData);
          } else {
            final String base64String = message.first as String;
            final bytes = base64.decode(base64String);
            final ABCModelList modelList = ABCModelList.fromBuffer(bytes);
            for (final model in modelList.items) {
              if (model.eventId != eventIDN) continue;
              FancyCatalougesOnMarketType fancyData = FancyCatalougesOnMarketType.fromBuffer(model);
              fancyMarketStreamController.add(fancyData);
            }
          }
        } else {
          if (kDebugMode) debugPrint("Message type not recognized : ${message.runtimeType.toString()}");
        }
      } catch (e) {
        if (kDebugMode) debugPrint("Caught Error : $e");
      }
    }
  }

  Future<void> connect(String eventId) async {
    if (hubConnection.state == HubConnectionState.Disconnected) {
      try {
        await hubConnection.start();
        if (kDebugMode) debugPrint("SignalR Connection Start");
        await send(eventId);
      } catch (e) {
        if (kDebugMode) debugPrint("SignalR connect failed: $e");
      }
    }
  }

  Future<void> send(String eventId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        final result = await hubConnection.invoke("SubscribeEvent", args: [eventId]);
        if (kDebugMode) debugPrint("SignalR Send Done, Result - $result");
      } catch (e) {
        if (kDebugMode) debugPrint("SignalR send failed: $e");
      }
    }
  }

  Future<void> disconnect() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      connectionStateController.close();
      fancyMarketStreamController.close();
      await hubConnection.stop();
    }
  }

  @override
  Future<void> close() async {
    await disconnect();
    connectionStateController.close();
    fancyMarketStreamController.close();
    return super.close();
  }
}

abstract class SignalREventListenerState {}

class SignalREventListenerInitial extends SignalREventListenerState {}

class SignalREventListenerProgress extends SignalREventListenerState {}

class SignalREventListenerSuccess extends SignalREventListenerState {
  SignalREventListenerSuccess();
}

class SignalREventListenerFailure extends SignalREventListenerState {
  final dynamic error;
  SignalREventListenerFailure(this.error);
}

abstract class SignalREventListenerEvent {}

class SignalREventListener extends SignalREventListenerEvent {
  final String eventId;
  SignalREventListener({required this.eventId});
}

class SignalREventDisconnect extends SignalREventListenerEvent {
  final String eventId;
  SignalREventDisconnect({required this.eventId});
}
