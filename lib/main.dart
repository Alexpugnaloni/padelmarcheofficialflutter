import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:firebase_core/firebase_core.dart';
import 'package:padelmarcheofficialflutter/Login.dart';
import 'package:padelmarcheofficialflutter/GestioneFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:padelmarcheofficialflutter/PaginaAmministratore.dart';
import 'package:padelmarcheofficialflutter/PaginaProfilo.dart';
import 'package:padelmarcheofficialflutter/PrenotaUnaPartita.dart';
import 'package:padelmarcheofficialflutter/PaginaSuperAdmin.dart';
import 'Prenotazioni.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GestioneFirebase gestioneFirebase = GestioneFirebase();
  WidgetsFlutterBinding.ensureInitialized();

  // Set default home.
  Widget defaultHome = const PaginaLogin();

  /// se non c'è un account in memoria si va alla pagina di login
  if (gestioneFirebase.checkState()) {
    defaultHome = const HomePage();
  }
  runApp(MaterialApp(
    title: 'PadelMarche',
    home: defaultHome,

    /// si definiscono le rotta utili alla navigazione
    routes: <String, WidgetBuilder>{

      '/home': (BuildContext context) => const HomePage(),
      PaginaLogin.routeName: (BuildContext context) => const PaginaLogin(),
      VistaProfilo.routeName: (context) => const VistaProfilo(),
      PrenotaUnaPartita.routeName: (context) => const PrenotaUnaPartita(),
      Prenotazioni.routeName: (context) => const Prenotazioni(),
      PaginaAmministratore.routeName: (context) => const PaginaAmministratore(),
      PaginaSuperAdmin.routeName: (context) => const PaginaSuperAdmin()
    },
  ));
}


///Classe principale che gestisce le rotte di navigazione della nostra app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}


class _HomePage extends State<HomePage> {
  final GestioneFirebase gestioneFirebase = GestioneFirebase();
  late String email, password;
  int _currentIndex = 0;
  late HashMap account = HashMap();

  @override
  void initState() {
    super.initState();
    init();
  }

  ///inizializzazione
  ///si recuperano le informazioni dell'account loggato
  void init() async {
    await gestioneFirebase.leggiInfo().then((acc) {
      setState(() {
        account = acc;
      });
    });
  }

  ///funzione che viene richiamata quando devo visualizzare il profilo alla quale si passa l'hashMap identificativa dell'account
  void _lauchUserProfile() {
    Navigator.pushNamed(
      context,
      VistaProfilo.routeName,
      arguments: Profilo(account),
    );
  }
  ///funzione che viene richiamata quando devo prenotare una partita
  void _lauchPrenotaUnaPartita(){
    Navigator.pushNamed(context,
      PrenotaUnaPartita.routeName);
  }
  ///funzione che viene richiamata quando voglio navigare verso le mie prenotazioni
  void _lauchPrenotazioni(){
    Navigator.pushNamed(context,
        Prenotazioni.routeName);
  }

  ///funzione utile alla cancellazione delle informazioni salvate in locale riguardo l'account
  ///ed utile per tornare alla pagina di login
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
  ///funzione utile a scorrere tra i vari bottoni della bottombar con le relative funzioni
  void _onTabTapped(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
      if(_currentIndex == 0){
        _lauchUserProfile();
      }else if(_currentIndex == 1){
        _lauchPrenotazioni();
      }
      else if(_currentIndex == 2){
        logout();
      }
    });
}


  @override
  Widget build(BuildContext context) {return Scaffold(
    appBar: AppBar(
      leading: null,
      title: const Text('PadelMarche',
          style: TextStyle(color: Colors.white,
      )),

      backgroundColor: Colors.blue,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _lauchPrenotaUnaPartita();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Ink.image(
              image: const AssetImage('assets/prenotaunapartitabutton.png'),
              width: 320,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),

    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _onTabTapped(index, context);
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profilo',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Prenotazioni',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'Logout',
        ),
      ],
    ),

  );
  }
}
