// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
import 'package:proyecto_vehiculos/base.dart';

sealed class EstadoVehiculo with EquatableMixin {
  final List<Vehiculo> vehiculos;

  EstadoVehiculo(this.vehiculos);
}

class Cargando extends EstadoVehiculo {
  Cargando(super.vehiculos);

  @override
  List<Object?> get props => [];
}

class EstadoCargarVehiculos extends EstadoVehiculo {
  EstadoCargarVehiculos(List<Vehiculo> vehiculos) : super(vehiculos);
  
  @override
  List<Object?> get props => [];
}

abstract class EventoVehiculo {}

class EventoAgregarVehiculo extends EventoVehiculo {
  final int id;
  final String placa;
  final String modelo;
  final String marca;
  final String tipo;
  final String fecha;

  EventoAgregarVehiculo(this.id, this.placa, this.modelo, this.marca, this.tipo, this.fecha);
}

class EventoEliminarVehiculo extends EventoVehiculo {
  final int vehiculoID;

  EventoEliminarVehiculo(this.vehiculoID);
}

class Inicializo extends EventoVehiculo {}

class EventoAgregarGasto extends EventoVehiculo {
  final int vehiculoID;
  final String descripcion;
  final String responsable;
  final String fecha;
  final double monto;

  EventoAgregarGasto(
    this.vehiculoID, 
    this.descripcion, 
    this.responsable, 
    this.fecha, 
    this.monto);
}

class BlocVehiculo extends Bloc<EventoVehiculo, EstadoVehiculo> {
  late BaseDatos _base;

  BlocVehiculo() : super(EstadoCargarVehiculos([])) {
    _base = BaseDatos();
    on<Inicializo>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1),() {
        emit(EstadoCargarVehiculos([]));
      });
    });

    on<EventoAgregarVehiculo>((event, emit) {
      emit(EstadoCargarVehiculos([]));
    });
  }

  Stream<EstadoVehiculo> mapaEventoaEstado(EventoVehiculo event) async* {
    if(event is EventoAgregarVehiculo) {
      await _base.agregarVehiculo(Vehiculo(
        event.id, 
        placa: event.placa, 
        modelo: event.modelo, 
        marca: event.marca, 
        tipo: event.tipo, 
        fecha: event.fecha, 
        gastos: []));
    } else if (event is EventoEliminarVehiculo) {
      await _base.eliminarVehiculo(event.vehiculoID);
    } else if (event is EventoAgregarGasto) {
      await _base.agregarGasto(
        event.vehiculoID, 
        Gastos(
          event.vehiculoID, 
          descripcion: event.descripcion, 
          responsable: event.responsable, 
          fecha: event.fecha, 
          monto: event.monto));
    }
    yield EstadoCargarVehiculos(await _base.getVehiculos());
  }
}
