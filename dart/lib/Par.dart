import "dart:html";
import "package:pruebas_dart/Mensaje.dart";
import "package:pruebas_dart/Comando.dart";

Map _configuracion = {
  "iceServers": const [
    const {'url': 'stun:stun.l.google.com:19302'},
    const {'url': 'stun:stun1.l.google.com:19302'},
    const {'url': 'stun:stun2.l.google.com:19302'},
    const {'url': 'stun:stun3.l.google.com:19302'},
    const {'url': 'stun:stun4.l.google.com:19302'}
  ]
};

class Par {
  RtcPeerConnection conexion;
  RtcDataChannel canal;

  Par() {
    this.conexion = new RtcPeerConnection(_configuracion);
  }

  enviarMensaje(Mensaje msj);

  procesarMensaje();
}
