import 'dart:io';

int id_actual = 0;
List<WebSocket> conexiones = [];

main() async {
  try {
    var server = await HttpServer.bind('localhost', 4040);
    server.serverHeader = "DartEcho (1.0) by James Slocum";
    print("HttpServer listening...");
    await for (HttpRequest request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocketTransformer.upgrade(request).then(handleWebSocket);
      } else {
        print("Regular ${request.method} request for: ${request.uri.path}");
        serveRequest(request);
      }
    }
  } catch (e) {
    print(e);
  }
}

void handleWebSocket(WebSocket socket) {
  conexiones[++id_actual] = socket;
  print('Client $id_actual connected!');
  socket.listen((String s) {
    print('Client sent: $s');
    socket.add('echo: $s');
  }, onDone: () {
    print('Client disconnected');
  });
}

void serveRequest(HttpRequest request) {
  request.response.statusCode = HttpStatus.FORBIDDEN;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}
