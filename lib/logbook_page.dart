import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LogbookPage extends StatefulWidget {
  const LogbookPage({super.key});

  @override
  State<LogbookPage> createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  List<Map<String, dynamic>> measurements = [];

  @override
  void initState() {
    super.initState();
    loadMeasurements();
  }
  Future<void> exportCsv() async {
  final data =
      await DatabaseHelper.instance.getMeasurements();

  List<List<dynamic>> rows = [];

  rows.add([
    "Datum",
    "Tijd",
    "Druk_hPa",
    "Temperatuur_C",
    "Luchtvochtigheid_pct"
  ]);

  for (var item in data) {
    rows.add([
      item["date"],
      item["time"],
      item["pressure"],
      item["temperature"],
      item["humidity"],
    ]);
  }

  final csv =
      const ListToCsvConverter().convert(rows);

  final directory =
      await getApplicationDocumentsDirectory();

  final path =
      "${directory.path}/barometer_logbook.csv";

  final file = File(path);

  await file.writeAsString(csv);

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(path)],
      text: "Slui Barometer Logbook Export",
    ),
  );
}
  Future<void> loadMeasurements() async {
    final data =
        await DatabaseHelper.instance.getMeasurements();

    setState(() {
      measurements = data;
    });
  }

  Future<void> deleteMeasurement(int id) async {
    await DatabaseHelper.instance.deleteMeasurement(id);
    loadMeasurements();
  }

  Future<void> editMeasurement(
      Map<String, dynamic> item) async {
    final dateController =
        TextEditingController(text: item["date"]);

    final timeController =
        TextEditingController(text: item["time"]);

    final pressureController =
        TextEditingController(
            text: item["pressure"].toString());

    final temperatureController =
        TextEditingController(
            text: item["temperature"].toString());

    final humidityController =
        TextEditingController(
            text: item["humidity"].toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Meting Bewerken"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(labelText: "Datum"),
              ),
              TextField(
                controller: timeController,
                decoration:
                    const InputDecoration(labelText: "Tijd"),
              ),
              TextField(
                controller: pressureController,
                decoration: const InputDecoration(
                    labelText: "Luchtdruk"),
              ),
              TextField(
                controller: temperatureController,
                decoration: const InputDecoration(
                    labelText: "Temperatuur"),
              ),
              TextField(
                controller: humidityController,
                decoration: const InputDecoration(
                    labelText: "Luchtvochtigheid"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Annuleren"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Opslaan"),
            onPressed: () async {
              await DatabaseHelper.instance
                  .updateMeasurement({
                "date": dateController.text,
                "time": timeController.text,
                "pressure":
                    double.parse(pressureController.text),
                "temperature":
                    double.parse(temperatureController.text),
                "humidity":
                    double.parse(humidityController.text),
              }, item["id"]);
              if (!mounted) return;

              Navigator.pop(context);

              loadMeasurements();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text("Barometer Logboek"),
  actions: [
    IconButton(
      icon: const Icon(Icons.download),
      onPressed: exportCsv,
    ),
  ],
),
      body: measurements.isEmpty
          ? const Center(
              child: Text(
                "Geen metingen gevonden",
              ),
            )
          : ListView.builder(
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final item = measurements[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "${item["pressure"]} hPa",
                    ),
                    subtitle: Text(
                      "Datum: ${item["date"]}\n"
                      "Tijd: ${item["time"]}\n"
                      "Temperatuur: ${item["temperature"]} °C\n"
                      "Luchtvochtigheid: ${item["humidity"]} %",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit),
                          onPressed: () =>
                              editMeasurement(item),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete),
                          onPressed: () =>
                              deleteMeasurement(
                                  item["id"]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}