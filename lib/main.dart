import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OpcionesPantallas()
            ],
          ),
          centerTitle: true,
          flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4C60AF),
              Color.fromARGB(255, 37, 195, 248),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      )),
        body: const Center(
          // MiInfo()
        ),
      ),
    );
  }
}

class OpcionesPantallas extends StatefulWidget {
  const OpcionesPantallas({super.key});

  @override
  State<OpcionesPantallas> createState() => _OpcionesPantallasState();
}

class _OpcionesPantallasState extends State<OpcionesPantallas> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      multiSelectionEnabled: false,
      segments: const [
      ButtonSegment(icon: Icon(Icons.car_crash), value: 'Vehiculos', label: Text('Vehiculos')),
      ButtonSegment(icon: Icon(Icons.money), value: 'Gastos', label: Text('Gastos')),
      ButtonSegment(icon: Icon(Icons.woman), value: 'Consultas', label: Text('Consultas'))
    ], 
      selected: const {2});
  }
}

class MiInfo extends StatelessWidget {
  const MiInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}