import "package:test/test.dart";
import 'package:pruebas_dart/src/Mensaje.dart';
import 'dart:convert';

void main() {
  group("Creacion de Mensajes", () {
    group("Creacion de MensajeNegociacionWebRTC", () {
      test("MensajeNegociacionWebRTC creado desde el cliente", () {
        var msjNeg = new MensajeNegociacionWebRTC("id_emisor", "id", "sorpi");
        expect(msjNeg.tipo, equals(MensajesAPI.NEGOCIACION_WEBRTC));
        expect(msjNeg.id_emisor, equals("id_emisor"));
        expect(msjNeg.id_receptor, equals("id"));
        expect(msjNeg.contenido, equals("sorpi"));
        expect(
            msjNeg.toString(),
            equals(
                "[[\"id_emisor\",\"id\",[]],${MensajesAPI.NEGOCIACION_WEBRTC.index},\"id\",\"sorpi\"]"));
      });

      test("MensajeNegociacionWebRTC creado desde el servidor", () {
        String codificacion =
            "[[\"id_emisor\",\"id\",[\"intermediario1\"]],${MensajesAPI.NEGOCIACION_WEBRTC.index},\"pepe\",\"hola, sorp\"]";
        Mensaje msj = new Mensaje.desdeCodificacion(codificacion);
        if (msj is! MensajeNegociacionWebRTC)
          fail(
              "La decodificacion no generó una clase MensajeNegociacionWebRTC");
        expect(msj.tipo, equals(MensajesAPI.NEGOCIACION_WEBRTC));
        expect(msj.id_emisor, equals("id"));
        expect(msj.id_receptor, equals("id_receptor"));
        expect(msj.ids_intermediarios, equals(["intermediario1"]));
        expect(msj.contenido, equals("hola, sorp"));
        expect("$msj", equals(msj.toString()));
        expect(msj.toString(), equalsIgnoringWhitespace(codificacion));
      });
    });
    group("Creacion de MensajeSuscripcion", () {
      String msjEsperado =
          '[[,,[\"int1\"]],${MensajesAPI.SUSCRIPCION.index},"id","Juani123"]';
      test("MensajeSuscripcion creado desde el cliente", () {
        var msjNeg = new MensajeSuscripcion("Juani123");
        expect(msjNeg.tipo, equals(MensajesAPI.SUSCRIPCION));
        expect(msjNeg.pseudonimo, equals("Juani123"));
        expect(msjNeg.toString(), equals(msjEsperado));
        print("se codifica a: ${msjNeg.toString()}");
      });

      test("MensajeSuscripcion creado desde el servidor", () {
        String codificacion = msjEsperado;
        Mensaje msj = new Mensaje.desdeCodificacion(codificacion);
        if (msj is! MensajeSuscripcion)
          fail("La decodificacion no generó una clase MensajeSuscripcion");
        expect(msj.tipo, equals(MensajesAPI.SUSCRIPCION));
        expect(msj.pseudonimo, equals("Juani123"));
        expect("$msj", equals(msj.toString()));
        expect(msj.toString(), equalsIgnoringWhitespace(codificacion));
      });
    });
    group("Creacion de MensajeComando", () {
      String msjEsperado =
          '[[\"id_emisor\",\"id\",[]],${MensajesAPI.COMANDO.index},"id","Juani123"]';
      test("MensajeComando creado desde el cliente", () {
        var msjNeg = new MensajeComando("id", "Juani123");
        expect(msjNeg.tipo, equals(MensajesAPI.COMANDO));
        expect(msjNeg.id, equals("id"));
        expect(msjNeg.pseudonimo, equals("Juani123"));
        expect(msjNeg.toString(), equals(msjEsperado));
      });

      test("MensajeComando creado desde el servidor", () {
        String codificacion = msjEsperado;
        Mensaje msj = new Mensaje.desdeCodificacion(codificacion);
        if (msj is! MensajeComando)
          fail("La decodificacion no generó una clase MensajeComando");
        expect(msj.tipo, equals(MensajesAPI.COMANDO));
        expect(msj.id, equals("id"));
        expect(msj.pseudonimo, equals("Juani123"));
        expect("$msj", equals(msj.toString()));
        expect(msj.toString(), equalsIgnoringWhitespace(codificacion));
      });
    });
    group("Creacion de MensajeInformacion", () {
      String msjEsperado =
          '[[\"id_emisor\",\"id_receptor\",[]],${MensajesAPI.INFORMACION.index},{\"valores\":[1,3]}]';
      test("MensajeComando creado desde el cliente", () {
        var msjNeg = new MensajeInformacion(
            "id_emisor", "id_receptor", "id_informacion", {
          "valores": [1, 3]
        });
        expect(msjNeg.tipo, equals(MensajesAPI.COMANDO));
        expect(msjNeg.id_emisor, equals("id_emisor"));
        expect(msjNeg.id_receptor, equals("id_receptor"));
        expect(
            msjNeg.valores,
            equals({
              "valores": [1, 3]
            }));
        expect(msjNeg.toString(), equals(msjEsperado));
      });

      test("MensajeComando creado desde el servidor", () {
        String codificacion = msjEsperado;
        Mensaje msj = new Mensaje.desdeCodificacion(codificacion);
        if (msj is! MensajeInformacion)
          fail("La decodificacion no generó una clase MensajeComando");
        expect(msj.tipo, equals(MensajesAPI.COMANDO));
        expect(msj.id_receptor, equals("id_receptor"));
        expect(msj.id_emisor, equals("id_emisor"));
        expect(msj.ids_intermediarios, equals([]));
        expect("$msj", equals(msj.toString()));
        expect(msj.toString(), equalsIgnoringWhitespace(codificacion));
      });
    });
  });
}
