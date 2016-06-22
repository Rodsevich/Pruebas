import "package:test/test.dart";
import 'package:pruebas_dart/Servidor.dart';
import 'dart:html';
import 'dart:io';

void main() {
  var server, c1, c2;
  setUp(() async {
    server = await HttpServer.bind('localhost', 0);
    url = Uri.parse("http://${server.address.host}:${server.port}");
  });

  tearDown(() async {
    await server.close(force: true);
    server = null;
    url = null;
  });
  group("Funcionalidad basica server", () {
    group("Creacion de MensajeNegociacionWebRTC", () {
      test("MensajeNegociacionWebRTC creado desde el cliente", () {
        var msjNeg = new MensajeNegociacionWebRTC("id", "sorpi");
        expect(msjNeg.tipo, equals(MensajesAPI.NEGOCIACION_WEBRTC));
        expect(msjNeg.destinatario, equals("id"));
        expect(msjNeg.contenido, equals("sorpi"));
        expect(
            msjNeg.toString(),
            equals(
                "[${MensajesAPI.NEGOCIACION_WEBRTC.index},\"id\",\"sorpi\"]"));
      });
    });
  });
}
