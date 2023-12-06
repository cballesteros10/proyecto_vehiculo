// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';

sealed class EstadoVehiculo with EquatableMixin {
  final List<Vehiculo> vehiculos;

  EstadoVehiculo(this.vehiculos);
}

class Cargando extends EstadoCargarVehiculos {
  Cargando(super.vehiculos);

  @override
  List<Object?> get props => [];
}

class EstadoCargarVehiculos extends EstadoVehiculo {
  EstadoCargarVehiculos(super.vehiculos);
  
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

class EventoEditarVehiculo extends EventoVehiculo {
  final String placa;
  final String modelo;
  final String marca;
  final String tipo;
  final String fecha;
  final int vehiculoID;

  EventoEditarVehiculo(this.placa, this.modelo, this.marca, this.tipo, this.fecha, this.vehiculoID);
}

class Inicializo extends EventoVehiculo {}

class BlocVehiculo extends Bloc<EventoVehiculo, EstadoVehiculo> {
  late BaseDatos _base;
   List<Vehiculo> _listaInicial = [];

  BlocVehiculo() : super(Cargando([])) {
    _base = BaseDatos();
    on<Inicializo>((event, emit) async {
      _listaInicial = await _base.getVehiculos();
      emit(EstadoCargarVehiculos(_listaInicial));
    });

    on<EventoAgregarVehiculo>((event, emit) async {
      emit(EstadoCargarVehiculos([]));
      await _base.agregarVehiculo(Vehiculo(
      placa: event.placa, 
      modelo: event.modelo, 
      marca: event.marca, 
      tipo: event.tipo, 
      fecha: int.parse(event.fecha)));
      await _cargarVehiculos(emit);
    });

    on<EventoEliminarVehiculo>((event, emit) async {
      await _base.eliminarVehiculo(event.vehiculoID);
      await _cargarVehiculos(emit);
    });

    on<EventoEditarVehiculo>((event, emit) async {
      await _base.editarVehiculo(
        event.placa, 
        event.modelo, 
        event.marca, 
        event.tipo, 
        int.parse(event.fecha),
        event.vehiculoID);
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
      fecha: int.parse(event.fecha)));
    } else if (event is EventoEliminarVehiculo) {
      await _base.eliminarVehiculo(event.vehiculoID);
    } /* else if (event is EventoAgregarGasto) {
      await _base.agregarGasto(event.vehiculoID, 
      Gastos(event.vehiculoID,
      categoria: [], 
      descripcion: event.descripcion, 
      responsable: [], 
      fecha: event.fecha, 
      monto: event.monto));
    } */
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