import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfile{
  HashMap account;
  MyProfile(this.account);
}

///visualizzazione delle informazioni del profilo di un utente
class ViewProfile extends StatelessWidget{
  static const routeName = '/viewProfile';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyProfile;
    print(args);
    return Scaffold(
      appBar: AppBar(
        title: Text("Visualizza profilo"),
      ),
      body: ListView(
        children:<Widget>[
          SizedBox(height: 20),
          Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Theme.of(context).primaryColor,
                width: 3.0,
              ),
            ),
            child: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 3.0,
                ),
              ),
              child:Center(
                child:ClipOval(
                  child: Image.network(args.account['img'],width: 120.0,height: 120.0,fit: BoxFit.fill,),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          visualizzaCampo("Nome", args.account['nome'],context),
          SizedBox(height: 20),
          visualizzaCampo("Cognome", args.account['cognome'],context),
          SizedBox(height: 20),
          visualizzaCampo("Email", args.account['email'],context),

          SizedBox(height: 20),
          visualizzaCampo("Data di nascita", args.account['dataDiNascita'],context),
          SizedBox(height: 20),
          visualizzaCampo("Cellulare", args.account['cellulare'],context),
          SizedBox(height: 20),
          visualizzaCampo("Sesso", args.account['sesso'],context),

        ],
      ),
    );
  }

  ///widget univoco, utilizzato per la visualizzazione di un'informazione dell'utente loggato
  Widget visualizzaCampo(String campo, String valore, context){
    return Container(
      padding: EdgeInsets.only(left: 40.0,right: 40.0),
      color: Theme.of(context).cardColor,
      child: Column(
          children:<Widget>[
            Align(child: Text(campo, style: TextStyle(color:Theme.of(context).primaryColor, fontSize: 15) ), alignment: Alignment.centerLeft,),
            SizedBox(height:5),
            Align(child: Text(valore,style: TextStyle(fontSize: 18),),alignment: Alignment.centerLeft,),
            Divider(color:Theme.of(context).primaryColor,height: 5,thickness: 2)
          ] //
      ),
    );
  }
}