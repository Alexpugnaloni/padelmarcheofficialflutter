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
  ///Funzione booleana che controlla se l'utente è loggato
  bool checkState() {
    if (auth.currentUser == null) {
      return false;
    }
    return true;
  }
  ///Funzione che ritorna l'id dell'utente
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
        .get();
    acc['id'] = id;
    acc['email'] = email;
    acc['cellulare'] = risultato.data()!['cellulare'].toString();
    acc['cognome'] = risultato.data()!['cognome'].toString();
    acc['dataDiNascita'] = risultato.data()!['dataDiNascita'].toString();
    acc['nome'] = risultato.data()!['nome'].toString();
    acc['sesso'] = risultato.data()!['sesso'].toString();

    return acc;
  }
  ///Funzione utile a scaricare le sedi dalla collection centrisportivi con le relative informazioni
  Future<Map<String, CentroSportivo>> downloadSedi() async {
    Map<String, CentroSportivo> centriPadel = {};
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Centrisportivi').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      centriPadel[doc['sede'].toString()] = CentroSportivo(
        id: doc.id,
        nome: doc['sede'].toString(),
        indirizzo: doc['via'].toString(),
        civico: doc['civico'].toString(),
      );
    }

    return centriPadel;
  }
  ///Funzione utile a scaricare i nomi delle sedi
  Future<List<String>> downloadNomiSedi() async {
    List<String> centriPadelList = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Centrisportivi').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      centriPadelList.add(doc['sede'].toString());
    }

    return centriPadelList;
  }
  ///Funzione utile a scaricare le prenotazioni dai centrisportivi passando il centro sportivo di riferimento
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
  ///Funzione utile al caricamento della prenotazione su Firestore
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
  ///funzione che effettua un check con i parametri passati sulla prenotazione
  ///in base al valore di ritorno della funzione si eseguirà o meno la prenotazione
  ///concatenata con uploadprenotazione
  Future<bool> cercaPrenotazioniFirebase(String selectedSede, DateTime selectedDate, String oraDaControllare) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot prenotazioniSnapshot = await firestore
          .collection("Centrisportivi")
          .doc(selectedSede)
          .collection("Prenotazioni")
          .where("data", isGreaterThanOrEqualTo: selectedDate, isLessThan: selectedDate.add(Duration(hours: 1)))
          .get();
      return prenotazioniSnapshot.size > 0;
    } catch (e) {
      print("Errore nella ricerca delle prenotazioni: $e");
      return false;
    }
  }
  ///Funzione che effettua il download delle prenotazioni dell'utente passando il centro sportivo
  ///e l'id dell'utente
  Future<List<Prenotazione>> downloadPrenotazioniUtente(String centroSportivo, String utenteID) async {
    List<Prenotazione> prenotazioniList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Centrisportivi')
        .doc(centroSportivo)
        .collection('Prenotazioni')
        .where('idutente', isEqualTo: utenteID)
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DateTime dataPrenotazione = (doc['data'] as Timestamp).toDate();
      prenotazioniList.add(Prenotazione(utenteID, centroSportivo, dataPrenotazione));
    }

    return prenotazioniList;
  }


}