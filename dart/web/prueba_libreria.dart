import 'dart:html';
import "package:WebRTCnetmesh/WebRTCnetmesh_client.dart";

TextInputElement campoNombre;
ButtonElement botonConectarServidor;
SelectElement selectorPares;
ButtonElement botonConectarPar;
ButtonElement botonDesconectarPar;

void main() {
  //Logica del chat
  querySelector('#enviar').onClick.listen((_) => enviarTexto());
  querySelector('#texto')
      .onKeyPress
      .listen((KeyboardEvent k) => k.keyCode == 13 ? enviarTexto() : null);

  //Logica de conexion al servidor
  campoNombre = querySelector("#conexion-servidor__nombre");
  botonConectarServidor = querySelector("#conexion-servidor__boton-conectar");
  botonConectarServidor.onClick.listen(conectarAlServidor);

  selectorPares = querySelector("#conexion-par__pares");
  botonConectarPar = querySelector("#conexion-par__boton-conectar");
  botonDesconectarPar = querySelector("#conexion-par__boton-desconectar");
  botonConectarPar.onClick.listen(conectarAlPar);
  botonConectarPar.onClick.listen(desconectarDelPar);
}

enviarTexto() {
  TextInputElement input = querySelector('#texto');
  String texto = input.value.trim();
  dataChannel.send(texto);
  input.value = "";
}

conectarAlServidor(MouseEvent event) {}

void outputMessage(String message, [String clase = "info"]) {
  Element e = new ParagraphElement();
  e.classes.add(clase);
  TextAreaElement pantalla = querySelector('#pantalla-chat');
  print(message);
  e.text = message;
  // e.appendHtml('<br/>');
  pantalla.append(e);

  //Make sure we 'autoscroll' the new messages
  pantalla.scrollTop = pantalla.scrollHeight;
}

void conectarAlPar(MouseEvent event) {}

void desconectarDelPar(MouseEvent event) {}
