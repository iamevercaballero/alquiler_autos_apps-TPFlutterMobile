# alquiler_autos_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

# TP Frontend — Alquiler de Autos (Flutter)

Este proyecto del Segundo Parcial (mobile con Flutter, sin backend, datos en memoria).
Incluye CRUD de Vehículos/Clientes, Reservas, Entregas y pantalla de Estadísticas.

## Requisitos
- Flutter SDK (canal estable)
- Android Studio o VS Code con extensiones Flutter/Dart

## Primer uso
Si al abrir falla por faltar carpetas `android/ios/web`, generar plataformas con:
```bash
flutter create .
```
Luego:
```bash
flutter pub get
flutter run
```

## Estructura
- `lib/core` navegación y widgets comunes
- `lib/data` modelos, repositorios y persistencia opcional (SharedPreferences)
- `lib/state` controladores (Provider + ChangeNotifier)
- `lib/ui` pantallas

## Datos de ejemplo
Se cargan automáticamente en `main.dart` (vehículos, clientes y una reserva activa).

