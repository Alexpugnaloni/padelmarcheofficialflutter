import 'package:flutter/material.dart';
import 'package:padelmarcheofficialflutter/GestioneFirebase.dart';
import 'package:padelmarcheofficialflutter/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:padelmarcheofficialflutter/Amministratore.dart';

///Classe utile ad effetturare l'accesso sull'applicazione
class PaginaLogin extends StatefulWidget {
  static const routeName = '/login';

  const PaginaLogin({super.key});

  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _auth = FirebaseAuth.instance;
  bool emailcorretta = true;
  bool nascondipassword = true;
  String email = "";
  String password = "";
  List<Amministratore> _amministratori = [];
  List<Superadmin> _superAdmin = [];

  @override
  void initState() {
    super.initState();
    _fetchAmministratori();
    _fetchSuperAdmin();
  }

  Future<void> _fetchAmministratori() async {
    _amministratori = await GestioneFirebase().downloadAmministratori();
  }

  Future<void> _fetchSuperAdmin() async {
    _superAdmin = await GestioneFirebase().downloadSuperadmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 130,
              color: const Color(0xFF0000FF),
              child: AppBar(
                toolbarHeight: 0,
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  width: 350,
                  height: 350,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset('assets/padelmarcheblu.png',
                        width: 416, height: 777),
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    obscureText: nascondipassword ? true : false,
                    keyboardType: TextInputType.visiblePassword,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: nascondipassword
                          ? IconButton(
                              icon: const Icon(
                                Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  nascondipassword = !nascondipassword;
                                });
                              })
                          : IconButton(
                              icon: const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  nascondipassword = !nascondipassword;
                                });
                              }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Material(
                    elevation: 5,
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2.0),
                    child: MaterialButton(
                        onPressed: () async {
                          setState(() {});
                          try {
                            ///Effettua l'accesso su Firebase
                            final newUser = await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            await _fetchAmministratori();
                            await _fetchSuperAdmin();

                            ///Controllo se l'utente è un amministratore
                            final isAdmin = _amministratori.any((admin) =>
                            admin.email.toLowerCase() == email.toLowerCase());

                            ///Controllo se l'utente è un superadmin
                            final isSuperAdmin = _superAdmin.any((superadmin) =>
                            superadmin.email.toLowerCase() == email.toLowerCase());


                            if (newUser != null) {
                              if (isAdmin) {
                                Navigator.pushReplacementNamed(context, '/pagina_amministratore');
                              }else if (isSuperAdmin) {
                                Navigator.pushReplacementNamed(context, '/pagina_superadmin');
                              } else {
                                Navigator.pushReplacementNamed(context, '/home');
                              }
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "Credenziali errate",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {});
                          }
                        },
                        minWidth: 200.0,
                        height: 45.0,
                        child: const Text(
                          "ACCEDI",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 20.0),
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
