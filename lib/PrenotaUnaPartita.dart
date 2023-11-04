import 'dart:collection';
import 'dart:core';
import 'package:padelmarcheofficialflutter/GestioneFirebase.dart';
import 'package:flutter/material.dart';

import 'CentroSportivo.dart';

class PrenotaUnaPartita extends StatefulWidget {
  static const routeName = '/prenotaunapartita';
  static final gestionefirebase = GestioneFirebase();

  const PrenotaUnaPartita({super.key});

  @override
  _PrenotaUnaPartitaState createState() => _PrenotaUnaPartitaState();
}

class _PrenotaUnaPartitaState extends State<PrenotaUnaPartita> {
  String? selectedSede = null;
  DateTime selectedDate = DateTime.now();
  List<String> sedi = [];
  String ora = '9:00:00';
  late Map<String, CentroSportivo> mappacentri;
  @override
  void initState() {
    super.initState();

    ///funzione che scarica le sedi
    GestioneFirebase().downloadSedi().then((sediList) {
      setState(() {
        mappacentri = sediList;
        List<String> temp = [];
        for( var sede in sediList.keys){
          temp.add(sede);

        }

        sedi = temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void onButtonClicked(String ora) async {
      if (selectedSede != null) {
        // Chiama la funzione per cercare le prenotazioni in Firestore
        List<String> parti = ora.split(":");
        DateTime selected = selectedDate;
        selected = selected.add(Duration(hours: int.tryParse(parti[0])!));
        final bool fasciaOccupata = await GestioneFirebase()
            .cercaPrenotazioniFirebase(mappacentri[selectedSede]!.id, selected, ora);

        if (!fasciaOccupata) {
          // L'orario è disponibile, puoi confermare la prenotazione


          GestioneFirebase().uploadPrenotazione(mappacentri[selectedSede]!.id, selected);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Conferma'),
                content: Text('Prenotazione confermata per l\'ora $ora.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // L'orario non è disponibile
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Errore'),
                content: Text('L\'ora $ora non è disponibile.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prenota Una Partita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Seleziona una Provincia:'),
            DropdownButton<String>(
              value: selectedSede,
              items: sedi.map((sede) {
                return DropdownMenuItem<String>(
                  value: sede,
                  child: Text(sede),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSede = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text('Seleziona una Data:'),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2024),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                "${selectedDate.toLocal()}".split(' ')[0],
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: [
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '9:00:00';
                      onButtonClicked(ora);
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 9:00 alle 10:00'),
                  ),
                ),
                const SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '10:00:00';
                      onButtonClicked(ora);
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 10:00 alle 11:00'),
                  ),
                ),
                const SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '11:00:00';
                      onButtonClicked(ora);
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 11:00 alle 12:00'),
                  ),
                ),
                const SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '15:00:00';
                      onButtonClicked(ora);
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 15:00 alle 16:00'),
                  ),
                ),
                const SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '16:00:00';
                      onButtonClicked(ora);
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 16:00 alle 17:00'),
                  ),
                ),
                const SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '17:00:00';
                      onButtonClicked(ora);
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 17:00 alle 18:00'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Azione per il bottone di conferma
                },
                child: const Text('Conferma'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
  return MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.pressed)) {
      return colorPressed;
    }
    return color;
  });
}
