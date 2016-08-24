import 'dart:html';
import 'dart:convert';

WebSocket ws;
int id;
List<int> pares = [];
RtcPeerConnection conexion;
var config = {
  "iceServers": [
    {"url": "stun:stun.l.google.com:19302"}
  ]
};
var connection = {
  'optional': [
    {'DtlsSrtpKeyAgreement': true},
    {'RtpDataChannels': true}
  ]
};
RtcDataChannel dataChannel;
var sdpConstraints = {
  'mandatory': {'OfferToReceiveAudio': false, 'OfferToReceiveVideo': false}
};
ButtonElement botonConectar;
ButtonElement botonDesconectar;
SelectElement selectorPares;

void main() {
  conectarAlServidor();
  conexion = new RtcPeerConnection(null, connection);
  conexion.onIceCandidate.listen(enviarIceCandidate);
  dataChannel = conexion.createDataChannel("dataChannel", {"reliable": false});
  dataChannel.onOpen.listen((_) => outputMessage("DataChannel abierto"));
  dataChannel.onError.listen((_) => outputMessage("Error en DataChannel"));
  dataChannel.onClose.listen((_) => outputMessage("DataChannel cerrado"));
  dataChannel.onMessage.listen(manejarMessageEvent);

  querySelector('#enviar').onClick.listen((_) => enviarTexto());
  querySelector('#texto')
      .onKeyPress
      .listen((KeyboardEvent k) => k.keyCode == 13 ? enviarTexto() : null);
  botonConectar = querySelector("#conectar");
  botonDesconectar = querySelector("#desconectar");
  selectorPares = querySelector("#pares");
  botonConectar.onClick.listen(conectarAlPar);
}

enviarTexto() {
  TextInputElement input = querySelector('#texto');
  String texto = input.value.trim();
  dataChannel.send(texto);
  input.value = "";
}

void conectarAlPar(_) {
  OptionElement optElem = selectorPares.children[selectorPares.selectedIndex];
  int idParAConectar = int.parse(optElem.value);
  conexion.createOffer({
    'mandatory': {'OfferToReceiveAudio': false, 'OfferToReceiveVideo': false}
  }).then((RtcSessionDescription sessionDescription) {
    conexion.setLocalDescription(sessionDescription);
    ws.send(JSON.encode(["offer", idParAConectar, sessionDescription.sdp]));
  });
}

void enviarIceCandidate(RtcIceCandidateEvent evt) {
  if (evt.candidate == null) return;
  RtcIceCandidate candidate = evt.candidate;
  OptionElement optElem = selectorPares.children[selectorPares.selectedIndex];
  int idParAConectar = int.parse(optElem.value);
  // String candidate_Str = JSON.encode(evt.candidate);
  String datos_a_enviar = JSON.encode([
    "candidate",
    idParAConectar,
    candidate.candidate,
    candidate.sdpMid,
    candidate.sdpMLineIndex
  ]);
  ws.send(datos_a_enviar);
}

void manejarMessageEvent(MessageEvent evt) {
  outputMessage(evt.data, "msj");
}

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
    outputMessage("${e.data} (${e.origin}, ${e.type})");
    List<dynamic> msj = JSON.decode(e.data);
    switch (msj[0]) {
      case "reg":
        id = msj[1];
        outputMessage("Registrado con id ${msj[1]}");
        break;
      case "pares":
        pares = msj[1];
        pares.remove(id);
        // outputMessage("Pares recibidos: $pares");
        selectorPares.children = [];
        selectorPares.disabled = false;
        for (int par in pares)
          selectorPares.append(
              new OptionElement(data: par.toString(), value: par.toString()));
        break;
      case "candidate":
        //[X] 1_Probar removiendo el onIcecandidate.listen() a ver si anda
        //[X] 2_ buscar como era la remocion de iceservers para intranet
        //3_Desmenusar el IceCandidate y recrearlo aca
        RtcIceCandidate candidato = new RtcIceCandidate(
            {"candidate": msj[1], "sdpMid": msj[2], "sdpMLineIndex": msj[3]});
        conexion.addIceCandidate(
            candidato,
            () => outputMessage("candidato agregado"),
            (_) => outputMessage("error en el agregado de candidato"));
        break;
      case "offer":
        String enviante = msj[1];
        RtcSessionDescription desc_offer = new RtcSessionDescription();
        desc_offer.sdp = msj[2];
        desc_offer.type = "offer";
        conexion.setRemoteDescription(desc_offer);
        conexion.createAnswer().then((RtcSessionDescription desc_answer) {
          conexion.setLocalDescription(desc_answer);
          ws.send(JSON.encode(["answer", enviante, desc_answer.sdp]));
        });
        break;
      case "answer":
        RtcSessionDescription desc = new RtcSessionDescription();
        desc.type = "answer";
        desc.sdp = msj[1];
        conexion.setRemoteDescription(desc);
        break;
    }
  });

  ws.onClose.listen((Event e) {
    outputMessage('Connection to server lost...');
  });
}

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
