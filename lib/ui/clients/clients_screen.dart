import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../state/client_controller.dart';
import '../../data/models/client.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Clientes',
      actions: [
        IconButton(
          onPressed: () async {
            final v = await showDialog<Client>(
              context: context,
              builder: (_) => const _ClientDialog(),
            );
            if (!context.mounted) return;
            if (v != null) {
              context.read<ClientController>().add(v);
              final m = ScaffoldMessenger.of(context);
              m.clearSnackBars();
              m.showSnackBar(
                const SnackBar(content: Text('Cliente agregado correctamente')),
              );
            }
          },
          icon: const Icon(Icons.add),
        ),
      ],
      body: Column(
        children: [
          SearchField(
            hint: 'Buscar por nombre, apellido o documento',
            onChanged: (q) => context.read<ClientController>().setQuery(q),
          ),
          Expanded(
            child: Consumer<ClientController>(
              builder: (_, c, __) => ListView.builder(
                itemCount: c.items.length,
                itemBuilder: (_, i) {
                  final v = c.items[i];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('${v.nombre} ${v.apellido}'),
                    subtitle:
                        Text('DOC: ${v.documento} • ID: ${v.idCliente}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final edited = await showDialog<Client>(
                              context: context,
                              builder: (_) => _ClientDialog(edit: v),
                            );
                            if (!context.mounted) return;
                            if (edited != null) {
                              context.read<ClientController>().update(edited);
                              final m = ScaffoldMessenger.of(context);
                              m.clearSnackBars();
                              m.showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Cliente actualizado correctamente')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<ClientController>()
                                .remove(v.idCliente);
                            final m = ScaffoldMessenger.of(context);
                            m.clearSnackBars();
                            m.showSnackBar(
                              const SnackBar(
                                  content: Text('Cliente eliminado')),
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

      // 👉 FAB para agregar cliente
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final v = await showDialog<Client>(
            context: context,
            builder: (_) => const _ClientDialog(),
          );
          if (!context.mounted) return;
          if (v != null) {
            context.read<ClientController>().add(v);
            final m = ScaffoldMessenger.of(context);
            m.clearSnackBars();
            m.showSnackBar(
              const SnackBar(content: Text('Cliente agregado correctamente')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ClientDialog extends StatefulWidget {
  final Client? edit;
  const _ClientDialog({this.edit});
  @override
  State<_ClientDialog> createState() => _ClientDialogState();
}

class _ClientDialogState extends State<_ClientDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController idCtrl;
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final docCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    idCtrl = TextEditingController(text: widget.edit?.idCliente);
    nombreCtrl.text = widget.edit?.nombre ?? '';
    apellidoCtrl.text = widget.edit?.apellido ?? '';
    docCtrl.text = widget.edit?.documento ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.edit == null ? 'Nuevo cliente' : 'Editar cliente'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'ID cliente'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'ID requerido' : null,
              ),
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nombre requerido' : null,
              ),
              TextFormField(
                controller: apellidoCtrl,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Apellido requerido'
                    : null,
              ),
              TextFormField(
                controller: docCtrl,
                decoration:
                    const InputDecoration(labelText: 'Documento o CI'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Documento requerido'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final v = Client(
              idCliente: idCtrl.text.trim(),
              nombre: nombreCtrl.text.trim(),
              apellido: apellidoCtrl.text.trim(),
              documento: docCtrl.text.trim(),
            );
            Navigator.pop(context, v);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
