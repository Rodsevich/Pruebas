// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

// void mostrarMediosLocales({bool video: vid, bool audio: aud}) {
//   window.navigator.getUserMedia(audio: aud, video: vid).then((stream) {
//     Url url = Url.createObjectUrlFromStream(stream);
//     querySelector("#video-output > #vid").src = url;
//     querySelector("#video-output > #url-link").href = url..text = url;
//   }).onError((e) {
//     window.alert("Error de tipo: $e");
//     querySelector('#output').text = "$e";
//   });
// }

WebSocket ws;
RtcPeerConnection pc;

conectar() {
  //Probar webrtc sin ICEFramework
  Map config = {
    "iceServers": const [
      const {'url': 'stun:stun.l.google.com:19302'},
      const {'url': 'stun:stun1.l.google.com:19302'},
      const {'url': 'stun:stun2.l.google.com:19302'},
      const {'url': 'stun:stun3.l.google.com:19302'},
      const {'url': 'stun:stun4.l.google.com:19302'}
    ]
  };
  pc = new RtcPeerConnection(config);
}

enviarTexto() {
  TextInputElement input = querySelector('#texto');
  String texto = input.value.trim();
  ws.send(texto);
  input.value = "";
}

void main() {
  querySelector('#output').text = "Solo video";
  querySelector('#conectar').onClick.listen((_) => conectarAlServidor());
  querySelector('#enviar').onClick.listen((_) => enviarTexto());
  querySelector('#texto')
      .onKeyPress
      .listen((KeyboardEvent k) => k.keyCode == 13 ? enviarTexto() : null);
}

//Param server es opcional, si no se lo define tiene ese valor por defecto
conectarAlServidor([String server = 'ws://localhost:4040/']) {
  //No se ejecuta nunca, pero lo dejo para aprender:
  //Si server es null le asigna ese valor
  server ??= 'ws://localhost:4040/';
  if (ws != null) ws.close();
  ws = new WebSocket(server);
  ws.onOpen.listen((Event e) {
    outputMessage('Connected to server');
  });

  ws.onMessage.listen((MessageEvent e) {
    outputMessage(e.data);
  });

  ws.onClose.listen((Event e) {
    outputMessage('Connection to server lost...');
  });
}

void outputMessage(String message) {
  Element e = new ParagraphElement();
  TextAreaElement pantalla = querySelector('#pantalla-chat');
  print(message);
  e.text = message;
  // e.appendHtml('<br/>');
  pantalla.append(e);

  //Make sure we 'autoscroll' the new messages
  pantalla.scrollTop = pantalla.scrollHeight;
}
