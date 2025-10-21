import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../state/reservation_controller.dart';
import '../../state/vehicle_controller.dart';
import '../../state/client_controller.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final resC = context.watch<ReservationController>();
    final vehC = context.watch<VehicleController>();
    final cliC = context.watch<ClientController>();

    // Ranking de clientes por cantidad de reservas (activas + histórico)
    final counts = <String, int>{};
    for (final r in [...resC.activas, ...resC.historico]) {
      counts[r.idCliente] = (counts[r.idCliente] ?? 0) + 1;
    }
    final rows = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = rows.take(10).toList();

    String nombreCliente(String id) {
      final c = cliC.items.where((e) => e.idCliente == id).toList();
      return c.isEmpty ? id : '${c.first.nombre} ${c.first.apellido}';
    }

    return AppScaffold(
      title: 'Estadísticas',
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _StatCard(title: 'Reservas activas', value: resC.activas.length.toString())),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(title: 'Vehículos disponibles', value: vehC.items.where((v) => v.disponible).length.toString())),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Top clientes por reservas', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Cliente')),
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Reservas')),
                            ],
                            rows: [
                              for (final e in top)
                                DataRow(cells: [
                                  DataCell(Text(nombreCliente(e.key))),
                                  DataCell(Text(e.key)),
                                  DataCell(Text('${e.value}')),
                                ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
