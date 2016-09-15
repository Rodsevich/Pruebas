import "package:WebRTCnetmesh/WebRTCnetmesh_server.dart";

main() {
  WebRTCnetmesh receptor = new WebRTCnetmesh();
  receptor.onNewConnection.listen((id) => print("conectado ${id.nombre}"));
  receptor.onMessage.listen((msj) => print("mensaje de ${msj.id_emisor}"));
  receptor.onCommand.listen((cmd) => print("¡Un comando! :O"));
  print("escuchanding...");
}
