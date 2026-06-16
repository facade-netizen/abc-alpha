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
final StreamController<FancyCatalougesOnMarketType> fancySingleMarketStreamController = StreamController.broadcast();
Stream<FancyCatalougesOnMarketType> get fancySingleMarketStream => fancySingleMarketStreamController.stream;

class SignalRSingleMarketListenerBloc extends Bloc<SignalRSingleMarketListenerEvent, SignalRSingleMarketListenerState> {
  HubConnection hubConnection = HubConnectionBuilder()
      .withUrl(SportsApiConstants.bmSignalRUrl, options: HttpConnectionOptions(transport: HttpTransportType.WebSockets, requestTimeout: 35000))
      .withAutomaticReconnect()
      .build();
  String? marketIDN;
  SignalRSingleMarketListenerBloc() : super(SignalRSingleMarketListenerInitial()) {
    on<SignalRSingleMarketListener>((event, emit) async {
      debugPrint("SignalRSingleMarketListenerBloc Called");
      connectionStateController.add('connecting');
      emit(SignalRSingleMarketListenerProgress());
      String marketId = event.marketId;
      marketIDN = marketId;
      try {
        if (hubConnection.state == HubConnectionState.Connected || hubConnection.state == HubConnectionState.Connecting) {
          await send(marketId);
        } else {
          await connect(marketId);
        }
      } catch (e) {
        connectionStateController.add('disconnected');
        emit(SignalRSingleMarketListenerFailure(e.toString()));
      }
    });

    on<SignalRSingleMarketListenerDisconnect>((event, emit) async {
      debugPrint("SignalRSingleMarketListenerDisconnect Called for MarketId: ${event.marketId}");
      try {
        if (hubConnection.state == HubConnectionState.Connected) {
          await hubConnection.invoke("UnsubscribeEvent", args: [event.marketId]);
          debugPrint("Unsubscribed from MarketId: ${event.marketId}");
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
      await send(marketIDN!);
    });

    /// Listener method called single
    hubConnection.on('single', (message) {
      parseProtoToFancyMarketModel(message);
    });
  }

  void parseProtoToFancyMarketModel(List<Object?>? message) {
    if (message != null && message.isNotEmpty) {
      try {
        if (message.runtimeType.toString() == "Uint8List" || message.runtimeType.toString().contains("minified") || message.runtimeType == List<Object?>) {
          final String base64String = message.first as String;
          final Uint8List bytes = base64.decode(base64String);
          final ABCModel model = ABCModel.fromBuffer(bytes);
          FancyCatalougesOnMarketType fancyData = FancyCatalougesOnMarketType.fromBuffer(model);
          // if (kDebugMode) {
          //   log("Main Bloc EventId ${model.eventId} Market ${model.marketId} Status ${model.status} ");
          // }
          fancySingleMarketStreamController.sink.add(fancyData);
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
        final result = await hubConnection.invoke("SubscribeSingleMarket", args: [eventId]);
        if (kDebugMode) debugPrint("SignalR Send Done, Result - $result");
      } catch (e) {
        if (kDebugMode) debugPrint("SignalR send failed: $e");
      }
    }
  }

  Future<void> disconnect() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      connectionStateController.close();
      fancySingleMarketStreamController.close();
      await hubConnection.stop();
    }
  }

  @override
  Future<void> close() async {
    await disconnect();
    connectionStateController.close();
    fancySingleMarketStreamController.close();
    return super.close();
  }
}

abstract class SignalRSingleMarketListenerState {}

class SignalRSingleMarketListenerInitial extends SignalRSingleMarketListenerState {}

class SignalRSingleMarketListenerProgress extends SignalRSingleMarketListenerState {}

class SignalRSingleMarketListenerSuccess extends SignalRSingleMarketListenerState {
  SignalRSingleMarketListenerSuccess();
}

class SignalRSingleMarketListenerFailure extends SignalRSingleMarketListenerState {
  final dynamic error;
  SignalRSingleMarketListenerFailure(this.error);
}

abstract class SignalRSingleMarketListenerEvent {}

class SignalRSingleMarketListener extends SignalRSingleMarketListenerEvent {
  final String marketId;
  SignalRSingleMarketListener({required this.marketId});
}

class SignalRSingleMarketListenerDisconnect extends SignalRSingleMarketListenerEvent {
  final String marketId;
  SignalRSingleMarketListenerDisconnect({required this.marketId});
}
