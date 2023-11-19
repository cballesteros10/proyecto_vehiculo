import 'package:flutter/material.dart';
import 'package:proyecto_vehiculos/blocs/vehiculobloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AplicacionInyectada());
}

class AplicacionInyectada extends StatelessWidget {
  const AplicacionInyectada({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlocVehiculo(),
        ),
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
          mostrarDialogoCategorias(context);
        } else if (value == 'Responsables') {
          mostrarDialogoResponsables(context);
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

  void mostrarDialogoCategorias(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Categorías existentes'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              height: 350, // Altura del ScrollView
              child: ListView.builder(
                itemCount: 10, // Reemplaza con la cantidad de categorías
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Categoría $index'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar la categoría
                            Navigator.of(context).pop();
                            // Aquí puedes abrir otro diálogo para editar la categoría
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Lógica para eliminar la categoría
                            Navigator.of(context).pop();
                            // Aquí puedes mostrar un diálogo de confirmación para eliminar
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  label: const Text('Agregar categoría'),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    mostrarAgregarCategoria(context);
                  },
                ),
              ],
            ),
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
  }

  void mostrarAgregarCategoria(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Nueva Categoría',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para agregar la categoría
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

  void mostrarDialogoResponsables(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Responsables existentes'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              height: 350, // Altura del ScrollView
              child: ListView.builder(
                itemCount: 10, // Reemplaza con la cantidad de responsables
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Responsable $index'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar el responsable
                            Navigator.of(context).pop();
                            // Aquí puedes abrir otro diálogo para editar el responsable
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Lógica para eliminar el responsable
                            Navigator.of(context).pop();
                            // Aquí puedes mostrar un diálogo de confirmación para eliminar
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  label: const Text('Agregar responsable'),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    mostrarAgregarResponsable(context);
                  },
                ),
              ],
            ),
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
  }

  void mostrarAgregarResponsable(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Nuevo Responsable',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Dirección'),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para agregar el responsable
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
          ),
        );
      },
    );
  }
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
            final vehiculos = state.vehiculos;

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
                          .add(EventoEliminarVehiculo(vehiculo.id));
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar vehículo'),
        icon: const Icon(Icons.add_box_rounded),
        onPressed: () {
          ventanaFlotante1(context);
        },
      ),
    );
  }
}

void ventanaFlotante1(BuildContext context) {
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
                        1,
                        placaVehiculo,
                        modeloVehiculo,
                        marcaVehiculo,
                        tipoVehiculo,
                        fechaVehiculo,
                      ),
                      
                    );
                    print('si se hizo');
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

class ListaGastos extends StatelessWidget {
  const ListaGastos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          ListTile(title: Text('Gasto 1')),
          ListTile(title: Text('Gasto 2')),
          // ... más elementos según tus datos
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Agregar gasto'),
        icon: const Icon(Icons.add_box_rounded),
        onPressed: () {
          agregarGasto(context);
        },
      ),
    );
  }

  Future<dynamic> agregarGasto(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar gasto'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Categoria'),
                DropdownButton<String>(
                  value: null,
                  onChanged: (String? newValue) {
                    // Lógica para manejar el valor seleccionado o nulo
                  },
                  items: const <String>[
                    'Categoría 1',
                    'Categoría 2',
                    // ... más elementos según tus datos
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Dropdown para Vehiculo
                const Text('Vehículo'),
                DropdownButton<String>(
                  value: null,
                  onChanged: (String? newValue) {
                    // Lógica para manejar el valor seleccionado o nulo
                  },
                  items: const <String>[
                    'Vehículo 1',
                    'Vehículo 2',
                    // ... más elementos según tus datos
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Dropdown para Responsable
                const Text('Responsable'),
                DropdownButton<String>(
                  value: null,
                  onChanged: (String? newValue) {
                    // Lógica para manejar el valor seleccionado o nulo
                  },
                  items: const <String>[
                    'Responsable 1',
                    'Responsable 2',
                    // ... más elementos según tus datos
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // DatePicker para Fecha
                const Text('Fecha'),
                // Este es un ejemplo de cómo podría ser el DatePicker
                ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 50)),
                      lastDate: DateTime.now(),
                    ).then((selectedDate) {

                    });
                  },
                  child: const Text('Seleccionar Fecha'),
                ),
                // TextField para Monto
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                  ),
                  onChanged: (value) {
                    // Lógica para manejar el valor del Monto
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
                // Lógica para agregar el gasto
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
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
                  print('Prueba');
                },
              ),
            ],
          ),
        ),
        // Agrega más elementos según tus datos
      ],
    );
  }
}
