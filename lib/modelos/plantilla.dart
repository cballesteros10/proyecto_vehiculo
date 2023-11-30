// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';

class Vehiculo {
  late int? id;
  late String placa;
  late String modelo;
  late String marca;
  late String tipo;
  late int fecha;

  Vehiculo({ this.id,
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

    /* final List<Map<String, dynamic>> gastosMapList = map['gastos'] ?? [];

    gastos = gastosMapList.map((g) => Gastos.fromMap(g)).toList(); */
  }

  @override
  bool operator ==(covariant Vehiculo other) {
    if (identical(this, other)) return true;
  
    return 
      other.placa == placa &&
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
      'id' : id,
      'placa' : placa,
      'modelo' : modelo,
      'marca' : marca,
      'tipo' : tipo,
      'fecha' : fecha,
    };
  }
}

class Gastos {
  late int? id;
  late int vehiculoID;
  String? vehiculo_nombre;
  late int categoria;
  String? categoria_nombre;
  late int responsable;
  String? responsable_nombre;
  late int fecha;
  late double monto;
  
  Gastos({
    this.id,
    this.categoria_nombre,
    this.vehiculo_nombre,
    this.responsable_nombre,  
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
      'id' : id,
      'vehiculoID' : vehiculoID,
      'categoria' : categoria,
      'responsable' : responsable,
      'fecha' : fecha,
      'monto' : monto
    };
  }
}

class Categorias {
  late int? id;
  late String nombre;

  Categorias({ this.id,
    required this.nombre,
  });

  Map<String, dynamic> miMapaCategorias() {
    return {
      'id' : id,
      'nombre' : nombre
    };
  }

  @override
  bool operator ==(covariant Categorias other) {
    if (identical(this, other)) return true;
  
    return 
      other.nombre == nombre;
  }

  @override
  int get hashCode => nombre.hashCode;
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
      'id' : id,
      'nombre' : nombre,
      'direccion' : direccion,
      'telefono' : telefono
    };
  }

  @override
  bool operator ==(covariant Responsables other) {
    if (identical(this, other)) return true;
  
    return 
      other.nombre == nombre &&
      other.direccion == direccion &&
      other.telefono == telefono;
  }

  @override
  int get hashCode {
    return 
      nombre.hashCode ^
      direccion.hashCode ^
      telefono.hashCode;
  }
}