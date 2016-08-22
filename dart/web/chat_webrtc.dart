import 'dart:html';
import 'dart:convert';

WebSocket ws;
int id;
List<int> pares;
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
  conexion = new RtcPeerConnection(config, connection);
  conexion.onIceCandidate.listen(responderIceCandidate);
  dataChannel = conexion.createDataChannel("dataChannel", {"reliable": false});
  dataChannel.onOpen.listen((_) => outputMessage("DataChannel abierto"));
  dataChannel.onError.listen((_) => outputMessage("Error en DataChannel"));
  dataChannel.onClose.listen((_) => outputMessage("DataChannel cerrado"));
  dataChannel.onMessage.listen(manejarMessageEvent);

  botonConectar = querySelector("#conectar");
  botonDesconectar = querySelector("#desconectar");
  selectorPares = querySelector("#pares");
  botonConectar.onClick.listen(conectarAlPar);
}

void conectarAlPar(_) {
  int idParAConectar = pares[selectorPares.selectedIndex];
  conexion.createOffer({
    'mandatory': {'OfferToReceiveAudio': false, 'OfferToReceiveVideo': false}
  }).then((RtcSessionDescription sessionDescription) {
    conexion.setLocalDescription(sessionDescription);
    ws.send("offer,$idParAConectar,${JSON.encode(sessionDescription)}");
  });
}

void responderIceCandidate(RtcIceCandidateEvent evt) {
  RtcIceCandidate candidate = evt.candidate;
  ws.send("candidate,${JSON.encode(candidate)}");
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
    outputMessage("$e.data (e.origin, e.type)");
    List<String> msj = e.data.toString().split(',');
    switch (msj[0]) {
      case "reg":
        id = JSON.decode(msj[1]);
        outputMessage("Registrado con id ${msj[1]}");
        botonDesconectar.disabled = false;
        botonConectar.disabled = true;
        break;
      case "pares":
        pares = JSON.decode(msj[1]);
        pares.remove(id);
        selectorPares.children = null;
        selectorPares.disabled = false;
        for (int par in pares)
          selectorPares.append(new OptionElement(data: par.toString()));
        break;
      case "candidate":
        RtcIceCandidate candidato = new RtcIceCandidate(JSON.decode(msj[1]));
        conexion.addIceCandidate(
            candidato,
            () => outputMessage("candidato agregado"),
            (_) => outputMessage("error en el agregado de candidato"));
    }
  });

  ws.onClose.listen((Event e) {
    outputMessage('Connection to server lost...');
  });
}

void outputMessage(String message, [String clase = "info"]) {
  Element e = new ParagraphElement();
  e.classes = clase;
  TextAreaElement pantalla = querySelector('#pantalla-chat');
  print(message);
  e.text = message;
  // e.appendHtml('<br/>');
  pantalla.append(e);

  //Make sure we 'autoscroll' the new messages
  pantalla.scrollTop = pantalla.scrollHeight;
}
