import 'package:bloc/bloc.dart';

class EstadoVehiculo {

}

abstract class EventoVehiculo {
  const EventoVehiculo();
}

class VehiculoInicializado extends EventoVehiculo {

}

class EventoAgregarVehiculo extends EventoVehiculo {

}

class EventoEliminarVehiculo extends EventoVehiculo {

}

class EventoEditarVehiculo extends EventoVehiculo {

}