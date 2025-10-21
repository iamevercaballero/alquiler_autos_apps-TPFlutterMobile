import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'label': 'Vehículos', 'route': '/vehicles', 'icon': Icons.directions_car},
      {'label': 'Clientes', 'route': '/clients', 'icon': Icons.people},
      {'label': 'Reservas', 'route': '/reservations', 'icon': Icons.event},
      {'label': 'Entregas', 'route': '/deliveries', 'icon': Icons.assignment_turned_in},
      {'label': 'Estadísticas', 'route': '/stats', 'icon': Icons.insights},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Alquiler de autos')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          for (final it in items)
            Card(
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, it['route'] as String),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(it['icon'] as IconData, size: 48),
                      const SizedBox(height: 8),
                      Text(it['label'] as String),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
