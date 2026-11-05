import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'logbook_page.dart';

void main() {
  runApp(const BarometerApp());
}

class BarometerApp extends StatelessWidget {
  const BarometerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slui Barometer Logbook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BarometerHomePage(),
    );
  }
}

class BarometerHomePage extends StatefulWidget {
  const BarometerHomePage({super.key});

  @override
  State<BarometerHomePage> createState() =>
      _BarometerHomePageState();
}

class _BarometerHomePageState
    extends State<BarometerHomePage> {
  final TextEditingController pressureController =
      TextEditingController();

  final TextEditingController temperatureController =
      TextEditingController();

  final TextEditingController humidityController =
      TextEditingController();

  Future<void> saveMeasurement() async {
    if (pressureController.text.isEmpty ||
        temperatureController.text.isEmpty ||
        humidityController.text.isEmpty) {
      return;
    }

    final now = DateTime.now();

    final date =
        "${now.day.toString().padLeft(2, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.year}";

    final time =
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}";

    await DatabaseHelper.instance.insertMeasurement({
      "date": date,
      "time": time,
      "pressure":
          double.parse(pressureController.text),
      "temperature":
          double.parse(temperatureController.text),
      "humidity":
          double.parse(humidityController.text),
    });

    pressureController.clear();
    temperatureController.clear();
    humidityController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            "Meting opgeslagen in SQLite database"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slui Barometer Logbook"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: pressureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Barometric Pressure (hPa)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: temperatureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Temperature (°C)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Humidity (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveMeasurement,
                child: const Text("Save Measurement"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LogbookPage(),
                    ),
                  );
                },
                child: const Text("Open Logbook"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}