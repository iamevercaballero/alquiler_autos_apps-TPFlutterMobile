import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../state/vehicle_controller.dart';
import '../../data/models/vehicle.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Vehículos',
      actions: [
        IconButton(
          onPressed: () async {
            final v = await showDialog<Vehicle>(
              context: context,
              builder: (_) => const _VehicleDialog(),
            );
            if (!context.mounted) return;
            if (v != null) {
              context.read<VehicleController>().add(v);
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();
              messenger.showSnackBar(
                const SnackBar(content: Text('Vehículo agregado correctamente')),
              );
            }
          },
          icon: const Icon(Icons.add),
        )
      ],
      body: Column(
        children: [
          SearchField(
            hint: 'Buscar por marca o modelo',
            onChanged: (q) => context.read<VehicleController>().setQuery(q),
          ),
          Expanded(
            child: Consumer<VehicleController>(
              builder: (_, c, __) => ListView.builder(
                itemCount: c.items.length,
                itemBuilder: (_, i) {
                  final v = c.items[i];
                  return ListTile(
                    leading: Icon(
                      v.disponible ? Icons.check_circle : Icons.block,
                      color: v.disponible ? Colors.green : Colors.red,
                    ),
                    title: Text('${v.marca} ${v.modelo}'),
                    subtitle: Text('Año: ${v.anio} • ID: ${v.idVehiculo}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final edited = await showDialog<Vehicle>(
                              context: context,
                              builder: (_) => _VehicleDialog(edit: v),
                            );
                            if (!context.mounted) return;
                            if (edited != null) {
                              context.read<VehicleController>().update(edited);
                              final messenger = ScaffoldMessenger.of(context);
                              messenger.clearSnackBars();
                              messenger.showSnackBar(
                                const SnackBar(content: Text('Vehículo actualizado correctamente')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<VehicleController>().remove(v.idVehiculo);
                            final messenger = ScaffoldMessenger.of(context);
                            messenger.clearSnackBars();
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Vehículo eliminado')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final v = await showDialog<Vehicle>(
            context: context,
            builder: (_) => const _VehicleDialog(),
          );
          if (!context.mounted) return;
          if (v != null) {
            context.read<VehicleController>().add(v);
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(
              const SnackBar(content: Text('Vehículo agregado correctamente')),
            );
          }
        },
        tooltip: 'Registrar vehículo',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _VehicleDialog extends StatefulWidget {
  final Vehicle? edit;
  const _VehicleDialog({this.edit});

  @override
  State<_VehicleDialog> createState() => _VehicleDialogState();
}

class _VehicleDialogState extends State<_VehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController idCtrl;
  final marcaCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final anioCtrl = TextEditingController();
  bool disponible = true;

  @override
  void initState() {
    super.initState();
    idCtrl = TextEditingController(text: widget.edit?.idVehiculo);
    marcaCtrl.text = widget.edit?.marca ?? '';
    modeloCtrl.text = widget.edit?.modelo ?? '';
    anioCtrl.text = widget.edit?.anio.toString() ?? '';
    disponible = widget.edit?.disponible ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.edit == null ? 'Nuevo vehículo' : 'Editar vehículo'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'ID vehículo'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'ID requerido' : null,
              ),
              TextFormField(
                controller: marcaCtrl,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Marca requerida' : null,
              ),
              TextFormField(
                controller: modeloCtrl,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Modelo requerido' : null,
              ),
              TextFormField(
                controller: anioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Año'),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null) return 'Año numérico';
                  if (n < 1980 || n > DateTime.now().year + 1) return 'Año fuera de rango';
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Disponible'),
                value: disponible,
                onChanged: (val) => setState(() => disponible = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final v = Vehicle(
              idVehiculo: idCtrl.text.trim(),
              marca: marcaCtrl.text.trim(),
              modelo: modeloCtrl.text.trim(),
              anio: int.parse(anioCtrl.text.trim()),
              disponible: disponible,
            );
            Navigator.pop(context, v);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
