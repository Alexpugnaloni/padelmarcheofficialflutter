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
    ///funzione che carica la prenotazione al click della fascia oraria
    void onButtonClicked(String ora) async {
      if (selectedSede != null) {
        List<String> parti = ora.split(":");
        DateTime selected = selectedDate;
        selected = selected.add(Duration(hours: int.tryParse(parti[0])!));
        ///i parametri popolati precedentemente, li passa a cercaprenotazionifirebase
        final bool fasciaOccupata = await GestioneFirebase()
            .cercaPrenotazioniFirebase(mappacentri[selectedSede]!.id, selected, ora);
        ///se la sede selezionata, la data e la fascia oraria sono disponibili,
        ///effettua l'upload della prenotazione
        if (!fasciaOccupata) {
          GestioneFirebase().uploadPrenotazione(mappacentri[selectedSede]!.id, selected);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Conferma'),
                content: Text('Prenotazione confermata per l\'ora $ora il giorno $selectedDate nel centro di $selectedSede.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          ///se l'orario non è disponibile lancia questo dialog
        } else {
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
              onChanged: (value) {
                setState(() {
                  selectedSede = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              'Seleziona una Data:',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
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
            const SizedBox(height: 20.0),
            Text(
              'Verifica e Conferma una prenotazione cliccando sulla fascia oraria desiderata:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),
            ),

            const SizedBox(height: 16.0),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '9:00:00';
                      onButtonClicked(ora);
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 9:00 alle 10:00',
                      style: TextStyle(
                      fontSize: 18.0),
                  ),
                ),
              ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '10:00:00';
                      onButtonClicked(ora);
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 10:00 alle 11:00',
                      style: TextStyle(
                          fontSize: 18.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '11:00:00';
                      onButtonClicked(ora);
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 11:00 alle 12:00',
                      style: TextStyle(
                          fontSize: 18.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '15:00:00';
                      onButtonClicked(ora);
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 15:00 alle 16:00',
                      style: TextStyle(
                          fontSize: 18.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '16:00:00';
                      onButtonClicked(ora);
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 16:00 alle 17:00',
                      style: TextStyle(
                          fontSize: 18.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ora = '17:00:00';
                      onButtonClicked(ora);
                    },
                    style: ButtonStyle(
                      backgroundColor: getColor(Colors.blue, Colors.red),
                    ),
                    child: const Text('Ora dalle 17:00 alle 18:00',
                      style: TextStyle(
                          fontSize: 18.0),
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
///metodo per il cambio di colore al click del bottone della fascia oraria
MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
  return MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.pressed)) {
      return colorPressed;
    }
    return color;
  });
}
