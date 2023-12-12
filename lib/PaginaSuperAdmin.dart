import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CentroSportivo.dart';
import 'GestioneFirebase.dart';
import 'dart:core';
import 'Login.dart';
import 'Prenotazione.dart';

class PaginaSuperAdmin extends StatefulWidget {
  static const routeName = '/pagina_superadmin';
  static final gestioneFirebase = GestioneFirebase();

  const PaginaSuperAdmin({Key? key}) : super(key: key);

  @override
  _PaginaSuperAdminState createState() => _PaginaSuperAdminState();
}

class _PaginaSuperAdminState extends State<PaginaSuperAdmin> {
  final _auth = FirebaseAuth.instance;
 // List<PrenotazioneAdmin> prenotazioniAmministratore = [];
  int _currentIndex = 0;
 // int iscritti = 0;
  int statGiornaliere = 0;
  int statSetimanali = 0;
  int statMensili = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchStatistiche();

  }

  Future<void> _fetchStatistiche() async {
  //  iscritti
      statGiornaliere = await PaginaSuperAdmin.gestioneFirebase.countPrenotazioniPerDataOdierna();
      statSetimanali = await PaginaSuperAdmin.gestioneFirebase.countPrenotazioniUltimaSettimana();
      statMensili = await PaginaSuperAdmin.gestioneFirebase.countPrenotazioniUltimoMese();
      setState(() {});
  }
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      // the new route
      MaterialPageRoute(
        builder: (BuildContext context) => const MyLoginPage(),
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
        title: const Text('Pagina SuperAdmin'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _onTabTapped(2, context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              Text(
                'Statistiche',
                style: TextStyle(
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              Image.asset(
                'assets/campostatistiche.png', // Assumi che il file dell'immagine sia presente in 'assets'
                width: 300.0,
                height: 250.0,
              ),
              const SizedBox(height: 30.0),
              Text(
                'Numero di iscritti:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Entrate',
                style: TextStyle(
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Entrate Giornaliere Totali: ${statGiornaliere * 60}€',
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Entrate Settimanali Totali: ${statSetimanali * 60}€',
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Entrate Mensili Totali: ${statMensili * 60}€',
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }