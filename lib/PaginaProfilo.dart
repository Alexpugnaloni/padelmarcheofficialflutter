 import 'dart:collection';

import 'package:flutter/material.dart';

class MyProfile{
  HashMap account;
  MyProfile(this.account);
}

///visualizzazione delle informazioni del profilo di un utente
class ViewProfile extends StatelessWidget{
  static const routeName = '/viewProfile';

  const ViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyProfile;
    print(args);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visualizza profilo"),
      ),
      body: ListView(
        children:<Widget>[
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3.0,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 3.0,
                ),
              ),
              child:Center(
                child:ClipOval(
                  child: Image.asset('assets/padelmarcheblu.png',width: 120.0,height: 120.0,fit: BoxFit.fill,),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          visualizzaCampo("Nome", args.account['nome'],context),
          const SizedBox(height: 20),
          visualizzaCampo("Cognome", args.account['cognome'],context),
          const SizedBox(height: 20),
          visualizzaCampo("Email", args.account['email'],context),

          const SizedBox(height: 20),
          visualizzaCampo("Data di nascita", args.account['dataDiNascita'],context),
          const SizedBox(height: 20),
          visualizzaCampo("Cellulare", args.account['cellulare'],context),
          const SizedBox(height: 20),
          visualizzaCampo("Sesso", args.account['sesso'],context),

        ],
      ),
    );
  }

  ///widget univoco, utilizzato per la visualizzazione di un'informazione dell'utente loggato
  Widget visualizzaCampo(String campo, String valore, context){
    return Container(
      padding: const EdgeInsets.only(left: 40.0,right: 40.0),
      color: Theme.of(context).cardColor,
      child: Column(
          children:<Widget>[
            Align(alignment: Alignment.centerLeft,child: Text(campo, style: TextStyle(color:Theme.of(context).primaryColor, fontSize: 15) ),),
            const SizedBox(height:5),
            Align(alignment: Alignment.centerLeft,child: Text(valore,style: const TextStyle(fontSize: 18),),),
            Divider(color:Theme.of(context).primaryColor,height: 5,thickness: 2)
          ] //
      ),
    );
  }
}