import 'package:flutter/material.dart';
import 'package:padelmarcheofficialflutter/main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyLoginPage extends StatefulWidget {
  static const routeName = '/login';

  const MyLoginPage({super.key});
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  bool emailcorretta = true;
  bool nascondipassword = true;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 130, // Altezza dell'AppBar
            color: const Color(0xFF0000FF), // Colore di sfondo
            child: AppBar(
              toolbarHeight: 0, // Nasconde la barra degli strumenti
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              /*    Container(
                    margin: EdgeInsets.only(top: 10), // Aggiungi il margine superiore desiderato
                    child: Image.asset('assets/padelmarcheblu.png', width: 416, height: 777),
                  ), */
                  SizedBox(
                    width: 350, // Larghezza del contenitore quadrato
                    height: 350, // Altezza del contenitore quadrato
                    child: FittedBox(
                      fit: BoxFit.contain, // Puoi regolare il fit a tuo piacimento
                      child: Image.asset('assets/padelmarcheblu.png', width: 416, height: 777),
                    ),
                  ),

                  // Sostituisci con l'immagine desiderata
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                    child: TextFormField(
                      //          cursorColor: Theme.of(context).cursorColor,  CAMBIATA IO
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value; // get value from TextField
                        setState(() {
                        //  emailcorretta = email.isEmpty ;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                     //   errorText: emailcorretta ? null : 'Email non valida',
                     //   border: const OutlineInputBorder(),
                     //   suffixIcon: emailcorretta ? null : const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                    child: TextFormField(
                      obscureText: nascondipassword? true:false,
                      keyboardType: TextInputType.visiblePassword,
                      //            cursorColor: Theme.of(context).cursorColor,  CAMBIATA IO
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value; //get value from textField
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon:nascondipassword? IconButton(
                            icon: const Icon(Icons.visibility,),
                            onPressed:(){
                              setState(() {
                                nascondipassword=!nascondipassword;
                              });
                            }
                        ):IconButton(
                            icon:const Icon(Icons.visibility_off),
                            onPressed: (){
                              setState(() {
                                nascondipassword=!nascondipassword;
                              });
                            }
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                      elevation: 5,
                      color: Theme.of(context).primaryColor,//Colors.red,
                      borderRadius: BorderRadius.circular(2.0),
                      child: MaterialButton(
                          onPressed: () async {
                            setState(() {
                              showProgress = true;
                            });
                            try {
                              ///login su firebase
                              final newUser = await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              print(newUser.toString());
                              ///check se un account è verificato
                          /*    if (newUser.user!.emailVerified) {
                                setState(() {
                                  showProgress = false;
                                }); */

                                ///navigazione verso la homepage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const HomePage();//MyApp();
                                  }),
                                );
                                Navigator.of(context).pushNamed("/home");
                           //   }
                                                        } catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Credenziali errate o email non verificata",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              setState(() {
                                showProgress = false;
                              });
                            }
                          },
                          minWidth: 200.0,
                          height: 45.0,
                          child: const Text(
                            "ACCEDI",
                            style:TextStyle(fontWeight: FontWeight.w500,color: Colors.white, fontSize: 20.0),
                          )
                      )
                  ),
                ],
              ),

            ),
          ),

        ],
      ),
    );

  }
}