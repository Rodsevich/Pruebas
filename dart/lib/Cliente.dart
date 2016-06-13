import 'dart:io';
import 'dart:async';
import 'package:pruebas_dart/Mensaje.dart';

class Cliente {
  String id, pseudonimo;
  WebSocket canal;
  StreamController _notificadorMensajes;
  Stream<Mensaje> onMensaje;

  Cliente(this.canal) {
    _notificadorMensajes = new StreamController();
    onMensaje = _notificadorMensajes.stream;
    canal.listen(_transformarAMensajes);
  }

  void _transformarAMensajes(List<int> input) {
    Mensaje msj = Mensaje.desdeBinario(input);
    switch (msj) {
      default:
        this._notificadorMensajes.add(msj);
    }
  }
}
