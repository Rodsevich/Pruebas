import 'dart:convert';

enum MensajesAPI {
  INDEFINIDO,
  SUSCRIPCION,
  NEGOCIACION_WEBRTC,
  COMANDO,
  INTERACCION
}

enum DestinatariosMensaje { SERVIDOR, TODOS, }

class Mensaje {
  MensajesAPI tipo;

  Mensaje() {
    tipo = MensajesAPI.INDEFINIDO;
  }

  /// Decodifica un mensaje recibido desde un Cliente en su clase correspondiente
  factory Mensaje.desdeCodificacion(String json) {
    List msjDecodificado = JSON.decode(json);
    switch (MensajesAPI.values[msjDecodificado[0]]) {
      case MensajesAPI.COMANDO:
        return new MensajeComando.desdeDecodificacion(msjDecodificado);
      case MensajesAPI.NEGOCIACION_WEBRTC:
        return new MensajeNegociacionWebRTC.desdeDecodificacion(
            msjDecodificado);
      case MensajesAPI.SUSCRIPCION:
        return new MensajeSuscripcion.desdeDecodificacion(msjDecodificado);
      case MensajesAPI.INTERACCION:
        return new MensajeNegociacionWebRTC.desdeDecodificacion(
            msjDecodificado);
      default:
        throw new Exception(
            "Tipo de mensaje no reconocido... (No se qué hacer)");
    }
  }

  int codificacionMensajeAPI(MensajesAPI msj) {
    List<MensajesAPI> vals = MensajesAPI.values;
    for (var i in vals) if (msj == vals[i]) return i;
    return MensajesAPI.INDEFINIDO.index;
  }

  MensajesAPI decodificacionMensajeAPI(int index) => MensajesAPI.values[index];
}

/// Mensaje enviado por el cliente para que el Servidor tenga su información
/// WebAPP --> Cliente --> X-termino ahi-X
class MensajeSuscripcion extends Mensaje {
  String id, pseudonimo;

  MensajeSuscripcion(this.pseudonimo, [this.id]) {
    this.tipo = MensajesAPI.SUSCRIPCION;
  }
  MensajeSuscripcion.desdeDecodificacion(List msjDecodificado) {
    this.tipo = decodificacionMensajeAPI(msjDecodificado[0]);
    this.id = msjDecodificado[1];
    this.pseudonimo = msjDecodificado[2];
  }

  String toString() =>
      JSON.encode([MensajesAPI.SUSCRIPCION.index, id, pseudonimo]);
}

/// Mensaje que porta la negociacion SDP para establecer conexiones WebRTC
/// WebAPP --> Cliente --> Servidor
/// Servidor --> Cliente --> WebApp
class MensajeNegociacionWebRTC extends Mensaje {
  String destinatario;
  String contenido;

  MensajeNegociacionWebRTC(this.destinatario, this.contenido) {
    this.tipo = MensajesAPI.NEGOCIACION_WEBRTC;
  }
  MensajeNegociacionWebRTC.desdeDecodificacion(List msjDecodificado) {
    this.tipo = decodificacionMensajeAPI(msjDecodificado[0]);
    this.destinatario = msjDecodificado[1];
    this.contenido = msjDecodificado[2];
  }

  String toString() => JSON
      .encode([MensajesAPI.NEGOCIACION_WEBRTC.index, destinatario, contenido]);
}

/// Comando para que se ejecute funcionalidad remotamente
/// WebAPP --> Cliente --> Servidor
/// Servidor --> Cliente { --> WebAPP } --> WebApp
class MensajeComando extends Mensaje {
  String comando;
  List<String> argumentos;

  MensajeComando(this.comando, this.argumentos) {
    this.tipo = MensajesAPI.COMANDO;
  }
  MensajeComando.desdeDecodificacion(List msjDecodificado) {
    this.tipo = decodificacionMensajeAPI(msjDecodificado[0]);
    this.comando = msjDecodificado[1];
    this.argumentos = msjDecodificado[2];
  }

  String toString() =>
      JSON.encode([MensajesAPI.COMANDO.index, comando, argumentos]);
}

/// Resultado de alguna interacción por parte del usuario: _votacion_, _encuesta_, _etc..._
/// WebAPP \[ --> WebAPP \] --> Cliente --> Servidor
class MensajeInteraccion extends Mensaje {
  String id_interaccion;
  Map valores;

  MensajeInteraccion(this.id_interaccion, this.valores) {
    this.tipo = MensajesAPI.INTERACCION;
  }
  MensajeInteraccion.desdeDecodificacion(List msjDecodificado) {
    this.tipo = decodificacionMensajeAPI(msjDecodificado[0]);
    this.id_interaccion = msjDecodificado[1];
    this.valores = msjDecodificado[2];
  }

  String toString() =>
      JSON.encode([MensajesAPI.INTERACCION.index, id_interaccion, valores]);
}
