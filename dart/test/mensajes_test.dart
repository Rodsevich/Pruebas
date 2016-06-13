import "package:test/test.dart";
import 'package:pruebas_dart/Mensaje.dart';
import 'dart:convert';

void main() {
  group("Creacion de Mensajes", () {
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

      test("MensajeNegociacionWebRTC creado desde el servidor", () {
        String codificacion =
            "[${MensajesAPI.NEGOCIACION_WEBRTC.index},\"pepe\",\"hola, sorp\"]";
        Mensaje msj = new Mensaje.desdeCodificacion(codificacion);
        if (msj is! MensajeNegociacionWebRTC)
          fail(
              "La decodificacion no generó una clase MensajeNegociacionWebRTC");
        expect(msj.tipo, equals(MensajesAPI.NEGOCIACION_WEBRTC));
        expect(msj.destinatario, equals("pepe"));
        expect(msj.contenido, equals("hola, sorp"));
        expect("$msj", equals(msj.toString()));
        expect(msj.toString(), equalsIgnoringWhitespace(codificacion));
      });
    });
    group("Creacion de MensajeSuscripcion", () {
      String msjEsperado = '[${MensajesAPI.SUSCRIPCION.index},"id","Juani123"]';
      test("MensajeSuscripcion creado desde el cliente", () {
        var msjNeg = new MensajeSuscripcion("id", "Juani123");
        expect(msjNeg.tipo, equals(MensajesAPI.SUSCRIPCION));
        expect(msjNeg.id, equals("id"));
        expect(msjNeg.pseudonimo, equals("Juani123"));
        expect(msjNeg.toString(), equals(msjEsperado));
      });

      test("MensajeSuscripcion creado desde el servidor", () {
        String codificacion = msjEsperado;
        Mensaje msj = new Mensaje.desdeCodificacion(codificacion);
        if (msj is! MensajeSuscripcion)
          fail("La decodificacion no generó una clase MensajeSuscripcion");
        expect(msj.tipo, equals(MensajesAPI.SUSCRIPCION));
        expect(msj.id, equals("id"));
        expect(msj.pseudonimo, equals("Juani123"));
        expect("$msj", equals(msj.toString()));
        expect(msj.toString(), equalsIgnoringWhitespace(codificacion));
      });
    });
    group("Creacion de MensajeComando", () {
      String msjEsperado = '[${MensajesAPI.COMANDO.index},"id","Juani123"]';
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
  });
}
