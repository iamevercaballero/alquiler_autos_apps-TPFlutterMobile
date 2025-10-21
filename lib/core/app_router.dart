import 'package:flutter/material.dart';
import '../ui/home_screen.dart';
import '../ui/vehicles/vehicles_screen.dart';
import '../ui/clients/clients_screen.dart';
import '../ui/reservations/reservations_screen.dart';
import '../ui/deliveries/deliveries_screen.dart';
import '../ui/stats/stats_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const HomeScreen(),
    '/vehicles': (_) => const VehiclesScreen(),
    '/clients': (_) => const ClientsScreen(),
    '/reservations': (_) => const ReservationsScreen(),
    '/deliveries': (_) => const DeliveriesScreen(),
    '/stats': (_) => const StatsScreen(),
  };
}
