library dartchat;

import 'dart:io';
import 'dart:convert';

part 'message.dart';

class ChatClient {
  static const PENDING = 1;
  static const CONNECTED = 2;

  int _status = ChatClient.PENDING;
  WebSocket _socket;
  String _username;
  
  ChatClient(WebSocket ws){
    _socket = ws;

    _socket.listen(messageHandler,
        onError: errorHandler,
        onDone: finishedHandler);
  }

  void write(String message){
    _socket.add(message);
  }

  void messageHandler(String data){
    String json = data.trim();
    print(json);
    APIMessage message = new APIMessage.fromJson(json);
    _handleAPIMessage(message);
  }

  void errorHandler(error){
    print('${_username} Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('${_username} Disconnected');
    distributeMessage(this, new NoticeMessage('\"${_username}\" has left the room'));
    removeClient(this);
    _socket.close();
  }

  void _handleAPIMessage(APIMessage message){
    switch (message.type){
      case APIMessage.MESSAGE:
        if (_status == ChatClient.CONNECTED){
          distributeMessage(this, message);
        }
        break;
      case APIMessage.INIT:
        InitMessage init = message as InitMessage;
        _username = init.username;
        _status = ChatClient.CONNECTED;
        sendWelcome(this);
        addClient(this);
        distributeMessage(this, new NoticeMessage('\"${_username}\" has joined the room'));
        break;
      default:
        return;
    }
  }
}

List<ChatClient> clients = new List();

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, 8080).then((HttpServer server) {
    print("HttpServer listening...");
    server.serverHeader = "DartChat (1.0) by James Slocum";
    server.listen((HttpRequest request) {
      if (WebSocketTransformer.isUpgradeRequest(request)){
        WebSocketTransformer.upgrade(request).then(handleWebSocket);
      }
      else {
        print("Regular ${request.method} request for: ${request.uri.path}");
        serveRequest(request);
      }
    });
  });
}

void handleWebSocket(WebSocket socket){
  print('Client connected!');
  ChatClient client = new ChatClient(socket);
}

void distributeMessage(ChatClient client, APIMessage message){
  for (ChatClient c in clients){
    if (c != client){
      c.write(message.toJson());
    }
  }
}

void sendWelcome(ChatClient c){
  NoticeMessage notice = new NoticeMessage("Welcome to Dart chat! " 
      "there are ${clients.length} clients connected");
  c.write(notice.toJson()); 
}

void addClient(ChatClient c){
  clients.add(c);
}

void removeClient(ChatClient c){
  clients.remove(c);
}

void serveRequest(HttpRequest request){
  request.response.statusCode = HttpStatus.FORBIDDEN;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}
