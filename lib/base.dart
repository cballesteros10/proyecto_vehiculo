import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:my_car_app/modelos/plantilla.dart';

late Database _basedatos;

class BaseDatos {
  static const String nombreDB = 'base4.db';
  static const String tablaVehiculos = 'vehiculos';
  static const String tablaGastos = 'gastos';
  static const String tablaCategorias = 'categorias';
  static const String tablaResponsables = 'responsables';

  Future<void> initDatabase() async {
    _basedatos = await openDatabase(
      join(await getDatabasesPath(), nombreDB),
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $tablaVehiculos('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'placa TEXT,'
            'modelo TEXT,'
            'marca TEXT,'
            'tipo TEXT,'
            'fecha INTEGER);');

        await db.execute('CREATE TABLE $tablaGastos('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'categoria_id INTEGER DEFAULT -1,'
            'vehiculo_id INTEGER,'
            'responsable_id INTEGER DEFAULT -1,'
            'fecha INTEGER,'
            'monto REAL,'
            'FOREIGN KEY (categoria_id) REFERENCES $tablaCategorias (id) ON DELETE SET DEFAULT,'
            'FOREIGN KEY (responsable_id) REFERENCES $tablaResponsables (id) ON DELETE SET DEFAULT,'
            'FOREIGN KEY (vehiculo_id) REFERENCES $tablaVehiculos (id) ON DELETE CASCADE);');

        await db.execute('CREATE TABLE $tablaCategorias('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'nombre TEXT);');

        await db.execute(
            "INSERT INTO $tablaCategorias (id, nombre) VALUES (-1, 'General');");

        await db.execute('CREATE TABLE $tablaResponsables('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'nombre TEXT,'
            'direccion TEXT(100),'
            'telefono TEXT);');

        await db.execute(
            "INSERT INTO $tablaResponsables (id, nombre, direccion, telefono) VALUES (-1, 'Usuario', '', '');");
      },
      version: 1,
    );
  }

  Future<List<Vehiculo>> getVehiculos() async {
    final List<Map<String, dynamic>> maps =
        await _basedatos.query(tablaVehiculos);

    if (maps.isNotEmpty) {
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

  Future<List<Gastos>> getGastos() async {
    final List<Map<String, dynamic>> maps = await _basedatos.query(tablaGastos);

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Gastos(
            id: maps[i]['id'],
            vehiculoID: maps[i]['vehiculo_id'],
            categoria: maps[i]['categoria_id'],
            responsable: maps[i]['responsable_id'],
            fecha: maps[i]['fecha'],
            monto: maps[i]['monto']);
      });
    } else {
      return [];
    }
  }

  Future<List<Categorias>> getCategorias() async {
    final List<Map<String, dynamic>> maps =
        await _basedatos.query(tablaCategorias);

    if (maps.isNotEmpty) {
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
    final List<Map<String, dynamic>> maps =
        await _basedatos.query(tablaResponsables);

    if (maps.isNotEmpty) {
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
    await _basedatos.insert(tablaVehiculos, vehiculo.miMapaVehiculos());
  }

  Future<void> agregarCategoria2(Categorias categorias) async {
    await _basedatos.rawInsert(
        'INSERT INTO $tablaCategorias (nombre) VALUES (?)',
        [categorias.nombre]);
  }

  Future<void> agregarResponsable(Responsables responsables) async {
    await _basedatos.rawInsert(
        'INSERT INTO $tablaResponsables (nombre, direccion, telefono) VALUES (?, ?, ?)',
        [responsables.nombre, responsables.direccion, responsables.telefono]);
  }

  Future<List<String>> todosLosNombres() async {
    var resultadoConsulta =
        await _basedatos.rawQuery('SELECT placa FROM $tablaVehiculos');
    return resultadoConsulta.map((e) => e['placa'] as String).toList();
  }

  Future<List<String>> todasLasCategorias() async {
    var resultadoConsulta2 = await _basedatos.rawQuery('SELECT nombre FROM $tablaCategorias');
    return resultadoConsulta2.map((e) => e['nombre'] as String).toList();
  }

  Future<List<String>> todasLosResponsables() async {
    var resultadoConsulta3 = await _basedatos.rawQuery('SELECT telefono FROM $tablaResponsables');
    return resultadoConsulta3.map((e) => e['telefono'] as String).toList();
  }

  Future<void> eliminarVehiculo(int vehiculoID) async {
    await _basedatos
        .delete(tablaVehiculos, where: 'id = ?', whereArgs: [vehiculoID]);
    await _basedatos
        .delete(tablaGastos, where: 'vehiculo_id = ?', whereArgs: [vehiculoID]);
  }

  Future<void> eliminarGasto(int gastoID) async {
    await _basedatos.delete(tablaGastos, where: 'id = ?', whereArgs: [gastoID]);
  }

Future<int> obtenerIDCategoriaPredeterminada() async {
    const categoriaPredeterminada = 'General';
    final resultado = await _basedatos.query(tablaCategorias,
        where: 'nombre = ?', whereArgs: [categoriaPredeterminada]);

    return resultado.isNotEmpty ? resultado.first['id']  as int: -1;
  }

  Future<int> obtenerIDResponsablePredeterminado() async {
    const responsablePredeterminado = 'Usuario';
    final resultado = await _basedatos.query(tablaResponsables,
        where: 'nombre = ?', whereArgs: [responsablePredeterminado]);

    return resultado.isNotEmpty ? resultado.first['id']  as int: -1;
  }

  Future<void> eliminarCategoria(int categoriaID) async {
    final idCategoriaPredeterminada = await obtenerIDCategoriaPredeterminada();

    if (categoriaID != idCategoriaPredeterminada) {
      await _basedatos.delete(tablaCategorias, where: 'id = ?', whereArgs: [categoriaID]);
    }
  }

  Future<void> eliminarResponsable(int responsableID) async {
    final idResponsablePredeterminado = await obtenerIDResponsablePredeterminado();

    if (responsableID != idResponsablePredeterminado) {
      await _basedatos.delete(tablaResponsables, where: 'id = ?', whereArgs: [responsableID]);
    }
  }

  Future<void> editarVehiculo(String placa, String modelo, String marca, String tipo, int fecha, int id) async {
    await _basedatos.rawUpdate(
        'UPDATE $tablaVehiculos SET placa = ?, modelo = ?, marca = ?, tipo = ?, fecha = ? WHERE id = ?',
        [placa, modelo, marca, tipo, fecha, id]);
  }

  Future<void> editarCategoria(String nombre, int id) async {
    await _basedatos.rawUpdate(
        'UPDATE $tablaCategorias SET nombre = ? WHERE id = ?', [nombre, id]);
  }

  Future<void> editarResponsable(String nombre, String direccion, String telefono, int id) async {
    await _basedatos.rawUpdate(
        'UPDATE $tablaResponsables SET nombre = ?, direccion = ?, telefono = ? WHERE id = ?',
        [nombre, direccion, telefono, id]);
  }

  Future<List<Gastos>> editarGasto(Gastos gastos) async {
    await _basedatos.update(tablaGastos, 
    {
      'categoria_id': gastos.categoria,
      'vehiculo_id': gastos.vehiculoID, 
      'responsable_id': gastos.responsable, 
      'fecha': gastos.fecha, 
      'monto': gastos.monto
    },
    where: 'id = ?', whereArgs: [gastos.id],
    conflictAlgorithm: ConflictAlgorithm.replace);
   /*  await _basedatos.rawUpdate('UPDATE $tablaGastos SET categoria_id = ?, vehiculo_id = ?, responsable_id = ?, fecha = ?, monto = ? WHERE id = ?',
    [gastos.categoria, gastos.vehiculoID, gastos.responsable, gastos.fecha, gastos.monto]); */
    List<Map<String, dynamic>> gastosActualizados = await _basedatos.query(tablaGastos);
    List<Gastos> lista = gastosActualizados.map((e) {
          return Gastos(
            id: e['id'],
            vehiculoNombre: e['placas'],
            categoriaNombre: e['categorias'],
            responsableNombre: e['responsables'],
            vehiculoID: e['vehiculo_id'], 
            categoria: e['categoria_id'], 
            responsable: e['responsable_id'], 
            fecha: e['fecha'], 
            monto: e['monto']);
        }).toList();

        return lista;
  }

  Future<void> agregarGasto2(Gastos gastos) async {
    await _basedatos.rawInsert(
        'INSERT INTO $tablaGastos (categoria_id, vehiculo_id, responsable_id, fecha, monto) VALUES (?, ?, ?, ?, ?)',
        [
          gastos.categoria,
          gastos.vehiculoID,
          gastos.responsable,
          gastos.fecha,
          gastos.monto
        ]);
  }

  Future<List<Map<String, dynamic>>> consultaGastos() async {
    String consulta =
        'SELECT $tablaGastos.id, $tablaGastos.categoria_id, $tablaGastos.vehiculo_id, $tablaGastos.responsable_id, $tablaGastos.fecha, $tablaGastos.monto, '
        '$tablaCategorias.nombre AS categorias, $tablaResponsables.nombre AS responsables, $tablaVehiculos.placa AS placas '
        'FROM $tablaGastos LEFT JOIN $tablaCategorias ON $tablaGastos.categoria_id = $tablaCategorias.id '
        'LEFT JOIN $tablaVehiculos ON $tablaGastos.vehiculo_id = $tablaVehiculos.id '
        'LEFT JOIN $tablaResponsables ON $tablaGastos.responsable_id = $tablaResponsables.id ';
    List<Map<String, dynamic>> resultado = await _basedatos.rawQuery(consulta);
    return resultado;
  }

  Future<List<Gastos>> getGastosFechas(DateTime fechaInicial, DateTime fechaFinal) async {
  DateTime startOfDayFechaInicial = DateTime(fechaInicial.year, fechaInicial.month, fechaInicial.day, 0, 0, 0);
  DateTime endOfDayFechaFinal = DateTime(fechaFinal.year, fechaFinal.month, fechaFinal.day, 23, 59, 59);

  final List<Map<String, dynamic>> maps = await _basedatos.query(
    BaseDatos.tablaGastos,
    where: 'fecha >= ? AND fecha <= ?',
    whereArgs: [startOfDayFechaInicial.millisecondsSinceEpoch, endOfDayFechaFinal.millisecondsSinceEpoch],
  );

  return List.generate(maps.length, (i) {
    return Gastos(
      vehiculoID: maps[i]['vehiculo_id'], 
      categoria: maps[i]['categoria_id'], 
      responsable: maps[i]['responsable_id'], 
      fecha: maps[i]['fecha'], 
      monto: maps[i]['monto']
    );
  });
}
}