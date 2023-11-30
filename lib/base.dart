import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

late Database _basedatos;

class BaseDatos {
  // ignore: constant_identifier_names
  static const String nombre_db = 'base.db';
  static const String tablaVehiculos = 'vehiculos';
  static const String tablaGastos = 'gastos';
  static const String tablaCategorias = 'categorias';
  static const String tablaResponsables = 'responsables';

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
          'fecha INTEGER);'
        );

        await db.execute(
          'CREATE TABLE $tablaGastos('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'categoria_id INTEGER,'
          'vehiculo_id INTEGER,'
          'responsable_id INTEGER,'
          'fecha INTEGER,'
          'monto REAL,'
          'FOREIGN KEY (categoria_id) REFERENCES $tablaCategorias (id),'
          'FOREIGN KEY (responsable_id) REFERENCES $tablaResponsables (id),'
          'FOREIGN KEY (vehiculo_id) REFERENCES $tablaVehiculos (id));'
        );

        await db.execute(
          'CREATE TABLE $tablaCategorias('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nombre TEXT);'
        );

        await db.execute(
          "INSERT INTO $tablaCategorias (nombre) VALUES ('General');"
        );

        await db.execute(
          'CREATE TABLE $tablaResponsables('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nombre TEXT,'
          'direccion TEXT(100),'
          'telefono TEXT);'
        );

        await db.execute(
          "INSERT INTO $tablaResponsables (nombre, direccion, telefono) VALUES ('Usuario', '', '');"
        );  
      }, version: 1,
    );
  }

  Future<List<Vehiculo>> getVehiculos() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _basedatos.query(tablaVehiculos);

    if(maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
      return Vehiculo(
        id: maps[i]['id'],
        placa: maps[i]['placa'],
        modelo: maps[i]['modelo'], 
        marca: maps[i]['marca'], 
        tipo: maps[i]['tipo'], 
        fecha: maps[i]['fecha']);
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
        id: maps[i]['id'],
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
        id: maps[i]['id'],
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
    /* await _basedatos.delete(tablaGastos, where: 'gasto_id = ?', whereArgs: [categoriaID]); */
  }

  Future<void> eliminarResponsable(int responsableID) async {
    //await _initDatabase();
    await _basedatos.delete(tablaResponsables, where: 'id = ?', whereArgs: [responsableID]);
    /* await _basedatos.delete(tablaGastos, where: 'gasto_id = ?', whereArgs: [responsableID]); */
  }

  Future<void> agregarGasto(Gastos gastos) async {
    await _initDatabase();
    await _basedatos.insert(tablaGastos, gastos.miMapaGastos());
  }

  Future<void> agregarGasto2(Gastos gastos) async {
    await _basedatos.rawInsert(
      'INSERT INTO $tablaGastos (categoria_id, vehiculo_id, responsable_id, fecha, monto) VALUES (?, ?, ?, ?, ?)', 
      [gastos.categoria, gastos.vehiculoID, gastos.responsable, gastos.fecha, gastos.monto]);
  }

  Future<List<Gastos>> getGastosPorVehiculos(int vehiculoID) async {
    final List<Map<String, dynamic>> maps = await _basedatos.query(
      tablaGastos,
      where: 'vehiculo_id = ?',
      whereArgs: [vehiculoID],
    );

    return List.generate(maps.length, (i) {
      return Gastos(
        vehiculoID: vehiculoID, 
        categoria: maps[i]['categoria_id'], 
        responsable: maps[i]['responsable_id'], 
        fecha: maps[i]['fecha'], 
        monto: maps[i]['monto']);
    });
  } 

  Future<List<Map<String, dynamic>>> consultaGastos() async {
    String consulta = 'SELECT $tablaGastos.id, $tablaGastos.categoria_id, $tablaGastos.vehiculo_id, $tablaGastos.responsable_id, $tablaGastos.fecha, $tablaGastos.monto, '
    '$tablaCategorias.nombre AS categorias, $tablaResponsables.nombre AS responsables, $tablaVehiculos.placa AS placas ' 
    'FROM $tablaGastos LEFT JOIN $tablaCategorias ON $tablaGastos.categoria_id = $tablaCategorias.id '
    'LEFT JOIN $tablaVehiculos ON $tablaGastos.vehiculo_id = $tablaVehiculos.id '
    'LEFT JOIN $tablaResponsables ON $tablaGastos.responsable_id = $tablaResponsables.id ';
    List<Map<String, dynamic>> resultado = await _basedatos.rawQuery(consulta);
    return resultado;
  }
}