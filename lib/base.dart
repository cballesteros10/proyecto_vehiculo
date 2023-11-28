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
  static const String tablaCategorias = 'categorias';
  static const String tablaResponsables = 'responsables';

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
          'fecha INTEGER,'
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

        await db.execute(
          'CREATE TABLE $tablaCategorias('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'gasto_id INTEGER,'
          'nombre TEXT,'
          'FOREIGN KEY (gasto_id) REFERENCES $tablaGastos (id));'
        );

        await db.execute(
          'CREATE TABLE $tablaResponsables('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'gasto_id INTEGER,'
          'nombre TEXT,'
          'direccion TEXT(100),'
          'telefono TEXT,'
          'FOREIGN KEY (gasto_id) REFERENCES $tablaGastos (id));'
        );  
      }, version: 1,
    );
  }

  Future<List<Vehiculo>> getVehiculos() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _basedatos.query(tablaVehiculos);

    if(maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
      final List<Gastos> gastos = [];
      return Vehiculo(
        id: maps[i]['id'],
        placa: maps[i]['placa'],
        modelo: maps[i]['modelo'], 
        marca: maps[i]['marca'], 
        tipo: maps[i]['tipo'], 
        fecha: maps[i]['fecha'], 
        gastos: gastos);
    });
    } else {
      return [];
    }
  }

  Future<List<Categorias>> getCategorias() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _basedatos.query(tablaCategorias);

    if(maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
      return Categorias(
        nombre: maps[i]['nombre']);
    });
    } else {
      return [];
    }
  }

  Future<List<Responsables>> getResponsables() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _basedatos.query(tablaResponsables);

    if(maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
      return Responsables(
        nombre: maps[i]['nombre'], 
        direccion: maps[i]['direccion'], 
        telefono: maps[i]['telefono']);
    });
    } else {
      return [];
    }
  }

  Future<void> agregarVehiculo(Vehiculo vehiculo) async {
    await _initDatabase();
    await _basedatos.insert(tablaVehiculos, vehiculo.miMapaVehiculos());
  }

  Future<void> agregarVehiculo2(Vehiculo vehiculo) async {
    await _initDatabase();
    await _basedatos.rawInsert('INSERT INTO $tablaVehiculos (placa, modelo, marca, tipo, fecha) VALUES (?, ?, ?, ?, ?)', 
    [vehiculo.placa, vehiculo.modelo, vehiculo.marca, vehiculo.tipo, vehiculo.fecha]);
  }

  Future<void> agregarCategoria(Categorias categorias) async {
    await _initDatabase();
    await _basedatos.insert(tablaCategorias, categorias.miMapaCategorias());
  }

  Future<void> agregarCategoria2(Categorias categorias) async {
    await _initDatabase();
    await _basedatos.rawInsert('INSERT INTO $tablaCategorias (nombre) VALUES (?)', [categorias.nombre]);
  }

  Future<void> agregarResponsable(Responsables responsables) async {
    await _initDatabase();
    await _basedatos.rawInsert('INSERT INTO $tablaResponsables (nombre, direccion, telefono) VALUES (?, ?, ?)', 
    [responsables.nombre, responsables.direccion, responsables.telefono]);
  }

  Future<void> agregarResponsable2(Responsables responsables) async {
    await _initDatabase();
    await _basedatos.insert(tablaResponsables, responsables.miMapaResponsables());
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

  Future<void> eliminarCategotia(int categoriaID) async {
    //await _initDatabase();
    await _basedatos.delete(tablaCategorias, where: 'id = ?', whereArgs: [categoriaID]);
    await _basedatos.delete(tablaGastos, where: 'gasto_id = ?', whereArgs: [categoriaID]);
  }

  Future<void> eliminarResponsable(int responsableID) async {
    //await _initDatabase();
    await _basedatos.delete(tablaResponsables, where: 'id = ?', whereArgs: [responsableID]);
    await _basedatos.delete(tablaGastos, where: 'gasto_id = ?', whereArgs: [responsableID]);
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
      final List<Categorias> categorias = [];
      final List<Responsables> responsables = [];
      return Gastos(vehiculoID,
      categoria: categorias, 
      descripcion: maps[i]['descripcion'], 
      responsable: responsables, 
      fecha: maps[i]['fecha'], 
      monto: maps[i]['monto']);
    });
  } 
}