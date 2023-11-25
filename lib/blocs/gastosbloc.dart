import 'package:bloc/bloc.dart';
import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
import 'package:equatable/equatable.dart';

abstract class EstadoGasto extends Equatable{
  const EstadoGasto();

  @override
  List<Object?> get props => [];
}

class EstadoCargarGasto extends EstadoGasto {
  final List<Gastos> gastos;

  const EstadoCargarGasto(this.gastos);

  @override
  List<Object?> get props => [gastos];  
}

class CargarGastos extends EstadoGasto {
  @override
  List<Object?> get props => [];
}

abstract class EventoGasto extends Equatable {
  const EventoGasto();

  @override
  List<Object?> get props => [];
}

class EventoAgregarGasto extends EventoGasto {
  final int vehiculoID;
  final String descripcion;
  final String responsable;
  final String fecha;
  final double monto;

  const EventoAgregarGasto(this.vehiculoID, this.descripcion, this.responsable, this.fecha, this.monto);

  @override
  List<Object?> get props => [vehiculoID, descripcion, responsable, fecha, monto];
}

class EventoEliminarGasto extends EventoGasto {
  final int vehiculoID;

  const EventoEliminarGasto(this.vehiculoID);  
}

class GastoBloc extends Bloc<EventoGasto, EstadoGasto> {
  late BaseDatos _base;

  GastoBloc() : super(CargarGastos()) {
    on<EventoAgregarGasto>((event, emit) async {
      emit(CargarGastos());
      await _base.agregarGasto(
        event.vehiculoID, 
        Gastos(
          event.vehiculoID, 
          descripcion: event.descripcion, 
          responsable: event.responsable, 
          fecha: event.fecha, 
          monto: event.monto));
        final gastos = await _base.getGastosPorVehiculos(event.vehiculoID);
        emit(EstadoCargarGasto(gastos));      
    });
  }
}