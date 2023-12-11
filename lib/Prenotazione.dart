class Prenotazione {
  final String id;
  final String idUtente;
  final String centroSportivo;
  final DateTime data;

  Prenotazione(this.id, this.idUtente, this.centroSportivo, this.data);
}

class PrenotazioneAdmin {
  final String id;
  final String idUtente;
  final String nomeUtente;
  final String centroSportivo;
  final DateTime data;
  final String cellulare;

  PrenotazioneAdmin(this.id, this.idUtente, this.nomeUtente, this.centroSportivo, this.data, this.cellulare);
}

