import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:firebase_core/firebase_core.dart';
import 'package:padelmarcheofficialflutter/Login.dart';
import 'package:padelmarcheofficialflutter/GestioneFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:padelmarcheofficialflutter/PaginaProfilo.dart';
import 'package:padelmarcheofficialflutter/PrenotaUnaPartita.dart';
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
  Widget defaultHome = const MyLoginPage();

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
      MyLoginPage.routeName: (BuildContext context) => const MyLoginPage(),
      ViewProfile.routeName: (context) => const ViewProfile(),
      PrenotaUnaPartita.routeName: (context) => const PrenotaUnaPartita(),
      Prenotazioni.routeName: (context) => const Prenotazioni()
    },
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}


class _HomePage extends State<HomePage> {
  final GestioneFirebase gestioneFirebase = GestioneFirebase();
  bool showProgress = false;
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
      ViewProfile.routeName,
      arguments: MyProfile(account),
    );
  }
  ///funzione che viene richiamata quando devo prenotare una partita
  void _lauchPrenotaUnaPartita(){
    Navigator.pushNamed(context,
      PrenotaUnaPartita.routeName);
  }

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
        builder: (BuildContext context) => const MyLoginPage(),
      ),
      ModalRoute.withName('/home'),
    );
  }
  ///funzione utile a scorrere tra i vari bottoni della bottombar con le relative funzioni
  void _onTabTapped(int index) {
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {

            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Ink.image(
              image: const AssetImage('assets/uniscitir2.png'),
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
      onTap: _onTabTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profilo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Prenotazioni',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'Logout',
        ),
      ],
    ),
  );
  }
}
