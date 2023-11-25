// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';

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
  final String placa;
  final String modelo;
  final String marca;
  final String tipo;
  final String fecha;

  EventoAgregarVehiculo(this.placa, this.modelo, this.marca, this.tipo, this.fecha);
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

  BlocVehiculo() : super(Cargando([])) {
    _base = BaseDatos();
    on<Inicializo>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1), () {
        _cargarVehiculos(emit);
      });
    });

    on<EventoAgregarVehiculo>((event, emit) async {
      emit(EstadoCargarVehiculos([]));
      await _base.agregarVehiculo(Vehiculo(
      placa: event.placa, 
      modelo: event.modelo, 
      marca: event.marca, 
      tipo: event.tipo, 
      fecha: int.parse(event.fecha), 
      gastos: []));
      await _cargarVehiculos(emit);
    });

    on<EventoEliminarVehiculo>((event, emit) async {
      await _base.eliminarVehiculo(event.vehiculoID);
      await _cargarVehiculos(emit);
    });
  }

  Future<void> _cargarVehiculos(Emitter<EstadoVehiculo> emit) async {
    emit(Cargando([]));
    final vehiculos = await _base.getVehiculos();
    emit(EstadoCargarVehiculos(vehiculos));
  }

  Stream<EstadoVehiculo> mapaEventoEstado(EventoVehiculo event) async* {
    if(event is EventoAgregarVehiculo) {
      await _base.agregarVehiculo2(Vehiculo( 
      placa: event.placa, 
      modelo: event.modelo, 
      marca: event.marca, 
      tipo: event.tipo, 
      fecha: int.parse(event.fecha), 
      gastos: []));
    } else if (event is EventoEliminarVehiculo) {
      await _base.eliminarVehiculo(event.vehiculoID);
    } else if (event is EventoAgregarGasto) {
      await _base.agregarGasto(event.vehiculoID, 
      Gastos(event.vehiculoID, 
      descripcion: event.descripcion, 
      responsable: event.responsable, 
      fecha: event.fecha, 
      monto: event.monto));
    }
    yield* _mapaEstado();
  }

  Stream<EstadoVehiculo> _cargarVehiculo() async* {
    final vehiculos = await _base.getVehiculos();
    yield EstadoCargarVehiculos(vehiculos);
  }

  Stream<EstadoVehiculo> _mapaEstado() async* {
    yield* _cargarVehiculo();
  }
}