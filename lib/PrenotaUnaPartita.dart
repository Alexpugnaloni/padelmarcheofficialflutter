import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'package:padelmarcheofficialflutter/PaginaProfilo.dart';
import 'package:padelmarcheofficialflutter/GestioneFirebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'package:flutter_animated_button/flutter_animated_button.dart';

class PrenotaUnaPartita extends StatefulWidget {
  static const routeName = '/prenotaunapartita';
  static final gestionefirebase = GestioneFirebase();

  @override
  _PrenotaUnaPartitaState createState() => _PrenotaUnaPartitaState();
}

class _PrenotaUnaPartitaState extends State<PrenotaUnaPartita> {
  String selectedSede = 'Ancona';
  DateTime selectedDate = DateTime.now();
  List<String> sedi = [];




  @override
  void initState() {
    super.initState();

    ///funzione che scarica le sedi
    GestioneFirebase().downloadNomiSedi().then((sediList) {
      setState(() {
        sedi = sediList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prenota Una Partita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Seleziona una Provincia:'),
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
            SizedBox(height: 16.0),
            Text('Seleziona una Data:'),
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
            SizedBox(height: 16.0),
            Column(
              children: [
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),

                    ),
                    child: Text('Ora dalle 9:00 alle 10:00'),
                  ),
                ),
                SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),

                    ),
                    child: Text('Ora dalle 10:00 alle 11:00'),
                  ),
                ),
                SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),

                    ),
                    child: Text('Ora dalle 11:00 alle 12:00'),
                  ),
                ),
                SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),

                    ),
                    child: Text('Ora dalle 15:00 alle 16:00'),
                  ),
                ),
                SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),

                    ),
                    child: Text('Ora dalle 16:00 alle 17:00'),
                  ),
                ),
                SizedBox(
                  height: 16, // Spazio desiderato tra i bottoni
                ),
                SizedBox(
                  width: 300, // Larghezza desiderata
                  height: 50, // Altezza desiderata
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione per il primo bottone
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),

                    ),
                    child: Text('Ora dalle 17:00 alle 18:00'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Azione per il bottone di conferma
                },
                child: Text('Conferma'),
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


