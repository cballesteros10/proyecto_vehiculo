// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Vehiculo {
  int id;
  String placa;
  String modelo;
  String marca;
  String tipo;
  String fecha;
  List<Gastos> gastos;

  Vehiculo({
    required this.id,
    required this.placa,
    required this.modelo,
    required this.marca,
    required this.tipo,
    required this.fecha,
    required this.gastos
  });

  @override
  bool operator ==(covariant Vehiculo other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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
      'gastos' : gastos
    };
  }
}

class Gastos {
  int vehiculoID;
  String descripcion;
  String responsable;
  String fecha;
  double monto;
  
  Gastos({
    required this.vehiculoID,
    required this.descripcion,
    required this.responsable,
    required this.fecha,
    required this.monto,
  });

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
