import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class BaseDatos {
  // ignore: constant_identifier_names
  static const String nombre_db = 'base2.db';
  static const String tablaVehiculos = 'vehiculos';
  static const String tablaGastos = 'gastos';

  late Database _basedatos;

  Future<void> _initDatabase() async {
    _basedatos = await openDatabase(
      join(await getDatabasesPath(), nombre_db),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tablaVehiculos('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'placa TEXT,'
          'modelo TEXT,'
          'marca TEXT,'
          'tipo TEXT,'
          'fecha TEXT,'
          'gastos TEXT);'
        );

        await db.execute(
          'CREATE TABLE $tablaGastos('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'vehiculo_id INTEGER,'
          'descripcion TEXT,'
          'responsable TEXT,'
          'fecha TEXT,'
          'monto REAL,'
          'FOREIGN KEY (vehiculo_id) REFERENCES $tablaVehiculos (id));'
        );  
      }, version: 1,
    );
  }

  Future<List<Vehiculo>> getVehiculos() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _basedatos.query(tablaVehiculos);

    if(maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
      final vehiculoID = maps[i]['id'];
      final List<Gastos> gastos = [];
      return Vehiculo(
        vehiculoID,
        placa: 'placa',
        modelo: 'modelo', 
        marca: 'marca', 
        tipo: 'tipo', 
        fecha: 'fecha', 
        gastos: gastos);
    });
    } else {
      return [];
    }
  }

  Future<void> agregarVehiculo(Vehiculo vehiculo) async {
    await _initDatabase();
    await _basedatos.insert(tablaVehiculos, vehiculo.miMapaVehiculos());
  }

  Future<List<String>> todosLosNombres() async {
    var resultadoConsulta = await _basedatos.rawQuery('SELECT placa FROM $tablaVehiculos');
    return resultadoConsulta.map((e) => e['placa'] as String).toList();
  }

  Future<void> eliminarVehiculo(int vehiculoID) async {
    //await _initDatabase();
    await _basedatos.delete(tablaVehiculos, where: 'id = ?', whereArgs: [vehiculoID]);
    await _basedatos.delete(tablaGastos, where: 'vehiculo_id = ?', whereArgs: [vehiculoID]);
  }

  Future<void> agregarGasto(int vehiculoID, Gastos gastos) async {
    // await _initDatabase();
    gastos.vehiculoID = vehiculoID;
    await _basedatos.insert(tablaGastos, gastos.miMapaGastos());
  }

  Future<List<Gastos>> getGastosPorVehiculos(int vehiculoID) async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _basedatos.query(
      tablaGastos,
      where: 'vehiculo_id = ?',
      whereArgs: [vehiculoID],
    );

    return List.generate(maps.length, (i) {
      return Gastos(vehiculoID, 
      descripcion: maps[i]['descripcion'], 
      responsable: maps[i]['responsable'], 
      fecha: maps[i]['fecha'], 
      monto: maps[i]['monto']);
    });
  } 
}