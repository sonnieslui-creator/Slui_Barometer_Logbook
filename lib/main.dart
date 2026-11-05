import 'package:flutter/material.dart';

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
  State<BarometerHomePage> createState() => _BarometerHomePageState();
}

class _BarometerHomePageState extends State<BarometerHomePage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController pressureController = TextEditingController();
  final TextEditingController temperatureController =
      TextEditingController();
  final TextEditingController humidityController =
      TextEditingController();

  final List<Map<String, String>> measurements = [];

  void saveMeasurement() {
    if (dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        pressureController.text.isEmpty ||
        temperatureController.text.isEmpty ||
        humidityController.text.isEmpty) {
      return;
    }

    setState(() {
      measurements.insert(0, {
        "date": dateController.text,
        "time": timeController.text,
        "pressure": pressureController.text,
        "temperature": temperatureController.text,
        "humidity": humidityController.text,
      });
    });

    pressureController.clear();
    temperatureController.clear();
    humidityController.clear();
  }

  @override
  void initState() {
    super.initState();

    dateController.text = "05-11-2026";
    timeController.text = "12:00";
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
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Datum (dd-mm-jjjj)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: "Tijd (hh:mm)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: pressureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Luchtdruk (hPa)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: temperatureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Temperatuur (°C)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Luchtvochtigheid (%)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveMeasurement,
                child: const Text("Meting Opslaan"),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Logboek",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: measurements.length,
                itemBuilder: (context, index) {
                  final item = measurements[index];

                  return Card(
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