import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:firebase_core/firebase_core.dart';
import 'package:padelmarcheofficialflutter/Login.dart';
import 'package:padelmarcheofficialflutter/GestioneFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:intl/intl.dart';

import 'package:padelmarcheofficialflutter/PaginaProfilo.dart';

import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await Firebase.initializeApp();

  GestioneFirebase gestioneFirebase = GestioneFirebase();

  WidgetsFlutterBinding.ensureInitialized();

  // Set default home.
  Widget defaultHome = const MyLoginPage();

  /// se non c'è un account in memoria si va alla pagina di login
  if (gestioneFirebase.checkState()) {
    // FirebaseAuth.instance.currentUser!=null) {
    defaultHome = const HomePage(); //new MyApp();
  }
  runApp(MaterialApp(
    // theme: CustomTheme.lightTheme,
    // darkTheme: CustomTheme.darkTheme,
    title: 'PadelMarche',
    home: defaultHome,

    /// si definiscono le rotta utili alla navigazione
    routes: <String, WidgetBuilder>{

      '/home': (BuildContext context) => const HomePage(),
      MyLoginPage.routeName: (BuildContext context) => const MyLoginPage(),
      ViewProfile.routeName: (context) => ViewProfile(),
      //   Comments.routeName: (context) => Comments()  COMMENTATIO IO
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

  //String annoCorrente = "";
  // List anni = List.generate(0, (index) => null);  COMMENTATO IO
  // List posts = List.generate(0, (index) => null);  COMMENTATO IO

  late HashMap account = HashMap();

  @override
  void initState() {
    super.initState();
    init();
  }

  ///inizializzazione
  ///si recuperano le informazioni dell'account loggato
  ///si recuperano le classi associate al corso di laurea dell'account loggato
  ///si recuperano i post della classe dell'account loggato
  void init() async {
    await gestioneFirebase.leggiInfo().then((acc) {
      setState(() {
        account = acc;

      });
    });
   /* await gestioneFirebase.downloadAnni(account['idCorso']).then((ann) {
      setState(() {
        anni = ann;
      });
    });
    await gestioneFirebase
        .leggiPosts(account['idCorso'], account['idClasse'])
        .then((ris) {
      setState(() {
        posts = ris;
      });
    }); */
  }

  ///funzione che viene richiamata quando devo visualizzare il profilo alla quale si passa l'hashMap identificativa dell'account
  void _lauchUserProfile() {
    Navigator.pushNamed(
      context,
      ViewProfile.routeName,
      arguments: MyProfile(account),
    );
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
      if(_currentIndex == 0){
        _lauchUserProfile();
      }
      else if(_currentIndex == 2){
        logout();
      }
    });


}


  @override
  Widget build(BuildContext context) {return Scaffold(
    appBar: AppBar(
      title: Text('PadelMarche',
          style: TextStyle(color: Colors.white,
      )),

      backgroundColor: Colors.blue,
    ),
    body: Center(
      child: Text('Contenuto principale qui'),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      items: [
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
