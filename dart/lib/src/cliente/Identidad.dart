class Identidad {
  String id_feis;
  String id_goog;
  String email;

  String get toString {
    return (id_goog != null)
        ? "G$id_goog"
        : (id_feis != null) ? "F$id_feis" : "Eemail";
  }
}
