// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Vehiculo {
  late int? id;
  late String placa;
  late String modelo;
  late String marca;
  late String tipo;
  late int fecha;
  late List<Gastos> gastos;

  Vehiculo({ this.id,
    required this.placa,
    required this.modelo,
    required this.marca,
    required this.tipo,
    required this.fecha,
    required this.gastos
  });

  Vehiculo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    placa = map['placa'];
    modelo = map['modelo'];
    marca = map['marca'];
    tipo = map['tipo'];
    fecha = map['fecha'];

    final List<Map<String, dynamic>> gastosMapList = map['gastos'] ?? [];

    gastos = gastosMapList.map((g) => Gastos.fromMap(g)).toList();
  }

  @override
  bool operator ==(covariant Vehiculo other) {
    if (identical(this, other)) return true;
  
    return 
      other.placa == placa &&
      other.modelo == modelo &&
      other.marca == marca &&
      other.tipo == tipo &&
      other.fecha == fecha &&
      listEquals(other.gastos, gastos);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      placa.hashCode ^
      modelo.hashCode ^
      marca.hashCode ^
      tipo.hashCode ^
      fecha.hashCode ^
      gastos.hashCode;
  }

  Map<String, dynamic> miMapaVehiculos() {
    return {
      'id' : id,
      'placa' : placa,
      'modelo' : modelo,
      'marca' : marca,
      'tipo' : tipo,
      'fecha' : fecha,
      'gastos' : gastos.map((g) => g.miMapaGastos()).toList(),
    };
  }
}

class Gastos {
  late int vehiculoID;
  late List<Categorias> categoria;
  late String descripcion;
  late List<Responsables> responsable;
  late String fecha;
  late double monto;
  
  Gastos(
    this.vehiculoID, {
    required this.categoria,
    required this.descripcion,
    required this.responsable,
    required this.fecha,
    required this.monto,
  });

  Gastos.fromMap(Map<String, dynamic> map) {
    vehiculoID = vehiculoID;
    categoria = map['categoria'];
    descripcion = map['descripcion'];
    responsable = map['responsable'];
    fecha = map['fecha'];
    monto = map['monto'];
  }

  Map<String, dynamic> miMapaGastos() {
    return {
      'vehiculoID' : vehiculoID,
      'categoria' : categoria,
      'descripcion' : descripcion,
      'responsable' : responsable,
      'fecha' : fecha,
      'monto' : monto
    };
  }
}

class Categorias {
  late int? id;
  late int? gastoID;
  late String nombre;

  Categorias({ this.id,
    this.gastoID,
    required this.nombre,
  });

  Map<String, dynamic> miMapaCategorias() {
    return {
      'id' : id,
      'gastoID' : gastoID,
      'nombre' : nombre
    };
  }

  @override
  bool operator ==(covariant Categorias other) {
    if (identical(this, other)) return true;
  
    return 
      other.gastoID == gastoID &&
      other.nombre == nombre;
  }

  @override
  int get hashCode => gastoID.hashCode ^ nombre.hashCode;
}

class Responsables {
  late int? id;
  late int? gastoID;
  late String nombre;
  late String direccion;
  late String telefono;
  
  Responsables({
    this.id,
    this.gastoID,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });

  Map<String, dynamic> miMapaResponsables() {
    return {
      'id' : id,
      'gastoID' : gastoID,
      'nombre' : nombre,
      'direccion' : direccion,
      'telefono' : telefono
    };
  }

  @override
  bool operator ==(covariant Responsables other) {
    if (identical(this, other)) return true;
  
    return 
      other.gastoID == gastoID &&
      other.nombre == nombre &&
      other.direccion == direccion &&
      other.telefono == telefono;
  }

  @override
  int get hashCode {
    return gastoID.hashCode ^
      nombre.hashCode ^
      direccion.hashCode ^
      telefono.hashCode;
  }
}