import "dart:html";
import "package:pruebas_dart/libs_cliente.dart";

Map _configuracion = {
  "iceServers": const [
    const {'url': 'stun:stun.l.google.com:19302'},
    const {'url': 'stun:stun1.l.google.com:19302'},
    const {'url': 'stun:stun2.l.google.com:19302'},
    const {'url': 'stun:stun3.l.google.com:19302'},
    const {'url': 'stun:stun4.l.google.com:19302'}
  ]
};

Map _restriccionDeMedios = {
  "optional": [
    {"RtpDataChannels": true},
    {"DtlsSrtpKeyAgreement": true}
  ]
};

/// Objeto que el cliente tendrá por cada conexión con otro [Par], que lo proveerá
/// de funcionalidad de alto nivel para facilitar la comunicación
class Par {
  RtcPeerConnection conexion;
  RtcDataChannel canal;

  Par() {
    this.conexion = new RtcPeerConnection(_configuracion, _restriccionDeMedios);
  }

  enviarMensaje(Mensaje msj);

  procesarMensaje();
}
