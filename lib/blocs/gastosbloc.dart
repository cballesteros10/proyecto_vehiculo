import 'package:bloc/bloc.dart';
import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
import 'package:equatable/equatable.dart';
// import 'package:sqflite/sqflite.dart';

abstract class EstadoGasto extends Equatable{
  const EstadoGasto();

  @override
  List<Object?> get props => [];
}

abstract class EstadoCategoria extends Equatable {
  final List<Categorias> categorias;

  const EstadoCategoria(this.categorias);
}

abstract class EstadoResponsable extends Equatable {
  final List<Responsables> responsables;

  const EstadoResponsable(this.responsables);
}

class CargandoCategoria extends EstadoCategoria {
  const CargandoCategoria(super.categorias);

  @override
  List<Object?> get props => [];
}

class CargandoResponsable extends EstadoResponsable {
  const CargandoResponsable(super.responsables);

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

class EstadoCargarResponsables extends EstadoResponsable {
  const EstadoCargarResponsables(List<Responsables> responsables) : super(responsables);

  @override
  List<Object?> get props => [responsables];
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

abstract class EventoResponsable extends Equatable {
  const EventoResponsable();

  @override
  List<Object?> get props => [];
}

class EventoAgregarGasto extends EventoGasto {
  final int vehiculoID;
  final int categoria;
  final int responsable;
  final int fecha;
  final double monto;

  const EventoAgregarGasto(this.vehiculoID, this.categoria, this.responsable, this.fecha, this.monto);

  @override
  List<Object?> get props => [vehiculoID, categoria, responsable, fecha, monto];
}

class EventoAgregarCategoria extends EventoCategoria {
  final String nombre;

  const EventoAgregarCategoria(this.nombre);
}

class EventoAgregarResponsable extends EventoResponsable {
  final String nombre;
  final String direccion;
  final String telefono;

  const EventoAgregarResponsable(this.nombre, this.direccion, this.telefono);
}

class EventoEliminarGasto extends EventoGasto {
  final int vehiculoID;

  const EventoEliminarGasto(this.vehiculoID);  
}

class EventoEliminarCategoria extends EventoCategoria {
  final int categoriaID;

  const EventoEliminarCategoria(this.categoriaID);
}

class EventoEliminarResponsable extends EventoResponsable {
  final int responsableID;

  const EventoEliminarResponsable(this.responsableID);
}

class GastoBloc extends Bloc<EventoGasto, EstadoGasto> {
  late BaseDatos _base;

  GastoBloc() : super(CargarGastos()) {
    _base = BaseDatos();
    
    on<EventoAgregarGasto>((event, emit) async {
        final gastos = await _base.consultaGastos();
        List<Gastos> lista = gastos.map((e) {
          return Gastos(
            id: e['id'],
            vehiculoID: e['vehiculo_id'], 
            categoria: e['categoria_id'], 
            responsable: e['responsable_id'], 
            fecha: e['fecha'], 
            monto: e['monto']);
        }).toList();
        emit(EstadoCargarGasto(lista));  
          await _base.agregarGasto(
            Gastos(
            vehiculoID: event.vehiculoID, 
            categoria: event.categoria, 
            responsable: event.responsable, 
            fecha: event.fecha, 
            monto: event.monto));    
    });
  }
}

class CategoriaBloc extends Bloc<EventoCategoria, EstadoCategoria> {
  late BaseDatos _base;

  CategoriaBloc() : super(const CargandoCategoria([])) {
    _base = BaseDatos();

  on<EventoAgregarCategoria>((event, emit) async {
      emit(const EstadoCargarCategorias([]));
      await _base.agregarCategoria2(Categorias(
        nombre: event.nombre));
      await _cargarCategorias(emit);
  });

  on<EventoEliminarCategoria>((event, emit) async {
      await _base.eliminarCategotia(event.categoriaID);
      await _cargarCategorias(emit);
    });
}

  Future<void> _cargarCategorias(Emitter<EstadoCategoria> emit) async {
    emit(const CargandoCategoria([]));
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

class ResponsableBloc extends Bloc<EventoResponsable, EstadoResponsable> {
  late BaseDatos _base;

  ResponsableBloc() : super(const CargandoResponsable([])) {
    _base = BaseDatos();

  on<EventoAgregarResponsable>((event, emit) async {
      await _base.agregarResponsable(Responsables(
        nombre: event.nombre, 
        direccion: event.direccion, 
        telefono: event.telefono));
      await _cargarResponsables(emit);
  });

  on<EventoEliminarResponsable>((event, emit) async {
      await _base.eliminarResponsable(event.responsableID);
      await _cargarResponsables(emit);
    });
}

Future<void> _cargarResponsables(Emitter<EstadoResponsable> emit) async {
    emit(const CargandoResponsable([]));
    final responsables = await _base.getResponsables();
    emit(EstadoCargarResponsables(responsables));
  }

  Stream<EstadoResponsable> mapaEventoEstado(EventoResponsable event) async* {
    if(event is EventoAgregarResponsable) {
      await _base.agregarCategoria(Categorias(
        nombre: event.nombre));
    } 
    yield* _mapaEstado3();
  }

  Stream<EstadoResponsable> _cargarResponsable() async* {
    final responsables = await _base.getResponsables();
    yield EstadoCargarResponsables(responsables);
  }

  Stream<EstadoResponsable> _mapaEstado3() async* {
    yield* _cargarResponsable();
  }
}