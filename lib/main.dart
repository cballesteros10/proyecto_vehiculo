import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_vehiculos/blocs/gastosbloc.dart';
import 'package:proyecto_vehiculos/base.dart';
import 'package:proyecto_vehiculos/blocs/vehiculobloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_vehiculos/modelos/plantilla.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await BaseDatos().initDatabase();
  runApp(const AplicacionInyectada());
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
          create: (context) => CategoriaBloc()..add(Inicializo3()),
        ),
        BlocProvider(
          create: (context) => ResponsableBloc()..add(Inicializo4()),
        ),
        BlocProvider(
          create: (context) => GastoBloc()..add(Inicializo2()),
        )
      ],
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
        home: Scaffold(appBar: MiAppBar(), body: TabsRemix()));
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
                return ListTile(
                  title: Text(categoriaSeleccionada.nombre),
                  subtitle: Text(categoriaSeleccionada.id.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (categoriaSeleccionada.id != null) {
                        context.read<CategoriaBloc>().add(
                            EventoEliminarCategoria(categoriaSeleccionada.id!));
                      }
                    },
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
                final categoria1 = responsablessss[index];
                return ListTile(
                  title: Text(categoria1.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(categoria1.direccion),
                      Text(categoria1.telefono),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<ResponsableBloc>().add(EventoEliminarResponsable(categoria1.id!));
                    },
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
                        context
                            .read<CategoriaBloc>()
                            .add(EventoAgregarCategoria(nombreCategoria));
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
  TextEditingController controladorDireccion = TextEditingController();
  TextEditingController controladorTelefono = TextEditingController();

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
                controller: controladorDireccion,
                decoration: const InputDecoration(labelText: 'Direccion'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: controladorTelefono,
                decoration: const InputDecoration(labelText: 'Telefono'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final nombreResponsable = controladorNombre.text;
                      final direccionResponsable = controladorDireccion.text;
                      final telefonoResponsable = controladorTelefono.text;

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

class TabsRemix extends StatefulWidget {
  const TabsRemix({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabsRemixState createState() => _TabsRemixState();
}

class _TabsRemixState extends State<TabsRemix> with SingleTickerProviderStateMixin {
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
            indicatorColor: Color.fromARGB(255, 112, 65, 197),
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
  List<Vehiculo> filteredVehiculos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar vehículo...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
  filteredVehiculos = vehiculos
    .where((vehiculo) =>
      vehiculo.placa.toLowerCase().contains(value.toLowerCase()) ||
      vehiculo.modelo.toLowerCase().contains(value.toLowerCase()) ||
      vehiculo.marca.toLowerCase().contains(value.toLowerCase()) ||
      vehiculo.tipo.toLowerCase().contains(value.toLowerCase()) ||
      vehiculo.fecha.toString().toLowerCase().contains(value.toLowerCase()))
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
                    filteredVehiculos.isNotEmpty
                        ? filteredVehiculos
                        : vehiculos;

                return Expanded(
                  child: ListView.builder(
                    itemCount: vehiculosToDisplay.length,
                    itemBuilder: (context, index) {
                      final vehiculo = vehiculosToDisplay[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              '${vehiculo.placa} - ${vehiculo.modelo} ${vehiculo.fecha}'),
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
                                        title: const Text(
                                            'Confirmar eliminación'),
                                        content: const Text(
                                            '¿Está seguro de eliminar este vehículo? Se eliminara de forma permanente.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
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
              return const Center(
                  child: Text('No hay vehículos registrados :('));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar vehículo'),
        icon: const Icon(Icons.add),
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
                    decoration: const InputDecoration(
                        labelText: 'Placa', prefixIcon: Icon(Icons.rectangle)),
                  ),
                  TextField(
                    controller: controladorModeloE,
                    decoration: const InputDecoration(
                        labelText: 'Modelo',
                        hintText: 'Versa, Corolla, etc...',
                        prefixIcon: Icon(Icons.car_rental)),
                  ),
                  TextField(
                    controller: controladorMarcaE,
                    decoration: const InputDecoration(
                        labelText: 'Marca',
                        hintText: 'Nissan, Toyota, etc...',
                        prefixIcon: Icon(Icons.check)),
                  ),
                  TextField(
                    controller: controladorTipoE,
                    decoration: const InputDecoration(
                        labelText: 'Tipo',
                        hintText: 'Carro, camioneta, etc...',
                        prefixIcon: Icon(Icons.type_specimen)),
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
                onPressed: () {
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
                    decoration: const InputDecoration(
                        labelText: 'Placa', prefixIcon: Icon(Icons.rectangle)),
                  ),
                  TextField(
                    controller: controladorModelo,
                    decoration: const InputDecoration(
                        labelText: 'Modelo',
                        hintText: 'Versa, Corolla, etc...',
                        prefixIcon: Icon(Icons.car_rental)),
                  ),
                  TextField(
                    controller: controladorMarca,
                    decoration: const InputDecoration(
                        labelText: 'Marca',
                        hintText: 'Nissan, Toyota, etc...',
                        prefixIcon: Icon(Icons.check)),
                  ),
                  TextField(
                    controller: controladorTipo,
                    decoration: const InputDecoration(
                        labelText: 'Tipo',
                        hintText: 'Carro, camioneta, etc...',
                        prefixIcon: Icon(Icons.type_specimen)),
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
                onPressed: () {
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
                  }
                    AlertDialog(
                      title: const Text(
                                            'Campos vacios'),
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
                child: const Text('Agregar'),
              ),
            ],
          );
        },
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
      body: BlocBuilder<GastoBloc, EstadoGasto>(
        builder: (context, state) {
          if (state is EstadoCargarGasto) {
            gastos = state.gastos;

            return ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gastoSeleccionado = gastos[index];
                return Card(
                  child: ListTile(
                    title: Text(gastoSeleccionado.categoria_nombre!),
                    subtitle: Text(gastoSeleccionado.vehiculo_nombre!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmar eliminación'),
                                  content: const Text(
                                      '¿Está seguro de eliminar este gasto? Se eliminará de forma permanente.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Eliminar'),
                                      onPressed: () {
                                        context.read<GastoBloc>().add(
                                            EventoEliminarGasto(gastoSeleccionado.id!));
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
          return const Center(child: Text('No hay gastos registrados :('));
        },
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
  TextEditingController controladorMonto = TextEditingController();
  DateTime fechaSeleccionada = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int date = fechaSeleccionada.millisecondsSinceEpoch;
  Vehiculo? vehiculoSeleccionado;
  int? responsableSeleccionado;
  bool switchValue = false;

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
                          Icon(Icons
                              .category),
                          SizedBox(
                              width: 8),
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
                      enableFilter: true,
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
                              '${value.placa} - ${value.marca} ${value.fecha}',
                        );
                      }).toList(),
                    ),
                  ),
                  DateTimeField(
                    decoration: const InputDecoration(
                      labelText: 'Fecha', 
                      icon: Icon(Icons.calendar_month)
                    ),
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
                  const SizedBox(height: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Existio un encargado?'),
                      Switch(
                        value: switchValue,
                        onChanged: (value) {
                          setState(() {
                            switchValue = value;
                            if (!value) {
                              responsableSeleccionado = 1;
                              responsableController.clear();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  if (switchValue) 
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
                  final monto = double.tryParse(controladorMonto.text.replaceAll(',', ''));
                  final int fechaString = fechaSeleccionada.millisecondsSinceEpoch;

                  if (categoriaGasto != null &&
                      vehiculoGasto != null &&
                      monto != null) {
                        /* context.read<GastoBloc>().add(EventoAgregarGasto(
                          vehiculoGasto.id!, 
                          categoriaGasto.id!, 
                          responsableSeleccionado!, 
                          fechaString, 
                          monto)); */
                          context.read<GastoBloc>().add(EventoAgregarGasto2(gasto: Gastos(
                            vehiculoID: vehiculoGasto.id!, 
                            categoria: categoriaGasto.id!, 
                            responsable: responsableSeleccionado!, 
                            fecha: fechaString, 
                            monto: monto)));
                          print('$monto ${vehiculoGasto.id} ${categoriaGasto.nombre} $responsableSeleccionado $fechaString');
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

final RegExp noEmojiRegExp = RegExp(
    r'^[a-zA-Z0-9!"#\$%&\()*+,-./:;<=>?@[\\\]^_`{|}~\s]*$',
  );
  
bool validarCampo(BuildContext context, String texto){
  if (texto.trim().isEmpty) {
    mostrarError(context, 'Existen uno o más campos vacíos que se intentaron agregar. Intentar otra vez.');
    return false;
  }


  if(!noEmojiRegExp.hasMatch(texto)){
    mostrarError(context, 'El texto no puede contener emojis ni caracteres especiales.');
    return false;
  }

  return true;
}

void mostrarError(BuildContext context, String mensaje){
  showDialog(
    context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Error'),
        content: Text(mensaje),
        actions: <Widget>[
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text('OK'),
          ),
        ],
      );
    },
  );
}