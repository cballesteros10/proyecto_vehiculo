import 'package:bloc/bloc.dart';
import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
import 'package:equatable/equatable.dart';

abstract class EstadoGasto extends Equatable{
  const EstadoGasto();

  @override
  List<Object?> get props => [];
}

abstract class EstadoCategoria extends Equatable {
  final List<Categorias> categorias;

  const EstadoCategoria(this.categorias);
}

class Cargando extends EstadoCategoria {
  const Cargando(super.categorias);

  @override
  List<Object?> get props => [];
}

class EstadoCargarGasto extends EstadoGasto {
  final List<Gastos> gastos;

  const EstadoCargarGasto(this.gastos);

  @override
  List<Object?> get props => [gastos];  
}

class EstadoCargarCategorias extends EstadoCategoria {
  const EstadoCargarCategorias(List<Categorias> categorias) : super(categorias);

  @override
  List<Object?> get props => [categorias];  
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

abstract class EventoCategoria extends Equatable {
  const EventoCategoria();

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

class EventoAgregarCategoria extends EventoCategoria {
  final String nombre;

  const EventoAgregarCategoria(this.nombre);
}

class EventoEliminarGasto extends EventoGasto {
  final int vehiculoID;

  const EventoEliminarGasto(this.vehiculoID);  
}

class EventoEliminarCategoria extends EventoCategoria {
  final int categoriaID;

  const EventoEliminarCategoria(this.categoriaID);
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
          categoria: [], 
          descripcion: event.descripcion, 
          responsable: [], 
          fecha: event.fecha, 
          monto: event.monto));
        final gastos = await _base.getGastosPorVehiculos(event.vehiculoID);
        emit(EstadoCargarGasto(gastos));      
    });
  }
}

class CategoriaBloc extends Bloc<EventoCategoria, EstadoCategoria> {
  late BaseDatos _base;

  CategoriaBloc() : super(const Cargando([])) {
  on<EventoAgregarCategoria>((event, emit) async {
    try {
      await _base.agregarCategoria2(Categorias(nombre: event.nombre));
      await _cargarCategorias(emit);
    } catch (error) {
      print('Error al agregar categoría: $error');
    }
  });
}


  Future<void> _cargarCategorias(Emitter<EstadoCategoria> emit) async {
    emit(const Cargando([]));
    final categorias = await _base.getCategorias();
    emit(EstadoCargarCategorias(categorias));
  }

  Stream<EstadoCategoria> mapaEventoEstado(EventoCategoria event) async* {
    if(event is EventoAgregarCategoria) {
      await _base.agregarCategoria(Categorias(
        nombre: event.nombre));
    } 
    yield* _mapaEstado2();
  }

  Stream<EstadoCategoria> _cargarCategoria() async* {
    final categorias = await _base.getCategorias();
    yield EstadoCargarCategorias(categorias);
  }

  Stream<EstadoCategoria> _mapaEstado2() async* {
    yield* _cargarCategoria();
  }
}