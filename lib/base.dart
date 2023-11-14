import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

late Database db;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  /* var fabricaBaseDatos = databaseFactoryFfiWeb; */
  var fabricaBaseDatos = databaseFactory;
  String rutaBaseDatos = '${await fabricaBaseDatos.getDatabasesPath()}/base.db';
  db = await fabricaBaseDatos.openDatabase(
    rutaBaseDatos,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db,version) async {
        await db.execute('CREATE TABLE vehiculos ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT,' 
        'marca TEXT(35),' 
        'modelo TEXT(35),'
        'placa TEXT(15),'
        'tipo TEXT(20),'
        'fecha int);');
      }
    )
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Base(),
      ),
    );
  }
}

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
    void agregar(String marca, modelo, placa, tipo, int fecha) async {
    await db.rawInsert('INSERT INTO vehiculos('
    'marca, modelo, placa, tipo, fecha) VALUES (?)', [marca, modelo, placa, tipo, fecha]);
  }

  void eliminar(int ID) async {
    await db.rawDelete('DELETE FROM vehiculos WHERE ID = ?', [ID]);
  }

  Future<List<String>> todosLosVehiculos() async {
    var resultadoConsulta = await db.rawQuery('SELECT ID FROM vehiculos');
    return resultadoConsulta.map((e) => e['ID'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}