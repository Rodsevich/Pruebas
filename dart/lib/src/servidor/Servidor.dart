import 'dart:io';
import 'dart:async';

import 'Cliente.dart';
import 'package:pruebas_dart/Mensaje.dart';

class Servidor {
  List<Cliente> clientes = [];
  HttpServer _server;
  StreamController _notificadorPedidosHTML;
  StreamController _notificadorPedidosWebSocket;
  Stream<PedidoHTML> onPedidoHTML;
  Stream<PedidoWebSocket> onPedidoWebSocket;

  Servidor([int puerto = 4040]) {
    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, puerto).then((HttpServer srv) {
      _server = srv;
      _server.serverHeader = "Servidor hecho con Dart por Nico";
      _notificadorPedidosHTML = new StreamController();
      _notificadorPedidosWebSocket = new StreamController();
      onPedidoHTML = _notificadorPedidosHTML.stream;
      onPedidoWebSocket = _notificadorPedidosWebSocket.stream;
      _manejarPedidos();
    });
  }

  _manejarPedidos() async {
    await for (HttpRequest pedido in _server) {
      if (WebSocketTransformer.isUpgradeRequest(pedido)) {
        WebSocketTransformer.upgrade(pedido).then(_nuevaConexionWebSocket);
      } else {
        _devolverPedidoInvalido(pedido);
      }
    }
  }

  _nuevaConexionWebSocket(WebSocket ws) {
    Cliente cliente = new Cliente(ws);
    cliente.onMensaje.listen(_manejarPedidoDeCliente);
  }

  _devolverPedidoInvalido(HttpRequest pedido) {
    HttpResponse respuesta = pedido.response;
    respuesta.statusCode = HttpStatus.FORBIDDEN;
    respuesta.reasonPhrase = "conectate solo con WebSockets por favor";
    respuesta.close();
  }

  _manejarPedidoDeCliente(Mensaje msj) {
    switch (msj) {
    }
  }
}

class PedidoHTML {}

class PedidoWebSocket {}
