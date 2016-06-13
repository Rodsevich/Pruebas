import 'dart:io';

WebSocket ws;

void main(List<String> args){
  if (args.length < 1){
    print('Please specify a server URI. ex ws://example.org');
    exit(1);
  }

  String server = args[0];

  //Open the websocket and attach the callbacks
  WebSocket.connect(server).then((WebSocket socket) {
    ws = socket; 
    ws.listen(onMessage, onDone: connectionClosed);
  });

  //Attach to stdin to read from the keyboard
  stdin.listen(onInput);
}

void onMessage(String message){
  print(message);
}

void connectionClosed() {
  print('Connection to server closed');
}

void onInput(List<int> input){
  String message = new String.fromCharCodes(input).trim();

  //Exit gracefully if the user types 'quit'
  if (message == 'quit'){
    ws.close();
    exit(0);
  }

  ws.add(message);
}
