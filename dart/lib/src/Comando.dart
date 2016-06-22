enum ComandosAPI { INDEFINIDO, CAMBIAR_SLIDE, MOSTRAR_ALERT }

class Comando {
  ComandosAPI tipo;

  Comando() {
    tipo = ComandosAPI.INDEFINIDO;
  }

  factory Comando.desdeTipo(ComandosAPI tipo) {
    switch (tipo) {
      case ComandosAPI.CAMBIAR_SLIDE:
        return new CambiarSlide();
        break;
      case ComandosAPI.MOSTRAR_ALERT:
        return new MostrarAlert();
        break;
      default:
    }
  }

  int codificacionComandoAPI(ComandosAPI msj) {
    List<ComandosAPI> vals = ComandosAPI.values;
    for (var i in vals) if (msj == vals[i]) return i;
    return ComandosAPI.INDEFINIDO.index;
  }

  ComandosAPI decodificacionComandoAPI(int index) => ComandosAPI.values[index];
}

class CambiarSlide extends Comando {
  CambiarSlide() {}
}

class MostrarAlert extends Comando {
  MostrarAlert() {}
}
