import 'dart:io';
import 'dart:async';
import 'package:pruebas_dart/src/Mensaje.dart';

class Cliente {
  String id, pseudonimo;
  WebSocket canal;
  StreamController _notificadorMensajes;
  Stream<Mensaje> onMensaje;

  Cliente(this.canal) {
    _notificadorMensajes = new StreamController();
    onMensaje = _notificadorMensajes.stream;
    canal.listen(_manejarMensajes);
  }

  void _manejarMensajes(String input) {
    Mensaje msj = Mensaje.desdeCodificacion(input);
    switch (msj) {
      default:
        this._notificadorMensajes.add(msj);
    }
  }
}