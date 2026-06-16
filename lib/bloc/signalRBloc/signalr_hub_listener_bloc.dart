import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../apis/apiHandlers/api_constants.dart';
import '../../localDb/token/login_token_box.dart';
import '../../localDb/token/login_token_model.dart';
import '../../model/live_fancy_bet_exposure_model.dart';

/// reconnection Listener
final StreamController<String> connectionHubStateController = StreamController<String>.broadcast();
Stream<String> get connectionHubStateStream => connectionHubStateController.stream;

// Message Streamer
final StreamController<FancyLiveBetExposure> fblExpStreamController = StreamController.broadcast();
Stream<FancyLiveBetExposure> get fblExpStream => fblExpStreamController.stream;

class SignalRHubListenerBloc extends Bloc<SignalRHubListenerEvent, SignalRHubListenerState> {
  HubConnection hubConnection = HubConnectionBuilder()
      .withUrl(OrdersApiConstants.listener, options: HttpConnectionOptions(transport: HttpTransportType.WebSockets, requestTimeout: 35000))
      .withAutomaticReconnect()
      .build();

  SignalRHubListenerBloc() : super(SignalRHubListenerInitial()) {
    on<SignalRHubListener>((event, emit) async {
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      if (kDebugMode) debugPrint("SignalRHubListenerBloc Called");
      connectionHubStateController.add('connecting');
      emit(SignalRHubListenerProgress());
      try {
        if (savedTokenData != null) {
          if (hubConnection.state == HubConnectionState.Connected || hubConnection.state == HubConnectionState.Connecting) {
            await send(savedTokenData.token!);
          } else {
            await connect(savedTokenData.token!);
          }
        } else {
          connectionHubStateController.add('disconnected');
          emit(SignalRHubListenerFailure("User not logged in"));
        }
      } catch (e) {
        connectionHubStateController.add('disconnected');
        emit(SignalRHubListenerFailure(e.toString()));
      }
    });

    on<SignalRHubDisconnect>((event, emit) async {
      if (kDebugMode) debugPrint("SignalRHubDisconnect Called ");
      try {
        await disconnect();
      } catch (e) {
        if (kDebugMode) debugPrint("SignalR unsubscribe failed: $e");
      }
    });

    /// Handling Reconnection Events
    hubConnection.onreconnecting(({Exception? error}) async {
      if (kDebugMode) debugPrint("HUB Listener SignalR reconnecting");
      connectionHubStateController.add('reconnecting');
    });

    hubConnection.onreconnected(({String? connectionId}) async {
      if (kDebugMode) debugPrint("Hub Listener SignalR reconnected $connectionId");
      SaveLoginTokenModel? savedTokenData = SaveTokenBox.loginTokenBox.fetchLoginToken;
      connectionHubStateController.add('reconnected');
      await send(savedTokenData!.token!);
    });

    hubConnection.on('catalougeDetail', (message) {
      parseProtoToMessageModel(message, "catalougeDetail Signal");
    });
  }

  void parseProtoToMessageModel(List<Object?>? message, String type) {
    if (message != null && message.isNotEmpty) {
      try {
        if (message.runtimeType.toString() == "Uint8List" || message.runtimeType.toString().contains("minified") || message.runtimeType == List<Object?>) {
          final Map<String, dynamic> decoded = jsonDecode(message[0].toString());
          final parsedData = FancyLiveBetExposure.fromProto(decoded);
          fblExpStreamController.sink.add(parsedData);
          if (kDebugMode) debugPrint("Data For Live : ${message.runtimeType.toString()}");
        } else {
          if (kDebugMode) debugPrint("Message type not recognized : ${message.runtimeType.toString()}");
        }
      } catch (e) {
        if (kDebugMode) debugPrint("Caught Error : $e");
      }
    }
  }

  Future<void> connect(String token) async {
    if (hubConnection.state == HubConnectionState.Disconnected) {
      try {
        await hubConnection.start();
        if (kDebugMode) debugPrint("Hub listener SignalR Connection Start");
        await send(token);
      } catch (e) {
        if (kDebugMode) debugPrint("Hub listener SignalR connect failed: $e");
      }
    }
  }

  Future<void> send(String token) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        final result = await hubConnection.invoke("AuthenticateUser", args: [token]);
        if (kDebugMode) debugPrint("Hub listener SignalR Send Done, Result - $result");
      } catch (e) {
        if (kDebugMode) debugPrint("Hub listener SignalR send failed: $e");
      }
    }
  }

  Future<void> disconnect() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      connectionHubStateController.close();
      await hubConnection.stop();
    }
  }

  @override
  Future<void> close() async {
    await disconnect();
    connectionHubStateController.close();
    return super.close();
  }
}

abstract class SignalRHubListenerState {}

class SignalRHubListenerInitial extends SignalRHubListenerState {}

class SignalRHubListenerProgress extends SignalRHubListenerState {}

class SignalRHubListenerSuccess extends SignalRHubListenerState {
  SignalRHubListenerSuccess();
}

class SignalRHubListenerFailure extends SignalRHubListenerState {
  final dynamic error;
  SignalRHubListenerFailure(this.error);
}

abstract class SignalRHubListenerEvent {}

class SignalRHubListener extends SignalRHubListenerEvent {}

class SignalRHubDisconnect extends SignalRHubListenerEvent {}
