import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../state/reservation_controller.dart';
import '../../state/client_controller.dart';
import '../../state/vehicle_controller.dart';
import '../../data/models/reservation.dart';
import '../../core/utils/date_format.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Reservas',
      actions: [
					IconButton(
						onPressed: () async {
							final r = await showDialog<Reservation>(
								context: context,
								builder: (_) => const _ReservationDialog(),
							);
							if (!context.mounted) return;
							if (r != null) {
								try {
									context.read<ReservationController>().add(r);
									final m = ScaffoldMessenger.of(context);
									m.clearSnackBars();
									m.showSnackBar(const SnackBar(content: Text('Reserva creada correctamente')));
								} catch (e) {
									ScaffoldMessenger.of(context).showSnackBar(
										SnackBar(content: Text('Error: ${e.toString()}')),
									);
								}
							}
						},
						icon: const Icon(Icons.add),
        )
      ],
      body: Consumer<ReservationController>(
        builder: (_, c, __) => ListView(
          children: [
            const ListTile(title: Text('Activas')),
            for (final r in c.activas) ListTile(
              leading: const Icon(Icons.event_available),
              title: Text('Reserva ${r.idReserva}'),
              subtitle: Text('Cliente: ${r.idCliente} • Vehículo: ${r.idVehiculo}\n${fmtDate(r.fechaInicio)} → ${fmtDate(r.fechaFin)}'),
            ),
            const Divider(),
            const ListTile(title: Text('Histórico')),
            for (final r in c.historico) ListTile(
              leading: const Icon(Icons.history),
              title: Text('Reserva ${r.idReserva}'),
              subtitle: Text('Cliente: ${r.idCliente} • Vehículo: ${r.idVehiculo}\nInicio: ${fmtDate(r.fechaInicio)} • Entrega: ${r.fechaEntregaReal != null ? fmtDate(r.fechaEntregaReal!) : '-'}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationDialog extends StatefulWidget {
  const _ReservationDialog();
  @override
  State<_ReservationDialog> createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<_ReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  final idCtrl = TextEditingController();
  String? idClienteSel;
  String? idVehiculoSel;
  DateTime? inicio = DateTime.now();
  DateTime? fin = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final clientes = context.read<ClientController>().items;
    final disponibles = context.read<ReservationController>().repo.vehiclesDisponibles();

    return AlertDialog(
      title: const Text('Nueva reserva'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID reserva'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'ID requerido' : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: idClienteSel,
              items: [
                for (final c in clientes)
                  DropdownMenuItem(value: c.idCliente, child: Text('${c.nombre} ${c.apellido} (${c.idCliente})')),
              ],
              onChanged: (val) => setState(() => idClienteSel = val),
              validator: (v) => v == null ? 'Cliente requerido' : null,
              decoration: const InputDecoration(labelText: 'Cliente'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: idVehiculoSel,
              items: [
                for (final v in disponibles)
                  DropdownMenuItem(value: v.idVehiculo, child: Text('${v.marca} ${v.modelo} (${v.idVehiculo})')),
              ],
              onChanged: (val) => setState(() => idVehiculoSel = val),
              validator: (v) => v == null ? 'Vehículo requerido' : null,
              decoration: const InputDecoration(labelText: 'Vehículo disponible'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('Inicio: ${fmtDate(inicio!)}')),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context, initialDate: inicio!, firstDate: DateTime(2020), lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => inicio = picked);
                  },
                  child: const Text('Elegir'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('Fin: ${fmtDate(fin!)}')),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context, initialDate: fin!, firstDate: DateTime(2020), lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => fin = picked);
                  },
                  child: const Text('Elegir'),
                ),
              ],
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final r = Reservation(
              idReserva: idCtrl.text.trim(),
              idCliente: idClienteSel!,
              idVehiculo: idVehiculoSel!,
              fechaInicio: inicio!,
              fechaFin: fin!,
            );
            Navigator.pop(context, r);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
