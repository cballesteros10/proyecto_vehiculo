// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';

class EstadoVehiculo {
  final List<Vehiculo> vehiculos;

  EstadoVehiculo({
    required this.vehiculos,
  });
}

/* class EstadoCargarVehiculos extends EstadoVehiculo {
  EstadoCargarVehiculos(List<Vehiculo> vehiculos) : super(vehiculos);
} */

abstract class EventoVehiculo {}

class EventoAgregarVehiculo extends EventoVehiculo {
  final String nombreVehiculo;

  EventoAgregarVehiculo(this.nombreVehiculo);
}

class EventoEliminarVehiculo extends EventoVehiculo {
  final int vehiculoID;

  EventoEliminarVehiculo(this.vehiculoID);
}

class EventoAgregarGasto extends EventoVehiculo {
  final int vehiculoID;
  final String descripcion;
  final String responsable;
  final DateTime fecha;
  final double monto;

  EventoAgregarGasto(
    this.vehiculoID, 
    this.descripcion, 
    this.responsable, 
    this.fecha, 
    this.monto);
}
