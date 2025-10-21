import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../state/reservation_controller.dart';
import '../../core/utils/date_format.dart';
import '../../data/models/reservation.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Entregas',
      body: Consumer<ReservationController>(
        builder: (_, c, __) {
          final activas = c.activas;
          if (activas.isEmpty) {
            return const Center(child: Text('No hay reservas activas'));
          }
          return ListView.builder(
            itemCount: activas.length,
            itemBuilder: (_, i) {
              final r = activas[i];
              return ListTile(
                leading: const Icon(Icons.assignment_turned_in),
                title: Text('Reserva ${r.idReserva} • Vehículo ${r.idVehiculo}'),
                subtitle: Text('Cliente ${r.idCliente} • ${fmtDate(r.fechaInicio)} → ${fmtDate(r.fechaFin)}'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final data = await showDialog<_DeliveryData>(
                      context: context,
                      builder: (_) => _DeliveryDialog(reserva: r),
                    );
                    if (!context.mounted) return;
                    if (data != null) {
                      context.read<ReservationController>().complete(
                        r.idReserva,
                        data.fechaEntregaReal,
                        obs: data.observaciones?.trim().isEmpty == true ? null : data.observaciones,
                        kmFinal: data.kmFinal,
                      );
                      final m = ScaffoldMessenger.of(context);
                      m.clearSnackBars();
                      m.showSnackBar(
                        SnackBar(content: Text('Entrega de ${r.idVehiculo} completada')),
                      );
                    }
                  },
                  child: const Text('Completar'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// ----- Diálogo de entrega -----

class _DeliveryData {
  final DateTime fechaEntregaReal;
  final int? kmFinal;
  final String? observaciones;
  _DeliveryData({required this.fechaEntregaReal, this.kmFinal, this.observaciones});
}

class _DeliveryDialog extends StatefulWidget {
  final Reservation reserva;
  const _DeliveryDialog({required this.reserva});

  @override
  State<_DeliveryDialog> createState() => _DeliveryDialogState();
}

class _DeliveryDialogState extends State<_DeliveryDialog> {
  final _formKey = GlobalKey<FormState>();
  final kmCtrl = TextEditingController();
  final obsCtrl = TextEditingController();
  late DateTime fechaReal;

  @override
  void initState() {
    super.initState();
    fechaReal = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reserva;

    return AlertDialog(
      title: Text('Completar entrega (${r.idReserva})'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text('Fecha real: ${fmtDate(fechaReal)}')),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: fechaReal,
                        firstDate: r.fechaInicio, // no permitir antes del inicio
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => fechaReal = picked);
                    },
                    child: const Text('Elegir'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: kmCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kilometraje final (opcional)',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // opcional
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 0) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: obsCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reserva: ${fmtDate(r.fechaInicio)} → ${fmtDate(r.fechaFin)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
            if (fechaReal.isBefore(r.fechaInicio)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('La fecha real no puede ser anterior al inicio')),
              );
              return;
            }
            final km = kmCtrl.text.trim().isEmpty ? null : int.parse(kmCtrl.text.trim());
            final data = _DeliveryData(
              fechaEntregaReal: fechaReal,
              kmFinal: km,
              observaciones: obsCtrl.text,
            );
            Navigator.pop(context, data);
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
