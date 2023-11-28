import 'package:flutter/material.dart';
import 'package:proyecto_vehiculos/blocs/gastosbloc.dart';
// import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/blocs/vehiculobloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AplicacionInyectada());
}

List<Categorias> categorias = [];

List<Vehiculo> vehiculos = [];

List<Responsables> responsablessss = [];

class AplicacionInyectada extends StatelessWidget {
  const AplicacionInyectada({super.key});

  @override
  Widget build(BuildContext context) {
    // BaseDatos _base = BaseDatos();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlocVehiculo(),
        ),
        BlocProvider(
          create: (context) => CategoriaBloc(),
    )],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'MyCarApp',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: MiAppBar(), body: MisTabs()));
  }
}

class MiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MiAppBar({Key? key}) : super(key: key);

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
  const Detalles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Manejar la opción seleccionada
        if (value == 'Categorías') {
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => const ListaCategorias()));
        } else if (value == 'Responsables') {
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => const ListaResponsables()));
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
      body: BlocBuilder<CategoriaBloc, EstadoCategoria>(
        builder: (context, state) {
          if (state is EstadoCargarCategorias) {
            categorias = state.categorias;

            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria1 = categorias[index];
                return ListTile(
                  title: Text(categoria1.nombre),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {

                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No hay categorias registrados :('));
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

class ListaResponsables extends StatefulWidget {
  const ListaResponsables({super.key});

  @override
  State<ListaResponsables> createState() => _ListaResponsablesState();
}

class _ListaResponsablesState extends State<ListaResponsables> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CategoriaBloc, EstadoCategoria>(
        builder: (context, state) {
          if (state is EstadoCargarCategorias) {
            categorias = state.categorias;

            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria1 = categorias[index];
                return ListTile(
                  title: Text(categoria1.nombre),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {

                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No hay categorias registrados :('));
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

void mostrarAgregarCategoria(BuildContext context) {
  TextEditingController controladorNombre = TextEditingController();

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
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final nombreCategoria = controladorNombre.text;
                      if (nombreCategoria.isNotEmpty) {
                        context.read<CategoriaBloc>().add(EventoAgregarCategoria(nombreCategoria));
                        print('si agrega $nombreCategoria');
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Agregar'),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
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
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: controladorNombre,
                decoration: const InputDecoration(labelText: 'Direccion'),
              ),
              TextField(
                controller: controladorNombre,
                decoration: const InputDecoration(labelText: 'Telefono'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                    child: const Text('Agregar'),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
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
                      'MyMobileAgenda es una app capaz de llevar registro de tus autos y los gastos que hagas en ellos.',
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

class MisTabs extends StatefulWidget {
  const MisTabs({super.key});

  @override
  MisTabsState createState() => MisTabsState();
}

class MisTabsState extends State<MisTabs> {
  List<String> data = ['Vehículos', 'Gastos', 'Consultas'];
  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomTabView(
          initPosition: initPosition,
          itemCount: data.length,
          tabBuilder: (context, index) => Tab(text: data[index]),
          pageBuilder: (context, index) {
            switch (index) {
              case 0:
                return const ListaVehiculos();
              case 1:
                return const ListaGastos();
              case 2:
                return const ListaConsultas();
              default:
                return Container();
            }
          }),
    ));
  }
}

class CustomTabView extends StatefulWidget {
  const CustomTabView({
    super.key,
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;

  @override
  CustomTabsState createState() => CustomTabsState();
}

class CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition!;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && widget.onPositionChange != null) {
              widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  void onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);
      }
    }
  }
}

class ListaVehiculos extends StatefulWidget {
  const ListaVehiculos({super.key});

  @override
  State<ListaVehiculos> createState() => _ListaVehiculosState();
}

class _ListaVehiculosState extends State<ListaVehiculos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BlocVehiculo, EstadoVehiculo>(
        builder: (context, state) {
          if (state is EstadoCargarVehiculos) {
            vehiculos = state.vehiculos;

            return ListView.builder(
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                final vehiculo = vehiculos[index];
                return ListTile(
                  title: Text(vehiculo.placa),
                  subtitle: Text(vehiculo.modelo),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<BlocVehiculo>()
                          .add(EventoEliminarVehiculo(vehiculo.id!));
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No hay vehiculos registrados :('));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar vehículo'),
        icon: const Icon(Icons.add_box_rounded),
        onPressed: () {
          agregarVehiculos(context);
        },
      ),
    );
  }
}

void agregarVehiculos(BuildContext context) {
  TextEditingController controladorPlaca = TextEditingController();
  TextEditingController controladorModelo = TextEditingController();
  TextEditingController controladorMarca = TextEditingController();
  TextEditingController controladorTipo = TextEditingController();
  TextEditingController controladorFecha = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar Vehiculo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controladorPlaca,
                decoration: const InputDecoration(labelText: 'Placa'),
              ),
              TextField(
                controller: controladorModelo,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              TextField(
                controller: controladorMarca,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: controladorTipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: controladorFecha,
                decoration: const InputDecoration(labelText: 'Fecha'),
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
              final placaVehiculo = controladorPlaca.text;
              final modeloVehiculo = controladorModelo.text;
              final marcaVehiculo = controladorMarca.text;
              final tipoVehiculo = controladorTipo.text;
              final fechaVehiculo = controladorFecha.text;

              if (placaVehiculo.isNotEmpty &&
                  modeloVehiculo.isNotEmpty &&
                  marcaVehiculo.isNotEmpty &&
                  tipoVehiculo.isNotEmpty &&
                  fechaVehiculo.isNotEmpty) {
                context.read<BlocVehiculo>().add(
                      EventoAgregarVehiculo(
                        placaVehiculo, 
                        modeloVehiculo, 
                        marcaVehiculo, 
                        tipoVehiculo, 
                        fechaVehiculo)
                    );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    },
  );
}

class ListaGastos extends StatefulWidget {
  const ListaGastos({Key? key}) : super(key: key);

  @override
  State<ListaGastos> createState() => _ListaGastosState();
}

class _ListaGastosState extends State<ListaGastos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          ListTile(title: Text('Gasto 1')),
          ListTile(title: Text('Gasto 2')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar gasto'),
        icon: const Icon(Icons.add_box_rounded),
        onPressed: () {
          agregarGastos(context);
        },
      ),
    );
  }
}

void agregarGastos(BuildContext context) {
  Categorias? categoriaSeleccionada;
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController vehiculoController = TextEditingController();
  final TextEditingController responsableController = TextEditingController();
  Vehiculo? vehiculoSeleccionado;
  Responsables? responsableSeleccionado;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
          return AlertDialog(
            title: const Text('Agregar gasto'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu<Categorias>(
                        label: const Text('Categoria'),
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
                        enableFilter: true,
                        label: const Text('Vehiculo'),
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
                            label: value.placa,
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu<Responsables>(
                        label: const Text('Responsable'),
                        controller: responsableController,
                        onSelected: (Responsables? newValue) {
                          setState(() {
                            responsableSeleccionado = newValue;
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
                              initialDate: DateTime.now(),
                              context: context,
                              firstDate: DateTime(2010),
                              lastDate: DateTime.now());
                          return fecha;
                        }),
                    const SizedBox(height: 16.0),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                      ),
                      onChanged: (value) {},
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
                  // Lógica para agregar el gasto
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

class ListaConsultas extends StatelessWidget {
  const ListaConsultas({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Buscar consultas...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // print('Prueba');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
