import 'package:equatable/equatable.dart';

class Vehiculo with EquatableMixin {
  final String marca;
  final String modelo;
  final String placa;
  final String tipo;
  final int fecha;

  Vehiculo({
    required this.marca, 
    required this.modelo, 
    required this.placa, 
    required this.tipo, 
    required this.fecha});

  @override
  String toString() => 'Vehiculo(marca: $marca, modelo: $modelo, placa: $placa, tipo: $tipo, fecha: $fecha)';
  
  @override
  List<Object?> get props => [marca, modelo, placa, tipo, fecha];
}