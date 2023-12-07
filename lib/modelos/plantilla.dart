class Vehiculo {
  late int? id;
  late String placa;
  late String modelo;
  late String marca;
  late String tipo;
  late int fecha;

  Vehiculo({
    this.id,
    required this.placa,
    required this.modelo,
    required this.marca,
    required this.tipo,
    required this.fecha,
  });

  Vehiculo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    placa = map['placa'];
    modelo = map['modelo'];
    marca = map['marca'];
    tipo = map['tipo'];
    fecha = map['fecha'];
  }

  @override
  bool operator ==(covariant Vehiculo other) {
    if (identical(this, other)) return true;

    return other.placa == placa &&
        other.modelo == modelo &&
        other.marca == marca &&
        other.tipo == tipo &&
        other.fecha == fecha;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        placa.hashCode ^
        modelo.hashCode ^
        marca.hashCode ^
        tipo.hashCode ^
        fecha.hashCode;
  }

  Map<String, dynamic> miMapaVehiculos() {
    return {
      'id': id,
      'placa': placa,
      'modelo': modelo,
      'marca': marca,
      'tipo': tipo,
      'fecha': fecha,
    };
  }
}

class Gastos {
  late int? id;
  late int vehiculoID;
  String? vehiculoNombre;
  late int categoria;
  String? categoriaNombre;
  late int responsable;
  String? responsableNombre;
  late int fecha;
  late double monto;

  Gastos({
    this.id,
    this.categoriaNombre,
    this.vehiculoNombre,
    this.responsableNombre,
    required this.vehiculoID,
    required this.categoria,
    required this.responsable,
    required this.fecha,
    required this.monto,
  });

  Gastos.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    vehiculoID = map['vehiculo_id'];
    categoria = map['categoria_id'];
    responsable = map['responsable_id'];
    fecha = map['fecha'];
    monto = map['monto'];
  }

  Map<String, dynamic> miMapaGastos() {
    return {
      'id': id,
      'vehiculo_id': vehiculoID,
      'categoria_id': categoria,
      'responsable_id': responsable,
      'fecha': fecha,
      'monto': monto
    };
  }

  @override
  String toString() =>
      'Gastos(id: $id, vehiculo_id : $vehiculoID, categoria_id : $categoria, responsable_id: $responsable, fecha: $fecha, monto: $monto )';
}

class Categorias {
  late int? id;
  late String nombre;

  Categorias({
    this.id,
    required this.nombre,
  });

  Map<String, dynamic> miMapaCategorias() {
    return {'id': id, 'nombre': nombre};
  }

  @override
  bool operator ==(covariant Categorias other) {
    if (identical(this, other)) return true;

    return other.nombre == nombre;
  }

  @override
  int get hashCode => nombre.hashCode;

  @override
  String toString() => 'Categorias(id: $id, nombre: $nombre)';
}

class Responsables {
  late int? id;
  late String nombre;
  late String direccion;
  late String telefono;

  Responsables({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });

  Map<String, dynamic> miMapaResponsables() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono
    };
  }

  @override
  bool operator ==(covariant Responsables other) {
    if (identical(this, other)) return true;

    return other.nombre == nombre &&
        other.direccion == direccion &&
        other.telefono == telefono;
  }

  @override
  int get hashCode {
    return nombre.hashCode ^ direccion.hashCode ^ telefono.hashCode;
  }
}