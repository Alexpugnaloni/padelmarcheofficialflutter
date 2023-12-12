import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'GestioneFirebase.dart';
import 'dart:core';
import 'Login.dart';
import 'Prenotazione.dart';

class PaginaAmministratore extends StatefulWidget {
  static const routeName = '/pagina_amministratore';
  static final gestioneFirebase = GestioneFirebase();

  const PaginaAmministratore({Key? key}) : super(key: key);

  @override
  _PaginaAmministratoreState createState() => _PaginaAmministratoreState();
}

class _PaginaAmministratoreState extends State<PaginaAmministratore> {
  final _auth = FirebaseAuth.instance;
  List<PrenotazioneAdmin> prenotazioniAmministratore = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPrenotazioni();
  }
  ///funzione che va a prelevare ed ordinaree per data le prenotazioni effettuate dall'utente
  ///per la specifica sede, considerando inoltre la userEmail dell'utente amministratore loggato
  Future<void> _fetchPrenotazioni() async {
    final userEmail = _auth.currentUser!.email.toString();
    prenotazioniAmministratore = await PaginaAmministratore.gestioneFirebase.downloadPrenotazioniAmministratore(userEmail);
    prenotazioniAmministratore.sort((a, b) => a.data.compareTo(b.data));
    setState(() {});
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      // the new route
      MaterialPageRoute(
        builder: (BuildContext context) => const PaginaLogin(),
      ),
      ModalRoute.withName('/home'),
    );
  }
  void _onTabTapped(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
      if(_currentIndex == 0){
       // _lauchUserProfile();
      }else if(_currentIndex == 1){
     //   _lauchPrenotazioni();
      }
      else if(_currentIndex == 2){
        logout();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prenotazioni Amministratore'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _onTabTapped(2, context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            Text(
              'Ecco le prenotazioni degli utenti:',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: prenotazioniAmministratore.length,
                itemBuilder: (context, index) {
                  final prenotazione = prenotazioniAmministratore[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nome e Cognome: ${prenotazione.nomeUtente}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Data: ${prenotazione.data.day}/${prenotazione.data.month}/${prenotazione.data.year}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Dalle ore: ${prenotazione.data.hour}:${prenotazione.data.minute}0',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Cellulare: ${prenotazione.cellulare}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
