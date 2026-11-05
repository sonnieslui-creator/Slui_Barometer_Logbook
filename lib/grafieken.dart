import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'database_helper.dart';

class GrafiekenPage extends StatefulWidget {
  const GrafiekenPage({super.key});

  @override
  State<GrafiekenPage> createState() => _GrafiekenPageState();
}

class _GrafiekenPageState extends State<GrafiekenPage> {
  List<Map<String, dynamic>> measurements = [];

  @override
  void initState() {
    super.initState();
    loadMeasurements();
  }

  Future<void> loadMeasurements() async {
    final data =
        await DatabaseHelper.instance.getMeasurements();

    setState(() {
      measurements = data.reversed.toList();
    });
  }

  List<FlSpot> pressureSpots() {
    return List.generate(
      measurements.length,
      (i) => FlSpot(
        i.toDouble(),
        (measurements[i]["pressure"] as num).toDouble(),
      ),
    );
  }

  List<FlSpot> temperatureSpots() {
    return List.generate(
      measurements.length,
      (i) => FlSpot(
        i.toDouble(),
        (measurements[i]["temperature"] as num).toDouble(),
      ),
    );
  }

  List<FlSpot> humiditySpots() {
    return List.generate(
      measurements.length,
      (i) => FlSpot(
        i.toDouble(),
        (measurements[i]["humidity"] as num).toDouble(),
      ),
    );
  }

  Widget buildChart({
    required String title,
    required List<FlSpot> spots,
    required Color color,
    required double minY,
    required double maxY,
  }) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  gridData: const FlGridData(
                    show: true,
                  ),
                  borderData: FlBorderData(
                    show: true,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: const FlDotData(
                        show: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Grafieken"),
        ),
        body: const Center(
          child: Text("Geen meetgegevens gevonden"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafieken"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildChart(
              title: "Temperatuur (°C)",
              spots: temperatureSpots(),
              color: Colors.red,
              minY: -10,
              maxY: 40,
            ),
            buildChart(
              title: "Barometrische Druk (hPa)",
              spots: pressureSpots(),
              color: Colors.blue,
              minY: 980,
              maxY: 1050,
            ),
            buildChart(
              title: "Luchtvochtigheid (%)",
              spots: humiditySpots(),
              color: Colors.green,
              minY: 0,
              maxY: 100,
            ),
          ],
        ),
      ),
    );
  }
}