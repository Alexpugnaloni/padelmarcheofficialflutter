import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:padelmarcheofficialflutter/CentroSportivo.dart';
import 'package:padelmarcheofficialflutter/Prenotazione.dart';

class GestioneFirebase {
  /// Riferimento per *Firestore*
  final firestore = FirebaseFirestore.instance;

  /// Riferimento per *FirebaseAuth*
  final auth = FirebaseAuth.instance;

  /// Lo *storage* di *Firebase*
  final storage = FirebaseStorage.instance;

  void initGestioneFirebase() async {
    await Firebase.initializeApp();
  }

  bool checkState() {
    if (auth.currentUser == null) {
      return false;
    }
    return true;
  }

  String getUserId() {
    return auth.currentUser!.uid;
  }


  /// Funzione per recuperare le informazioni di un account
  leggiInfo() async {
    var id = auth.currentUser!.uid;
    var email = auth.currentUser!.email;
    var acc = HashMap();
    var risultato = await firestore.collection('Accounts')
        .doc(id)
        .get(); //.then((risultato) async {
    acc['id'] = id;
    acc['email'] = email;
    acc['cellulare'] = risultato.data()!['cellulare'].toString();
    acc['cognome'] = risultato.data()!['cognome'].toString();
    acc['dataDiNascita'] = risultato.data()!['dataDiNascita'].toString();
    acc['nome'] = risultato.data()!['nome'].toString();
    acc['sesso'] = risultato.data()!['sesso'].toString();

    return acc;
  }

  Future<Map<String, CentroSportivo>> downloadSedi() async {
    Map<String, CentroSportivo> centriPadel = {};
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Centrisportivi').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      centriPadel[doc['sede'].toString()] = CentroSportivo(
        id: doc.id,
        nome: doc['sede'].toString(),
        indirizzo: doc['indirizzo'].toString(),
        civico: doc['civico'].toString(),
      );
    }

    return centriPadel;
  }

  Future<List<String>> downloadNomiSedi() async {
    List<String> centriPadelList = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Centrisportivi').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      centriPadelList.add(doc['sede'].toString());
    }

    return centriPadelList;
  }

  Future<List<Prenotazione>> downloadPrenotazioni(String centroSportivo, String data) async {
    List<Prenotazione> prenotazioniList = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Centrisportivi')
        .doc(centroSportivo)
        .collection('Prenotazioni')
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DateTime dataPrenotazione = (doc['data'] as Timestamp).toDate();
      prenotazioniList.add(Prenotazione(doc['idutente'].toString(), centroSportivo, dataPrenotazione));
    }

    return prenotazioniList;
  }

  Future<void> uploadPrenotazione(String idCentroSportivo, DateTime data) async {
    Map<String, dynamic> prenotazione = {
      'idutente': FirebaseAuth.instance.currentUser!.uid,
      'data': data,
      'confermato': true,
      'utenti': <String, dynamic>{},
    };

    await FirebaseFirestore.instance
        .collection('Centrisportivi')
        .doc(idCentroSportivo)
        .collection('Prenotazioni')
        .add(prenotazione);
  }


}