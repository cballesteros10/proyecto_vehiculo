// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:proyecto_vehiculos/modelos/vehiculos.dart';

class EstadoVehiculo {
  const EstadoVehiculo();
}

class VehiculoInicial extends EstadoVehiculo {}

class VehiculoOperacional extends EstadoVehiculo {
  final List<Vehiculo> listaVehiculos;

  VehiculoOperacional({required this.listaVehiculos});
}

class EventoVehiculo {}

class VehiculoAgregado extends EventoVehiculo {
  final int vehiculoAgregado;

  VehiculoAgregado({required this.vehiculoAgregado});
}

class Agregado extends EventoVehiculo {}

class VehiculoInicializado extends EventoVehiculo {}

class EventoAgregarVehiculo extends EventoVehiculo {
  final List<Vehiculo> listaVehiculos;

  EventoAgregarVehiculo({required this.listaVehiculos});

  @override
  List<Object?> get props => [listaVehiculos];
}

class EventoEliminarVehiculo extends EventoVehiculo {
  String marca;
  String modelo;
  String placa;
  String tipo;
  int fecha;

  EventoEliminarVehiculo({
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.tipo,
    required this.fecha,
  });
}

class EventoEditarVehiculo extends EventoVehiculo {
  String marca;
  String modelo;
  String placa;
  String tipo;
  int fecha;

  EventoEditarVehiculo({
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.tipo,
    required this.fecha,
  });
}

class MiBlocVehiculo extends Bloc<EventoVehiculo, EstadoVehiculo> {
  final List<Vehiculo> _listaVehiculos = [];

  MiBlocVehiculo(): super(VehiculoInicial()) {
    on<VehiculoInicializado>((event, emit) {
      _listaVehiculos.addAll(listaOriginal);
      emit(VehiculoOperacional(
        listaVehiculos: _listaVehiculos));
    },);

    on<Agregado>((event, emit) {
      
    },);
  }
}

  final List<Vehiculo> listaOriginal = [
    Vehiculo(marca: 'Nissan', modelo: 'Versa', placa: 'VGA145A', tipo: 'Carro', fecha: 2023),
  ];