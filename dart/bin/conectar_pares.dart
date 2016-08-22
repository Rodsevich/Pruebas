import 'dart:io';
import 'dart:convert';

//http://www.one-tab.com/page/Hl_J8miTTTmeGBO0kkqPVg

int id_actual = -1;
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

void enviarPares() {
  List<int> ids;
  for (var socket in conexiones) ids.add(conexiones.indexOf(socket));
  for (var socket in conexiones) socket.add("pares,${JSON.encode(ids)}");
}

void handleWebSocket(WebSocket socket) {
  conexiones[++id_actual] = socket;
  print('Client $id_actual connected!');
  socket.add("reg,$id_actual");
  enviarPares();
  socket.listen((String s) {
    print('Client sent: $s');
    List<String> msj = e.data.toString().split(',');
    switch (msj[0]) {
      case "offer":
        int idParAConectar = JSON.decode(msj[1]);
        var sessionDescriptionDelOfferer = msj[2];
        conexiones[idParAConectar].add("oferr,$sessionDescriptionDelOfferer");
        break;
      case "candidate":
    }
  }, onDone: () {
    print('Client disconnected');
  });
}

void serveRequest(HttpRequest request) {
  request.response.statusCode = HttpStatus.FORBIDDEN;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}
