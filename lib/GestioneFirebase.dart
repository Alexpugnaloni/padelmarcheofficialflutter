import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:padelmarcheofficialflutter/CentroSportivo.dart';
import 'package:padelmarcheofficialflutter/Prenotazione.dart';
import 'package:padelmarcheofficialflutter/Amministratore.dart';

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
      String idPrenotazione = doc.id;
      prenotazioniList.add(Prenotazione(idPrenotazione, doc['idutente'].toString(), centroSportivo, dataPrenotazione));
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
    DateTime dataOdierna = DateTime.now();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Centrisportivi')
        .doc(centroSportivo)
        .collection('Prenotazioni')
        .where('idutente', isEqualTo: utenteID)
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DateTime dataPrenotazione = (doc['data'] as Timestamp).toDate();
      String idPrenotazione = doc.id;

      // Aggiungi solo le prenotazioni con data futura rispetto alla data odierna
      if (dataPrenotazione.isAfter(dataOdierna) || dataPrenotazione.isAtSameMomentAs(dataOdierna)) {
        prenotazioniList.add(Prenotazione(idPrenotazione, utenteID, centroSportivo, dataPrenotazione));
      }
    }

    return prenotazioniList;
  }

  Future<List<Amministratore>> downloadAmministratori() async {
    List<Amministratore> amministratoriList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Amministratori').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String idAmministratore = doc.id;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String nome = data['nome'] as String;
      String cognome = data['cognome'] as String;
      String email = data['email'] as String;
      String sede = data['idsede'] as String;
      String telefono = data['telefono'] as String;

      Amministratore amministratore = Amministratore(idAmministratore, nome, cognome, email, sede, telefono);
      amministratoriList.add(amministratore);
    }

    return amministratoriList;
  }

  Future<List<PrenotazioneAdmin>> downloadPrenotazioniAmministratore(String userEmail) async {
    List<PrenotazioneAdmin> prenotazioniList = [];

    try {
      QuerySnapshot amministratoriSnapshot = await FirebaseFirestore.instance
          .collection('Amministratori')
          .where('email', isEqualTo: userEmail)
          .get();

      if (amministratoriSnapshot.docs.isNotEmpty) {
        String sedeId = amministratoriSnapshot.docs[0]['idsede'];

        DocumentSnapshot sedeSnapshot = await FirebaseFirestore.instance
            .collection('Centrisportivi')
            .doc(sedeId)
            .get();

        if (sedeSnapshot.exists) {
          CollectionReference prenotazioniRef = sedeSnapshot.reference.collection('Prenotazioni');

          DateTime now = DateTime.now();
          QuerySnapshot prenotazioniSnapshot = await prenotazioniRef
              .where('data', isGreaterThanOrEqualTo: now)
              .get();

          if (prenotazioniSnapshot.docs.isNotEmpty) {
            for (var prenotazione in prenotazioniSnapshot.docs) {
              String userId = prenotazione['idutente'];
              DateTime data = prenotazione['data'].toDate();
              String prenotazioneId = prenotazione.id;
              String centroSportivo = sedeSnapshot['sede']; // Associa il campo sede al campo centroSportivo

              // Ottieni informazioni dall'account dell'utente
              DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                  .collection('Accounts')
                  .doc(userId)
                  .get();

              if (userSnapshot.exists) {
                String nome = userSnapshot['nome'];
                String cognome = userSnapshot['cognome'];
                String cellulare = userSnapshot['cellulare'];

                String nomeUtente = '$nome $cognome';

                prenotazioniList.add(PrenotazioneAdmin(
                  prenotazioneId,
                  userId,
                  nomeUtente,
                  centroSportivo,
                  data,
                  cellulare,
                ));
              }
            }
          } else {
            print('Nessuna prenotazione trovata per la data odierna o futura');
          }
        } else {
          print('Sede non trovata nella raccolta Centrisportivi');
        }
      } else {
        print('Amministratore non trovato');
      }
    } catch (e) {
      print('Errore durante il recupero delle prenotazioni: $e');
    }

    return prenotazioniList;
  }


  Future<List<Superadmin>> downloadSuperadmin() async {
    List<Superadmin> superAdminList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Superadmin').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String idSuperAdmin = doc.id;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String nome = data['nome'] as String;
      String cognome = data['cognome'] as String;
      String email = data['email'] as String;
      String telefono = data['telefono'] as String;

      Superadmin superAdmin = Superadmin(idSuperAdmin, nome, cognome, email, telefono);
      superAdminList.add(superAdmin);
    }

    return superAdminList;
  }

  Future<int> countPrenotazioniPerDataOdierna() async {
    try {
      // Ottieni la data odierna
      DateTime now = DateTime.now();

      // Ottieni tutti i documenti dalla raccolta 'Centrisportivi'
      QuerySnapshot centriSportiviSnapshot =
      await FirebaseFirestore.instance.collection('Centrisportivi').get();

      int prenotazioniPerDataOdierna = 0;

      // Cicla attraverso ciascun documento nella raccolta 'Centrisportivi'
      for (QueryDocumentSnapshot centroSportivo in centriSportiviSnapshot.docs) {
        // Ottieni l'id del centro sportivo corrente
        String centroSportivoId = centroSportivo.id;

        // Ottieni tutti i documenti dalla raccolta 'Prenotazioni' del centro sportivo corrente
        QuerySnapshot prenotazioniSnapshot = await FirebaseFirestore.instance
            .collection('Centrisportivi')
            .doc(centroSportivoId)
            .collection('Prenotazioni')
            .get();

        // Conta il numero di prenotazioni per la data odierna
        prenotazioniSnapshot.docs.forEach((prenotazione) {
          DateTime dataPrenotazione = prenotazione['data'].toDate();
          if (dataPrenotazione.year == now.year &&
              dataPrenotazione.month == now.month &&
              dataPrenotazione.day == now.day) {
            prenotazioniPerDataOdierna++;
          }
        });
      }

      return prenotazioniPerDataOdierna;
    } catch (e) {
      print('Errore durante il conteggio delle prenotazioni: $e');
      return 0; // Ritorna 0 se si verifica un errore
    }
  }

  Future<int> countPrenotazioniUltimaSettimana() async {
    try {
      // Ottieni la data di oggi e la data esattamente una settimana fa
      DateTime today = DateTime.now();
      DateTime lastWeek = today.subtract(const Duration(days: 7));

      // Inizializza la data di fine a quella di oggi a mezzanotte
      DateTime endDateTime = DateTime(today.year, today.month, today.day, 23, 59, 59);

      int prenotazioniUltimaSettimana = 0;

      // Ottieni tutti i documenti dalla raccolta 'Centrisportivi'
      QuerySnapshot centriSportiviSnapshot =
      await FirebaseFirestore.instance.collection('Centrisportivi').get();

      // Cicla attraverso ciascun documento nella raccolta 'Centrisportivi'
      for (QueryDocumentSnapshot centroSportivo in centriSportiviSnapshot.docs) {
        // Ottieni l'id del centro sportivo corrente
        String centroSportivoId = centroSportivo.id;

        // Ottieni tutti i documenti dalla raccolta 'Prenotazioni' del centro sportivo corrente
        QuerySnapshot prenotazioniSnapshot = await FirebaseFirestore.instance
            .collection('Centrisportivi')
            .doc(centroSportivoId)
            .collection('Prenotazioni')
            .where('data', isGreaterThanOrEqualTo: lastWeek, isLessThanOrEqualTo: endDateTime)
            .get();

        // Aggiungi il numero di prenotazioni nell'intervallo specificato
        prenotazioniUltimaSettimana += prenotazioniSnapshot.docs.length;
      }

      return prenotazioniUltimaSettimana;
    } catch (e) {
      print('Errore durante il conteggio delle prenotazioni: $e');
      return 0; // Ritorna 0 se si verifica un errore
    }
  }

  Future<int> countPrenotazioniUltimoMese() async {
    try {
      // Ottieni la data di oggi e la data esattamente un mese fa
      DateTime today = DateTime.now();
      DateTime lastMonth = today.subtract(const Duration(days: 30));

      // Inizializza la data di fine a quella di oggi a mezzanotte
      DateTime endDateTime = DateTime(today.year, today.month, today.day, 23, 59, 59);

      int prenotazioniUltimoMese = 0;

      // Ottieni tutti i documenti dalla raccolta 'Centrisportivi'
      QuerySnapshot centriSportiviSnapshot =
      await FirebaseFirestore.instance.collection('Centrisportivi').get();

      // Cicla attraverso ciascun documento nella raccolta 'Centrisportivi'
      for (QueryDocumentSnapshot centroSportivo in centriSportiviSnapshot.docs) {
        // Ottieni l'id del centro sportivo corrente
        String centroSportivoId = centroSportivo.id;

        // Ottieni tutti i documenti dalla raccolta 'Prenotazioni' del centro sportivo corrente
        QuerySnapshot prenotazioniSnapshot = await FirebaseFirestore.instance
            .collection('Centrisportivi')
            .doc(centroSportivoId)
            .collection('Prenotazioni')
            .where('data', isGreaterThanOrEqualTo: lastMonth, isLessThanOrEqualTo: endDateTime)
            .get();

        // Aggiungi il numero di prenotazioni nell'intervallo specificato
        prenotazioniUltimoMese += prenotazioniSnapshot.docs.length;
      }

      return prenotazioniUltimoMese;
    } catch (e) {
      print('Errore durante il conteggio delle prenotazioni: $e');
      return 0; // Ritorna 0 se si verifica un errore
    }
  }

  Future<int> countAccounts() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Accounts').get();

      int count = querySnapshot.size;
      return count;
    } catch (e) {
      print('Errore durante il conteggio dei documenti: $e');
      return -1; // Valore di errore, puoi gestire questo caso come preferisci
    }
  }



}