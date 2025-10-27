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
lib/
 ├─ core/                 # Navegación, temas y widgets base
 ├─ data/                 # Modelos y repositorios en memoria
 ├─ state/                # Controladores con Provider
 ├─ ui/                   # Pantallas y componentes visuales
 │   ├─ vehicles/         # CRUD de Vehículos
 │   ├─ clients/          # CRUD de Clientes
 │   ├─ reservations/     # Gestión de Reservas
 │   └─ deliveries/       # Registro de Entregas
 └─ main.dart             # Punto de entrada


## Datos de ejemplo
Se cargan automáticamente en `main.dart` (vehículos, clientes y una reserva activa).

## Ejecución del proyecto
--Modo desarrollo (debug)
flutter run -d chrome
## Generación de APK
--Debug APK
flutter build apk --debug
Instalar en dispositivo físico (Android-Studio):
adb install -r build/app/outputs/flutter-apk/app-debug.apk
