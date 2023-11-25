// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Vehiculo {
  late int? id;
  late String placa;
  late String modelo;
  late String marca;
  late String tipo;
  late String fecha;
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
  late String descripcion;
  late String responsable;
  late String fecha;
  late double monto;
  
  Gastos(
    this.vehiculoID, {
    required this.descripcion,
    required this.responsable,
    required this.fecha,
    required this.monto,
  });

  Gastos.fromMap(Map<String, dynamic> map) {
    vehiculoID = vehiculoID;
    descripcion = map['descripcion'];
    responsable = map['responsable'];
    fecha = map['fecha'];
    monto = map['monto'];
  }

  Map<String, dynamic> miMapaGastos() {
    return {
      'vehiculoID' : vehiculoID,
      'descripcion' : descripcion,
      'responsable' : responsable,
      'fecha' : fecha,
      'monto' : monto
    };
  }
}
