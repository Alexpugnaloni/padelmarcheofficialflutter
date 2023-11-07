import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CentroSportivo.dart';
import 'GestioneFirebase.dart';
import 'dart:core';
import 'Prenotazione.dart';

///Classe che mostra a video le prenotazioni effettuate dall'utente
class Prenotazioni extends StatefulWidget {
  static const routeName = '/prenotazioni';
  static final gestionefirebase = GestioneFirebase();
  const Prenotazioni({super.key});

  @override
  _PrenotazioniState createState() => _PrenotazioniState();
}

class _PrenotazioniState extends State<Prenotazioni> {
  final _auth = FirebaseAuth.instance;
  String? selectedSede = null;
  List<String> sedi = [];
  late Map<String, CentroSportivo> mappacentri;
  List<Prenotazione> prenotazioniUtente = [];


  @override
  void initState() {
    super.initState();

    ///funzione che scarica le sedi
    GestioneFirebase().downloadSedi().then((sediList) {
      setState(() {
        mappacentri = sediList;
        List<String> temp = [];
        for (var sede in sediList.keys) {
          temp.add(sede);
        }
        sedi = temp;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Prenotazioni'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Seleziona una Sede:',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            DropdownButton<String>(
              value: selectedSede,
              items: sedi.map((sede) {
                return DropdownMenuItem<String>(
                  value: sede,
                  child: Text(sede),
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedSede = value!;
                  print(selectedSede);
                  print(_auth.currentUser!.uid.toString());

                });
                ///download delle prenotazioni dell'utente una volta passato l'id della sede e l'id dell'utente
                ///si effettua inoltre l'ordinamento delle date
                prenotazioniUtente = await GestioneFirebase().downloadPrenotazioniUtente(mappacentri[selectedSede]!.id, _auth.currentUser!.uid.toString());
                prenotazioniUtente.sort((a,b) => a.data.compareTo(b.data));
                print(prenotazioniUtente);
                setState(() {
                  prenotazioniUtente;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              'Ecco qua le tue prenotazioni:',
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
                itemCount: prenotazioniUtente.length,
                itemBuilder: (context, index) {
                  final prenotazione = prenotazioniUtente[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(
                            15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data: ${prenotazione.data.day}/${prenotazione.data.month}/${prenotazione.data.year}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Dalle ore: ${prenotazione.data.hour}:${prenotazione.data.minute}0',
                            style: TextStyle(
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