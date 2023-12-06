// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_vehiculos/blocs/gastosbloc.dart';
import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/blocs/vehiculobloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await BaseDatos().initDatabase();
  runApp(const MiApp());
}

List<Categorias> categorias = [];

List<Vehiculo> vehiculos = [];

List<Responsables> responsablessss = [];

List<Gastos> gastos = [];

class AplicacionInyectada extends StatelessWidget {
  const AplicacionInyectada({super.key});

  @override
  Widget build(BuildContext context) {
    // BaseDatos _base = BaseDatos();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlocVehiculo()..add(Inicializo()),
        ),
        BlocProvider(
          create: (context) => GastoBloc()..add(Inicializo2()),
        ),
        BlocProvider(
          create: (context) => CategoriaBloc()..add(Inicializo3()),
        ),
        BlocProvider(
          create: (context) => ResponsableBloc()..add(Inicializo4()),
        ),
      ],
      child: const MainApp(),
    );
  }
}

class MiApp extends StatefulWidget {
  const MiApp({super.key});

  @override
  State<MiApp> createState() => _MiAppState();
}

class _MiAppState extends State<MiApp> {
  final _vehiculoBloc = BlocVehiculo();
  final _gastoBloc = GastoBloc();
  final _categoriaBloc = CategoriaBloc();
  final _responsableBloc = ResponsableBloc();

  @override
  void initState() {
    super.initState();

    _vehiculoBloc.add(Inicializo());
    _gastoBloc.add(Inicializo2());
    _categoriaBloc.add(Inicializo3());
    _responsableBloc.add(Inicializo4());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _vehiculoBloc),
        BlocProvider.value(value: _gastoBloc),
        BlocProvider.value(value: _categoriaBloc),
        BlocProvider.value(value: _responsableBloc),
      ],
      child: const MainApp(),
    );
  }

  @override
  void dispose() {
    _vehiculoBloc.close();
    _gastoBloc.close();
    _categoriaBloc.close();
    _responsableBloc.close();
    super.dispose();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'MyCarApp',
        debugShowCheckedModeBanner: false,
        home: Scaffold(appBar: MiAppBar(), body: TabsRemix()));
  }
}

class MiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MiAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("MyCarApp"),
      leading: const Ayuda(),
      flexibleSpace: const Degradado(),
      centerTitle: true,
      actions: const <Widget>[
        Detalles(),
      ],
    );
  }
}

class Detalles extends StatelessWidget {
  const Detalles({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Categorías') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ListaCategorias()));
        } else if (value == 'Responsables') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ListaResponsables()));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Categorías',
          child: ListTile(
            title: Text('Categorías'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Responsables',
          child: ListTile(
            title: Text('Responsables'),
          ),
        ),
      ],
    );
  }
}

class ListaCategorias extends StatefulWidget {
  const ListaCategorias({super.key});

  @override
  State<ListaCategorias> createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4C60AF),
                Color.fromARGB(255, 37, 195, 248),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // No shadow
            title: const Text(
              'Categorías',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CategoriaBloc, EstadoCategoria>(
        builder: (context, state) {
          if (state is EstadoCargarCategorias) {
            categorias = state.categorias;
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoriaSeleccionada = categorias[index];
                final categoriaID = categoriaSeleccionada.id;

                final bool mostrarIconButtons = categoriaID != -1;
                return Card(
                  child: ListTile(
                    title: Text(categoriaSeleccionada.nombre),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (mostrarIconButtons)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editarCategoria(context, categoriaSeleccionada);
                            },
                          ),
                        if (mostrarIconButtons)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: const Text(
                                        '¿Está seguro de eliminar esta categoria? Se eliminará de forma permanente.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text('Eliminar'),
                                        onPressed: () {
                                          if (categoriaSeleccionada.id !=
                                              null) {
                                            context.read<CategoriaBloc>().add(
                                                EventoEliminarCategoria(
                                                    categoriaSeleccionada.id!));
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No hay categorias registradas :('));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar categoria'),
        icon: const Icon(Icons.add_box_rounded),
        onPressed: () {
          mostrarAgregarCategoria(context);
        },
      ),
    );
  }
}

void editarCategoria(BuildContext context, Categorias categorias) {
  TextEditingController controladorNombreE = TextEditingController();
  controladorNombreE.text = categorias.nombre;
  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<bool> validarCategoriaNoRegistrada(String nombre) async {
    final categoriaRegistrada = await BaseDatos().todasLasCategorias();
    return !categoriaRegistrada.contains(nombre.toUpperCase());
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Editar Categoría'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controladorNombreE,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  final newText = capitalize(value);
                  if (value != newText) {
                    controladorNombreE.value =
                        controladorNombreE.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Nombre', prefixIcon: Icon(Icons.abc)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final nombreCategoria = controladorNombreE.text;
                      if (!validarCampo(context, nombreCategoria)) {
                        return;
                      }

                      bool categoriaNoRegistrada =
                          await validarCategoriaNoRegistrada(nombreCategoria);
                      if (!categoriaNoRegistrada) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Categoría ya registrada'),
                              content: const Text('Ingrese otra categoría.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }
                      context.read<CategoriaBloc>().add(EventoEditarCategoria(
                          controladorNombreE.text, categorias.id!));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ListaResponsables extends StatefulWidget {
  const ListaResponsables({super.key});

  @override
  State<ListaResponsables> createState() => _ListaResponsablesState();
}

class _ListaResponsablesState extends State<ListaResponsables> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4C60AF),
                Color.fromARGB(255, 37, 195, 248),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Responsables',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ResponsableBloc, EstadoResponsable>(
        builder: (context, state) {
          if (state is EstadoCargarResponsables) {
            responsablessss = state.responsables;
            return ListView.builder(
              itemCount: responsablessss.length,
              itemBuilder: (context, index) {
                final responsableSeleccionado = responsablessss[index];
                final responsableID = responsableSeleccionado.id;

                final bool mostrarIconButtons = responsableID != -1;
                return Card(
                  child: ListTile(
                    title: Text(responsableSeleccionado.nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(responsableSeleccionado.direccion),
                        Text(responsableSeleccionado.telefono),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (mostrarIconButtons)
                          IconButton(
                              onPressed: () {
                                editarResponsable(
                                    context, responsableSeleccionado);
                              },
                              icon: const Icon(Icons.edit)),
                        if (mostrarIconButtons)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: const Text(
                                        '¿Está seguro de eliminar este responsable? Se eliminara de forma permanente.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text('Eliminar'),
                                        onPressed: () {
                                          context.read<ResponsableBloc>().add(
                                              EventoEliminarResponsable(
                                                  responsableSeleccionado.id!));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
              child: Text('No hay responsables registrados :('));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar responsable'),
        icon: const Icon(Icons.add_box_rounded),
        onPressed: () {
          mostrarAgregarResponsable(context);
        },
      ),
    );
  }
}

void editarResponsable(BuildContext context, Responsables responsables) {
  TextEditingController controladorNombreE = TextEditingController();
  TextEditingController controladorDireccionE = TextEditingController();
  TextEditingController controladorTelefonoE = TextEditingController();
  controladorDireccionE.text = responsables.direccion;
  controladorNombreE.text = responsables.nombre;
  controladorTelefonoE.text = responsables.telefono;
  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<bool> validarResponsableNoRegistrado(String telefono) async {
    final responsableRegistrado = await BaseDatos().todasLosResponsables();
    return !responsableRegistrado.contains(telefono.toUpperCase());
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Editar Responsable'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controladorNombreE,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  final newText = capitalize(value);
                  if (value != newText) {
                    controladorNombreE.value =
                        controladorNombreE.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.account_circle)),
              ),
              TextField(
                controller: controladorDireccionE,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  final newText = capitalize(value);
                  if (value != newText) {
                    controladorDireccionE.value =
                        controladorDireccionE.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Direccion',
                    prefixIcon: Icon(Icons.location_on)),
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: controladorTelefonoE,
                decoration: const InputDecoration(
                    labelText: 'Telefono', prefixIcon: Icon(Icons.local_phone)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final nombreResponsable = controladorNombreE.text;
                      final direccionResponsable = controladorDireccionE.text;
                      final telefonoResponsable = controladorTelefonoE.text;

                      bool responsableNoRegistrado =
                          await validarResponsableNoRegistrado(
                              telefonoResponsable);
                      if (!responsableNoRegistrado) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Responsable ya registrado'),
                              content: const Text('Ingrese otro responsable.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      if (nombreResponsable.isNotEmpty &&
                          direccionResponsable.isNotEmpty &&
                          telefonoResponsable.isNotEmpty) {
                        context.read<ResponsableBloc>().add(
                            EventoEditarResponsable(
                                nombreResponsable,
                                direccionResponsable,
                                telefonoResponsable,
                                responsables.id!));
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void mostrarAgregarCategoria(BuildContext context) {
  TextEditingController controladorNombre = TextEditingController();
  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<bool> validarCategoriaNoRegistrada(String nombre) async {
    final categoriaRegistrada = await BaseDatos().todasLasCategorias();
    return !categoriaRegistrada.contains(nombre.toUpperCase());
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Nueva Categoría'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controladorNombre,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  final newText = capitalize(value);
                  if (value != newText) {
                    controladorNombre.value = controladorNombre.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Nombre', prefixIcon: Icon(Icons.abc)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final nombreCategoria = controladorNombre.text;
                      if (!validarCampo(context, nombreCategoria)) {
                        return;
                      }

                      bool categoriaNoRegistrada =
                          await validarCategoriaNoRegistrada(nombreCategoria);
                      if (!categoriaNoRegistrada) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Categoría ya registrada'),
                              content: const Text('Ingrese otra categoría.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      context
                          .read<CategoriaBloc>()
                          .add(EventoAgregarCategoria(nombreCategoria));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Agregar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void mostrarAgregarResponsable(BuildContext context) {
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorDireccion = TextEditingController();
  TextEditingController controladorTelefono = TextEditingController();
  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<bool> validarResponsableNoRegistrado(String telefono) async {
    final responsableRegistrado = await BaseDatos().todasLosResponsables();
    return !responsableRegistrado.contains(telefono.toUpperCase());
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Nuevo Responsable'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controladorNombre,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  final newText = capitalize(value);
                  if (value != newText) {
                    controladorNombre.value = controladorNombre.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.account_circle)),
              ),
              TextField(
                controller: controladorDireccion,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  final newText = capitalize(value);
                  if (value != newText) {
                    controladorDireccion.value =
                        controladorDireccion.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Direccion',
                    prefixIcon: Icon(Icons.location_on)),
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: controladorTelefono,
                decoration: const InputDecoration(
                    labelText: 'Telefono', prefixIcon: Icon(Icons.local_phone)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final nombreResponsable = controladorNombre.text;
                      final direccionResponsable = controladorDireccion.text;
                      final telefonoResponsable = controladorTelefono.text;

                      bool responsableNoRegistrado =
                          await validarResponsableNoRegistrado(
                              telefonoResponsable);
                      if (!responsableNoRegistrado) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Responsable ya registrado'),
                              content: const Text('Ingrese otro responsable.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      if (nombreResponsable.isNotEmpty &&
                          direccionResponsable.isNotEmpty &&
                          telefonoResponsable.isNotEmpty) {
                        context.read<ResponsableBloc>().add(
                            EventoAgregarResponsable(nombreResponsable,
                                direccionResponsable, telefonoResponsable));
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Agregar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class Degradado extends StatelessWidget {
  const Degradado({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4C60AF),
            Color.fromARGB(255, 37, 195, 248),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class Ayuda extends StatelessWidget {
  const Ayuda({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('¿Cómo usar la app?'),
              content: const SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'MyCarApp es una app capaz de llevar registro de tus autos y los gastos que hagas en ellos.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Para empezar, haz clic en el botón "Agregar vehículo" ubicado en la esquina inferior derecha de la pestaña "Vehículos" para añadir cualquiera de tus vehículos que quieras monitorear a la app. Una vez agregado, se verá reflejado en una lista en la pantalla principal.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Para llevar el monitoreo de tus gastos, haz clic en el botón "Agregar gasto" para añadir las siguientes características de tus gastos; categoría, a qué vehículo corresponde, una pequeña descripción, la fecha en la que lo realizaste y el monto que gastó.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Las características de Categorías y Responsables las puedes editar tu mismo. Si te diriges a la esquina superior derecha de la aplicación, puedes encontrar las pestañas que te permitirán añadir, editar o eliminar cualquiera.',
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TabsRemix extends StatefulWidget {
  const TabsRemix({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabsRemixState createState() => _TabsRemixState();
}

class _TabsRemixState extends State<TabsRemix>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: const Color.fromARGB(255, 112, 65, 197),
              labelColor: const Color.fromARGB(255, 0, 140, 255),
              unselectedLabelColor: const Color.fromARGB(255, 155, 155, 155),
              tabs: const [
                Tab(text: 'Vehículos'),
                Tab(text: 'Gastos'),
                Tab(text: 'Consultas'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Center(child: ListaVehiculos()),
                  Center(child: ListaGastos()),
                  Center(child: ListaConsultas()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ListaVehiculos extends StatefulWidget {
  const ListaVehiculos({super.key});

  @override
  State<ListaVehiculos> createState() => _ListaVehiculosState();
}

class _ListaVehiculosState extends State<ListaVehiculos> {
  final TextEditingController _searchController = TextEditingController();
  List<Vehiculo> vehiculosFiltrados = [];

  @override
  Widget build(BuildContext context) {
    var estado = context.watch<GastoBloc>().state;
     gastos = (estado as EstadoCargarGasto).gastos;
     var estadoCategoria = context.watch<CategoriaBloc>().state;
     categorias = (estadoCategoria as EstadoCargarCategorias).categorias;
     var estadoResponsables = context.watch<ResponsableBloc>().state;
     responsablessss = (estadoResponsables as EstadoCargarResponsables).responsables;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar vehículo...',
                prefixIcon: const Icon(Icons.search),
                suffixText: 'Vehículos: ${vehiculosFiltrados.length}',
                suffixStyle: const TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                setState(() {
                  vehiculosFiltrados = vehiculos
                      .where((vehiculo) =>
                          vehiculo.placa
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          vehiculo.modelo
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          vehiculo.marca
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          vehiculo.tipo
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          vehiculo.fecha
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          BlocBuilder<BlocVehiculo, EstadoVehiculo>(
            builder: (context, state) {
              if (state is EstadoCargarVehiculos) {
                vehiculos = state.vehiculos;

                final List<Vehiculo> vehiculosToDisplay =
                    vehiculosFiltrados.isNotEmpty
                        ? vehiculosFiltrados
                        : vehiculos;

                return Expanded(
                  child: ListView.builder(
                    itemCount: vehiculosToDisplay.length,
                    itemBuilder: (context, index) {
                      final vehiculo = vehiculosToDisplay[index];
                      context.read<GastoBloc>().add(Inicializo2());
                      context.read<CategoriaBloc>().add(Inicializo3());
                      context.read<ResponsableBloc>().add(Inicializo4());
                      return Card(
                        child: ListTile(
                          title: Text(
                              '${vehiculo.id}. ${vehiculo.placa} - ${vehiculo.modelo} ${vehiculo.fecha}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vehiculo.marca),
                              Text(vehiculo.tipo),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  editarVehiculo(context, vehiculo);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Confirmar eliminación'),
                                        content: const Text(
                                            '¿Está seguro de eliminar este vehículo? Se eliminara de forma permanente.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text('Eliminar'),
                                            onPressed: () {
                                              context.read<BlocVehiculo>().add(
                                                  EventoEliminarVehiculo(
                                                      vehiculo.id!));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          agregarVehiculos(context);
        },
      ),
    );
  }
}

void editarVehiculo(BuildContext context, Vehiculo vehiculo) {
  TextEditingController controladorPlacaE = TextEditingController();
  TextEditingController controladorModeloE = TextEditingController();
  TextEditingController controladorMarcaE = TextEditingController();
  TextEditingController controladorTipoE = TextEditingController();
  TextEditingController controladorFechaE = TextEditingController();
  controladorPlacaE.text = vehiculo.placa;
  controladorModeloE.text = vehiculo.modelo;
  controladorMarcaE.text = vehiculo.marca;
  controladorTipoE.text = vehiculo.tipo;
  controladorFechaE.text = vehiculo.fecha.toString();

  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar Vehiculo'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: controladorPlacaE,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: const InputDecoration(
                        labelText: 'Placa', prefixIcon: Icon(Icons.rectangle)),
                  ),
                  TextField(
                    controller: controladorModeloE,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      final newText = capitalize(value);
                      if (value != newText) {
                        controladorModeloE.value =
                            controladorModeloE.value.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Modelo',
                      hintText: 'Versa, Corolla, etc...',
                      prefixIcon: Icon(Icons.car_rental),
                    ),
                  ),
                  TextField(
                    controller: controladorMarcaE,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      final newText = capitalize(value);
                      if (value != newText) {
                        controladorMarcaE.value =
                            controladorMarcaE.value.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Marca',
                        hintText: 'Nissan, Toyota, etc...',
                        prefixIcon: Icon(Icons.check)),
                  ),
                  TextField(
                    controller: controladorTipoE,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      final newText = capitalize(value);
                      if (value != newText) {
                        controladorTipoE.value =
                            controladorTipoE.value.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Tipo',
                        hintText: 'Carro, camioneta, etc...',
                        prefixIcon: Icon(Icons.local_shipping_outlined)),
                  ),
                  seleccionadorAnio(context, controladorFechaE),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!validarCampo(context, controladorPlacaE.text) ||
                      !validarCampo(context, controladorModeloE.text) ||
                      !validarCampo(context, controladorMarcaE.text) ||
                      !validarCampo(context, controladorTipoE.text) ||
                      !validarCampo(context, controladorFechaE.text)) {
                    return;
                  }
                  context.read<BlocVehiculo>().add(EventoEditarVehiculo(
                      controladorPlacaE.text,
                      controladorModeloE.text,
                      controladorMarcaE.text,
                      controladorTipoE.text,
                      controladorFechaE.text,
                      vehiculo.id!));
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

void selectYear(BuildContext context, TextEditingController controller) async {
  int? selectedYear = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Selecciona el año'),
        content: SizedBox(
          width: 200.0,
          height: 400,
          child: YearPicker(
            firstDate: DateTime(DateTime.now().year - 70),
            lastDate: DateTime(DateTime.now().year + 1),
            selectedDate: DateTime.now(),
            onChanged: (DateTime year) {
              Navigator.of(context).pop(year.year);
            },
          ),
        ),
      );
    },
  );

  if (selectedYear != null) {
    controller.text = '$selectedYear';
  }
}

Widget seleccionadorAnio(
    BuildContext context, TextEditingController controller) {
  return TextFormField(
    readOnly: true,
    onTap: () => selectYear(context, controller),
    decoration: const InputDecoration(
      labelText: 'Año',
      prefixIcon: Icon(Icons.calendar_today),
    ),
    controller: controller,
  );
}

void agregarVehiculos(BuildContext context) {
  TextEditingController controladorPlaca = TextEditingController();
  TextEditingController controladorModelo = TextEditingController();
  TextEditingController controladorMarca = TextEditingController();
  TextEditingController controladorTipo = TextEditingController();
  TextEditingController controladorFecha = TextEditingController();
  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<bool> validarPlacaNoRegistrada(String placa) async {
    final placaRegistrada = await BaseDatos().todosLosNombres();
    return !placaRegistrada.contains(placa.toUpperCase());
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Agregar Vehiculo'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: controladorPlaca,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: const InputDecoration(
                        labelText: 'Placa', prefixIcon: Icon(Icons.rectangle)),
                  ),
                  TextField(
                    controller: controladorModelo,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      final newText = capitalize(value);
                      if (value != newText) {
                        controladorModelo.value =
                            controladorModelo.value.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Modelo',
                      hintText: 'Versa, Corolla, etc...',
                      prefixIcon: Icon(Icons.car_rental),
                    ),
                  ),
                  TextField(
                    controller: controladorMarca,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      final newText = capitalize(value);
                      if (value != newText) {
                        controladorMarca.value =
                            controladorMarca.value.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Marca',
                        hintText: 'Nissan, Toyota, etc...',
                        prefixIcon: Icon(Icons.check)),
                  ),
                  TextField(
                    controller: controladorTipo,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      final newText = capitalize(value);
                      if (value != newText) {
                        controladorTipo.value = controladorTipo.value.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Tipo',
                        hintText: 'Carro, camioneta, etc...',
                        prefixIcon: Icon(Icons.local_shipping_outlined)),
                  ),
                  seleccionadorAnio(context, controladorFecha),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final placaVehiculo = controladorPlaca.text;
                  final modeloVehiculo = controladorModelo.text;
                  final marcaVehiculo = controladorMarca.text;
                  final tipoVehiculo = controladorTipo.text;
                  final fechaVehiculo = controladorFecha.text;

                  if (!validarCampo(context, placaVehiculo) ||
                      !validarCampo(context, modeloVehiculo) ||
                      !validarCampo(context, marcaVehiculo) ||
                      !validarCampo(context, tipoVehiculo) ||
                      !validarCampo(context, fechaVehiculo)) {
                    return;
                  }

                  bool placaNoRegistrada =
                      await validarPlacaNoRegistrada(placaVehiculo);
                  if (!placaNoRegistrada) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Placa ya registrada'),
                          content: const Text('Ingrese otra placa.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  if (placaVehiculo.isNotEmpty &&
                      modeloVehiculo.isNotEmpty &&
                      marcaVehiculo.isNotEmpty &&
                      tipoVehiculo.isNotEmpty &&
                      fechaVehiculo.isNotEmpty) {
                    context.read<BlocVehiculo>().add(EventoAgregarVehiculo(
                        placaVehiculo,
                        modeloVehiculo,
                        marcaVehiculo,
                        tipoVehiculo,
                        fechaVehiculo));
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Campos vacíos'),
                          content: const Text(
                              'Existen uno o más campos vacíos que se intentaron agregar. Intentar otra vez.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          );
        },
      );
    },
  );
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.toUpperCase();
    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
}

class ListaGastos extends StatefulWidget {
  const ListaGastos({super.key});

  @override
  State<ListaGastos> createState() => _ListaGastosState();
}

class _ListaGastosState extends State<ListaGastos> {
  final TextEditingController _buscarGastos = TextEditingController();
  List<Gastos> gastosFiltrados = [];
  double totalGastosFiltrados2 = 0;

  @override
  Widget build(BuildContext context) {
    var estado = context.watch<BlocVehiculo>().state;
    vehiculos = (estado as EstadoCargarVehiculos).vehiculos;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _buscarGastos,
              decoration: InputDecoration(
                hintText: 'Buscar gasto...',
                prefixIcon: const Icon(Icons.search),
                suffixText: 'Gastos: ${gastosFiltrados.length}',
                suffixStyle: const TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                setState(() {
                  gastosFiltrados = gastos
                      .where((gasto) =>
                          gasto.categoria_nombre!
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          gasto.vehiculo_nombre!
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          gasto.monto
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                      .toList();
                  double totalGastosFiltrados = gastosFiltrados.fold(
                    0,
                    (previousValue, gasto) => previousValue + gasto.monto,
                  );
                  setState(() {
                    totalGastosFiltrados2 = totalGastosFiltrados;
                  });
                });
              },
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Total de gastos:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' \$$totalGastosFiltrados2',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<GastoBloc, EstadoGasto>(
            builder: (context, state) {
              if (state is EstadoCargarGasto) {
                gastos = state.gastos;

                final List<Gastos> gastosToDisplay =
                    gastosFiltrados.isNotEmpty ? gastosFiltrados : gastos;

                return Expanded(
                  child: ListView.builder(
                    itemCount: gastosToDisplay.length,
                    itemBuilder: (context, index) {
                      final gasto = gastosToDisplay[index];
                      DateTime fecha =
                          DateTime.fromMillisecondsSinceEpoch(gasto.fecha);
                      String fechaFormateada =
                          DateFormat('dd/MMMM/yyyy').format(fecha);
                      String categoriaNombre =
                          gasto.categoria_nombre ?? 'General';
                      String vehiculoNombre =
                          gasto.vehiculo_nombre ?? 'Vehiculo';
                      return Card(
                        child: ListTile(
                          title: Text('$categoriaNombre - $vehiculoNombre'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cantidad: ${gasto.monto.toString()}'),
                              Text(fechaFormateada),
                              Text(
                                  'ID Vehiculo: ${gasto.vehiculoID.toString()}')
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  editarGastos(context, gasto);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Confirmar eliminación'),
                                        content: const Text(
                                            '¿Está seguro de eliminar este gasto? Se eliminará de forma permanente.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text('Eliminar'),
                                            onPressed: () {
                                              context.read<GastoBloc>().add(
                                                  EventoEliminarGasto(
                                                      gasto.id!));
                                              // print('${gasto.id}');
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          agregarGastos(context);
        },
      ),
    );
  }
}

void editarGastos(BuildContext context, Gastos gasto) {
  Categorias? categoriaSeleccionada;
  final TextEditingController categoriaControllerE = TextEditingController();
  final TextEditingController vehiculoControllerE = TextEditingController();
  final TextEditingController responsableControllerE = TextEditingController();
  TextEditingController controladorMontoE = TextEditingController();
  DateTime fechaSeleccionada =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Vehiculo? vehiculoSeleccionado;
  int? responsableSeleccionado;

   String categoriaNombre = gasto.categoria_nombre ?? 'General';
   String vehiculoNombre = gasto.vehiculo_nombre ?? 'Vehiculo';
   String responsableNombre = gasto.responsable_nombre ?? 'Usuario';

  categoriaControllerE.text = categoriaNombre;
  vehiculoControllerE.text = vehiculoNombre;
  responsableControllerE.text = responsableNombre;
  controladorMontoE.text = gasto.monto.toString();
  // DateTime fechaSeleccionada = DateTime.parse(gasto.fecha.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar gasto'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenu<Categorias>(
                      width: 220,
                      label: const Row(
                        children: [
                          Icon(Icons.category),
                          SizedBox(width: 8),
                          Text('Categoría'),
                        ],
                      ),
                      controller: categoriaControllerE,
                      onSelected: (Categorias? newValue) {
                        setState(() {
                          categoriaSeleccionada = newValue;
                        });
                      },
                      dropdownMenuEntries: categorias
                          .map<DropdownMenuEntry<Categorias>>(
                              (Categorias value) {
                        return DropdownMenuEntry<Categorias>(
                          value: value,
                          label: value.nombre,
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenu<Vehiculo>(
                      width: 220,
                      label: const Row(
                        children: [
                          Icon(Icons.directions_car),
                          SizedBox(width: 8),
                          Text('Vehículo'),
                        ],
                      ),
                      controller: vehiculoControllerE,
                      onSelected: (Vehiculo? newValue) {
                        setState(() {
                          vehiculoSeleccionado = newValue;
                        });
                      },
                      dropdownMenuEntries: vehiculos
                          .map<DropdownMenuEntry<Vehiculo>>((Vehiculo value) {
                        return DropdownMenuEntry<Vehiculo>(
                          value: value,
                          label:
                              '${value.placa} - ${value.modelo} ${value.fecha}',
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenu<Responsables>(
                      width: 220,
                      label: const Row(
                        children: [
                          Icon(Icons.supervised_user_circle),
                          SizedBox(width: 8),
                          Text('Responsable'),
                        ],
                      ),
                      controller: responsableControllerE,
                      onSelected: (Responsables? newValue) {
                        setState(() {
                          responsableSeleccionado = newValue?.id;
                        });
                      },
                      dropdownMenuEntries: responsablessss
                          .map<DropdownMenuEntry<Responsables>>(
                              (Responsables value) {
                        return DropdownMenuEntry<Responsables>(
                          value: value,
                          label: value.nombre,
                        );
                      }).toList(),
                    ),
                  ),
                  DateTimeField(
                    decoration: const InputDecoration(
                        labelText: 'Fecha', icon: Icon(Icons.calendar_month)),
                    format: DateFormat(DateFormat.YEAR_MONTH_DAY),
                    onShowPicker: (context, currentValue) async {
                      final fecha = await showDatePicker(
                        initialDatePickerMode: DatePickerMode.day,
                        initialDate: fechaSeleccionada,
                        context: context,
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now(),
                      );

                      if (fecha != null) {
                        setState(() {
                          fechaSeleccionada = fecha;
                        });
                      }
                      return fechaSeleccionada;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controladorMontoE,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.monetization_on),
                      labelText: 'Monto',
                    ),
                    onChanged: (value) {
                      final numericValue =
                          int.tryParse(value.replaceAll(',', ''));
                      if (numericValue != null) {
                        final formatter = NumberFormat('#,###');
                        final newText = formatter.format(numericValue);
                        if (newText != controladorMontoE.text) {
                          controladorMontoE.value = TextEditingValue(
                            text: newText,
                            selection:
                                TextSelection.collapsed(offset: newText.length),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final categoriaGasto = categoriaSeleccionada;
                  final vehiculoGasto = vehiculoSeleccionado;
                  final responsableGasto = responsableSeleccionado;
                  final monto = double.tryParse(
                      controladorMontoE.text.replaceAll(',', ''));
                  final int fechaString =
                      fechaSeleccionada.millisecondsSinceEpoch;

                  if (categoriaGasto != null &&
                      vehiculoGasto != null &&
                      monto != null) {
                    context.read<GastoBloc>().add(EventoEditarGasto(
                        gasto: Gastos(
                            vehiculoID: vehiculoGasto.id!,
                            categoria: categoriaGasto.id!,
                            responsable: responsableGasto!,
                            fecha: fechaString,
                            monto: monto)));
                    /* print(
                        '$monto ${vehiculoGasto.id} ${categoriaGasto.nombre} $responsableSeleccionado $fechaString'); */
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

void agregarGastos(BuildContext context) {
  Categorias? categoriaSeleccionada;
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController vehiculoController = TextEditingController();
  final TextEditingController responsableController = TextEditingController();
  TextEditingController controladorMonto = TextEditingController();
  DateTime fechaSeleccionada =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //int date = fechaSeleccionada.millisecondsSinceEpoch;
  Vehiculo? vehiculoSeleccionado;
  int? responsableSeleccionado;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Agregar gasto'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenu<Categorias>(
                      width: 220,
                      label: const Row(
                        children: [
                          Icon(Icons.category),
                          SizedBox(width: 8),
                          Text('Categoría'),
                        ],
                      ),
                      controller: categoriaController,
                      onSelected: (Categorias? newValue) {
                        setState(() {
                          categoriaSeleccionada = newValue;
                        });
                      },
                      dropdownMenuEntries: categorias
                          .map<DropdownMenuEntry<Categorias>>(
                              (Categorias value) {
                        return DropdownMenuEntry<Categorias>(
                          value: value,
                          label: value.nombre,
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenu<Vehiculo>(
                      width: 220,
                      label: const Row(
                        children: [
                          Icon(Icons.directions_car),
                          SizedBox(width: 8),
                          Text('Vehículo'),
                        ],
                      ),
                      controller: vehiculoController,
                      onSelected: (Vehiculo? newValue) {
                        setState(() {
                          vehiculoSeleccionado = newValue;
                        });
                      },
                      dropdownMenuEntries: vehiculos
                          .map<DropdownMenuEntry<Vehiculo>>((Vehiculo value) {
                        return DropdownMenuEntry<Vehiculo>(
                          value: value,
                          label:
                              '${value.placa} - ${value.modelo} ${value.fecha}',
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenu<Responsables>(
                      width: 220,
                      label: const Row(
                        children: [
                          Icon(Icons.supervised_user_circle),
                          SizedBox(width: 8),
                          Text('Responsable'),
                        ],
                      ),
                      controller: responsableController,
                      onSelected: (Responsables? newValue) {
                        setState(() {
                          responsableSeleccionado = newValue?.id;
                        });
                      },
                      dropdownMenuEntries: responsablessss
                          .map<DropdownMenuEntry<Responsables>>(
                              (Responsables value) {
                        return DropdownMenuEntry<Responsables>(
                          value: value,
                          label: value.nombre,
                        );
                      }).toList(),
                    ),
                  ),
                  DateTimeField(
                    decoration: const InputDecoration(
                        labelText: 'Fecha', icon: Icon(Icons.calendar_month)),
                    format: DateFormat(DateFormat.YEAR_MONTH_DAY),
                    onShowPicker: (context, currentValue) async {
                      final fecha = await showDatePicker(
                        initialDatePickerMode: DatePickerMode.day,
                        initialDate: fechaSeleccionada,
                        context: context,
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now(),
                      );

                      if (fecha != null) {
                        setState(() {
                          fechaSeleccionada = fecha;
                        });
                      }
                      return fechaSeleccionada;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controladorMonto,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.monetization_on),
                      labelText: 'Monto',
                    ),
                    onChanged: (value) {
                      final numericValue =
                          int.tryParse(value.replaceAll(',', ''));
                      if (numericValue != null) {
                        final formatter = NumberFormat('#,###');
                        final newText = formatter.format(numericValue);
                        if (newText != controladorMonto.text) {
                          controladorMonto.value = TextEditingValue(
                            text: newText,
                            selection:
                                TextSelection.collapsed(offset: newText.length),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final categoriaGasto = categoriaSeleccionada;
                  final vehiculoGasto = vehiculoSeleccionado;
                  final responsableGasto = responsableSeleccionado;
                  final monto = double.tryParse(
                      controladorMonto.text.replaceAll(',', ''));
                  final int fechaString =
                      fechaSeleccionada.millisecondsSinceEpoch;

                  if (categoriaGasto != null &&
                      vehiculoGasto != null &&
                      monto != null) {
                    context.read<GastoBloc>().add(EventoAgregarGasto2(
                        gasto: Gastos(
                            vehiculoID: vehiculoGasto.id!,
                            categoria: categoriaGasto.id!,
                            responsable: responsableGasto!,
                            fecha: fechaString,
                            monto: monto)));
                    /* print(
                        '$monto ${vehiculoGasto.id} ${categoriaGasto.nombre} $responsableSeleccionado $fechaString'); */
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Agregar'),
              ),
            ],
          );
        },
      );
    },
  );
}

class ListaConsultas extends StatefulWidget {
  const ListaConsultas({super.key});

  @override
  State<ListaConsultas> createState() => _ListaConsultasState();
}

class _ListaConsultasState extends State<ListaConsultas> {
  late DateTime? fechaInicial =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late DateTime? fechaFinal =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<Gastos> gastos = [];

  Future<void> _seleccionarFechaInicial() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaInicial ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    if (picked != null &&
        (fechaFinal == null || picked.isBefore(fechaFinal!))) {
      setState(() {
        fechaInicial = picked;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error en la selección de fecha'),
            content: const Text(
                'La fecha inicial debe ser anterior a la fecha final.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _seleccionarFechaFinal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaFinal ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    if (picked != null &&
        (fechaInicial == null || picked.isAfter(fechaInicial!))) {
      setState(() {
        fechaFinal = picked;
      });
      _consultarGastos();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error en la selección de fecha'),
            content: const Text(
                'La fecha final debe ser posterior a la fecha inicial.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _consultarGastos() async {
    gastos = await BaseDatos().getGastosFechas(fechaInicial!, fechaFinal!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double totalGastos = 0.0;
    for (var gasto in gastos) {
      totalGastos += gasto.monto;
    }

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Divider(),
                  const Text('Desde: '),
                  ElevatedButton(
                    onPressed: () {
                      _seleccionarFechaInicial();
                    },
                    child: Text(fechaInicial != null
                        ? DateFormat('dd-MM-yyyy').format(fechaInicial!)
                        : 'Seleccionar Fecha Inicial'),
                  ),
                ],
              ),
              Column(
                children: [
                  const Divider(),
                  const Text('Hasta: '),
                  ElevatedButton(
                    onPressed: () {
                      _seleccionarFechaFinal();
                    },
                    child: Text(fechaFinal != null
                        ? DateFormat('dd-MM-yyyy').format(fechaFinal!)
                        : 'Seleccionar Fecha Final'),
                  ),
                ],
              ),
            ],
          ),
          Card(
            elevation: 14.0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    'Total: \$${totalGastos.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastos[index];
                DateTime fecha =
                    DateTime.fromMillisecondsSinceEpoch(gasto.fecha);
                String fechaFormateada =
                    DateFormat('dd/MMMM/yyyy').format(fecha);
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monto: \$${gasto.monto}'),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID Vehiculo: ${gasto.vehiculoID}'),
                        Text('Fecha: $fechaFormateada'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final RegExp noEmojiRegExp = RegExp(
  r'^[a-zA-Z0-9!"#\$%&\()*+,-./:;<=>?@[\\\]^_`{|}~\s]*$',
);

bool validarCampo(BuildContext context, String texto) {
  if (texto.trim().isEmpty) {
    mostrarError(context,
        'Existen uno o más campos vacíos que se intentaron agregar. Intentar otra vez.');
    return false;
  }

  if (!noEmojiRegExp.hasMatch(texto)) {
    mostrarError(
        context, 'El texto no puede contener emojis ni caracteres especiales.');
    return false;
  }

  return true;
}

void mostrarError(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(mensaje),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
