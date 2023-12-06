import 'package:bloc/bloc.dart';
import 'package:MyCarApp/base.dart';
import 'package:MyCarApp/main.dart';
import 'package:MyCarApp/modelos/plantilla.dart';
import 'package:equatable/equatable.dart';
// import 'package:sqflite/sqflite.dart';

abstract class EstadoGasto extends Equatable{
  const EstadoGasto();

  @override
  List<Object?> get props => [];
}

class InicioGasto extends EstadoGasto {}

abstract class EstadoCategoria extends Equatable {
  final List<Categorias> categorias;

  const EstadoCategoria(this.categorias);
}

class InicioCategoria extends EstadoCategoria {
  const InicioCategoria(super.categorias);

  @override
  List<Object?> get props => [];
}

abstract class EstadoResponsable extends Equatable {
  final List<Responsables> responsables;

  const EstadoResponsable(this.responsables);
}

class InicioResponsables extends EstadoResponsable {
  const InicioResponsables(super.responsables);

  @override
  List<Object?> get props => [];
}

class CargandoCategoria extends EstadoCargarCategorias {
  const CargandoCategoria(super.categorias);

  @override
  List<Object?> get props => [];
}

class CargandoResponsable extends EstadoCargarResponsables {
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
  const EstadoCargarCategorias(super.categorias);

  @override
  List<Object?> get props => [categorias];  
}

class EstadoCargarResponsables extends EstadoResponsable {
  const EstadoCargarResponsables(super.responsables);

  @override
  List<Object?> get props => [responsables];
}

class CargarGastos extends EstadoCargarGasto {
  const CargarGastos(super.gastos);

  @override
  List<Object?> get props => [];
}

abstract class EventoGasto extends Equatable {
  const EventoGasto();

  @override
  List<Object?> get props => [];
}

class Inicializo2 extends EventoGasto {}

abstract class EventoCategoria extends Equatable {
  const EventoCategoria();

  @override
  List<Object?> get props => [];
}

class Inicializo3 extends EventoCategoria {}

abstract class EventoResponsable extends Equatable {
  const EventoResponsable();

  @override
  List<Object?> get props => [];
}

class Inicializo4 extends EventoResponsable {}

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

class EventoAgregarGasto2 extends EventoGasto {
  final Gastos gasto;

  const EventoAgregarGasto2({required this.gasto});
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
  final int gastoID;

  const EventoEliminarGasto(this.gastoID);  
}

class EventoEditarGasto extends EventoGasto {
  final Gastos gasto;

  const EventoEditarGasto({required this.gasto});
}

class EventoEliminarCategoria extends EventoCategoria {
  final int categoriaID;

  const EventoEliminarCategoria(this.categoriaID);
}

class EventoEditarCategoria extends EventoCategoria {
  final String nombre;
  final int categoriaID;

  const EventoEditarCategoria(this.nombre, this.categoriaID);
}

class EventoEditarResponsable extends EventoResponsable {
  final String nombre;
  final String direccion;
  final String telefono;
  final int responsableID;

  const EventoEditarResponsable(this.nombre, this.direccion, this.telefono, this.responsableID);
}

class EventoEliminarResponsable extends EventoResponsable {
  final int responsableID;

  const EventoEliminarResponsable(this.responsableID);
}

class GastoBloc extends Bloc<EventoGasto, EstadoGasto> {
  late BaseDatos _base;
  List<Gastos> _listaInicialGastos = [];

  GastoBloc() : super(const CargarGastos([])) {
    _base = BaseDatos();

    on<Inicializo2>((event, emit) async {
      
     final gastos = await _base.consultaGastos();
       _listaInicialGastos = gastos.map((e) {
          return Gastos(
            id: e['id'],
            vehiculo_nombre: e['placas'],
            categoria_nombre: e['categorias'],
            responsable_nombre: e['responsables'],
            vehiculoID: e['vehiculo_id'], 
            categoria: e['categoria_id'], 
            responsable: e['responsable_id'], 
            fecha: e['fecha'], 
            monto: e['monto']);
        }).toList();
      emit(EstadoCargarGasto(_listaInicialGastos));
    });

    on<EventoAgregarGasto2>((event, emit) async {
     _base.agregarGasto2(event.gasto);
     final gastos = await _base.consultaGastos();
     List<Gastos> lista = gastos.map((e) {
          return Gastos(
            id: e['id'],
            vehiculo_nombre: e['placas'],
            categoria_nombre: e['categorias'],
            responsable_nombre: e['responsables'],
            vehiculoID: e['vehiculo_id'], 
            categoria: e['categoria_id'], 
            responsable: e['responsable_id'], 
            fecha: e['fecha'], 
            monto: e['monto']);
        }).toList();
     emit(EstadoCargarGasto(lista)); 
    });

    on<EventoEliminarGasto>((event, emit) async {
      await _base.eliminarGasto(event.gastoID);
      // await _cargarGastos(emit);
      emit(EstadoCargarGasto(gastos));
    });

    on<EventoEditarGasto>((event, emit) async {
      await _base.editarGasto(event.gasto);
      gastos = await _base.editarGasto(event.gasto);
      emit(EstadoCargarGasto(gastos));
      // await _cargarGastos(emit);
    });
  }

  /* Future<void> _cargarGastos(Emitter<EstadoGasto> emit) async {
    emit(CargarGastos([]));
    final gastos = await _base.getGastos();
    emit(EstadoCargarGasto(gastos));
  } */
}

class CategoriaBloc extends Bloc<EventoCategoria, EstadoCategoria> {
  late BaseDatos _base;
  List<Categorias> _listaInicialCategorias = [];

  CategoriaBloc() : super(const CargandoCategoria([])) {
    _base = BaseDatos();

  on<Inicializo3>((event, emit) async {
    _listaInicialCategorias = await _base.getCategorias();
    emit(EstadoCargarCategorias(_listaInicialCategorias));
  });

  on<EventoAgregarCategoria>((event, emit) async {
      emit(const EstadoCargarCategorias([]));
      await _base.agregarCategoria2(Categorias(
        nombre: event.nombre));
      await _cargarCategorias(emit);
  });

  on<EventoEliminarCategoria>((event, emit) async {
      await _base.eliminarCategoria(event.categoriaID);
      await _cargarCategorias(emit);
    });

    on<EventoEditarCategoria>((event, emit) async {
      await _base.editarCategoria(
        event.nombre, 
        event.categoriaID);
      await _cargarCategorias(emit);      
    });
}

  Future<void> _cargarCategorias(Emitter<EstadoCategoria> emit) async {
    emit(const CargandoCategoria([]));
    final categorias = await _base.getCategorias();
    emit(EstadoCargarCategorias(categorias));
  }

  /* Stream<EstadoCategoria> mapaEventoEstado(EventoCategoria event) async* {
    if(event is EventoAgregarCategoria) {
      await _base.agregarCategoria(Categorias(
        nombre: event.nombre));
    } 
    yield* _mapaEstado2();
  } */

  /* Stream<EstadoCategoria> _cargarCategoria() async* {
    final categorias = await _base.getCategorias();
    yield EstadoCargarCategorias(categorias);
  }

  Stream<EstadoCategoria> _mapaEstado2() async* {
    yield* _cargarCategoria();
  } */
}

class ResponsableBloc extends Bloc<EventoResponsable, EstadoResponsable> {
  late BaseDatos _base;
  List<Responsables> _listaInicialResponsables = [];

  ResponsableBloc() : super(const CargandoResponsable([])) {
    _base = BaseDatos();

    on<Inicializo4>((event, emit) async {
      _listaInicialResponsables = await _base.getResponsables();
      emit(EstadoCargarResponsables(_listaInicialResponsables));
    });

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

    on<EventoEditarResponsable>((event, emit) async {
      await _base.editarResponsable(
        event.nombre, 
        event.direccion, 
        event.telefono, 
        event.responsableID);
      await _cargarResponsables(emit);
    });
}

Future<void> _cargarResponsables(Emitter<EstadoResponsable> emit) async {
    emit(const CargandoResponsable([]));
    final responsables = await _base.getResponsables();
    emit(EstadoCargarResponsables(responsables));
  }

  /* Stream<EstadoResponsable> mapaEventoEstado(EventoResponsable event) async* {
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
  } */
}