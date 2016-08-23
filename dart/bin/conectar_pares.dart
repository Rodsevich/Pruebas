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
  List<int> ids = [];
  for (WebSocket socket in conexiones) ids.add(conexiones.indexOf(socket));
  for (WebSocket socket in conexiones) socket.add("pares,${JSON.encode(ids)}");
}

void handleWebSocket(WebSocket socket) {
  conexiones.add(socket);
  id_actual = conexiones.indexOf(socket);
  print('Client $id_actual connected!');
  socket.add("reg,$id_actual");
  enviarPares();
  socket.listen((String mensaje) {
    int id = conexiones.indexOf(socket);
    print('Client $id sent: $mensaje');
    List<String> msj = mensaje.split(',');
    switch (msj[0]) {
      case "offer":
        int idParAConectar = JSON.decode(msj[1]);
        var sessionDescriptionDelOfferer = msj[2];
        conexiones[idParAConectar]
            .add("oferr,$id,$sessionDescriptionDelOfferer");
        break;
      case "answer":
        int idParAConectar = JSON.decode(msj[1]);
        var sessionDescriptionDelAnswerer = msj[2];
        conexiones[idParAConectar].add("answer,$sessionDescriptionDelAnswerer");
        break;
      case "candidate":
    }
  }, onDone: () {
    int id = conexiones.indexOf(socket);
    conexiones[id] = null;
    print('Client $id disconnected');
  });
}

manejarComunicaciones(int id, String datos) {}

void serveRequest(HttpRequest request) {
  request.response.statusCode = HttpStatus.FORBIDDEN;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}
