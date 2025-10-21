### Quick context

- This is a small Flutter app for car rentals (Spanish: "alquiler de autos").
- App entrypoint: `lib/main.dart`. Routing lives in `lib/core/app_router.dart`.
- State is managed with simple ChangeNotifier controllers in `lib/state/*_controller.dart` (VehicleController, ClientController, ReservationController).
- Data layer uses an in-memory store (`lib/data/repositories/memory_store.dart`) with thin repository wrappers under `lib/data/repositories/*.dart`. Persistence helpers exist in `lib/data/persistence/local_prefs.dart` using `shared_preferences`.

### Architecture & data flow (short)

- UI screens live under `lib/ui/*/*.dart`. Screens get controllers via `Provider` (see `main.dart` MultiProvider setup). Controllers call repository methods which mutate the global `MemoryStore` instance (injected at app startup).
- Repositories are synchronous and operate directly on lists in `MemoryStore`; domain models are in `lib/data/models/` (Vehicle, Client, Reservation).
- Reservations interact with vehicles: `ReservationRepository.add` marks a vehicle unavailable; `completeDelivery` marks it available again. Any change to repositories should maintain this invariant.

### Important project conventions

- Single global MemoryStore seeded in `main()` and passed into repositories; do not create secondary stores unless intentionally mocking tests.
- Controllers extend `ChangeNotifier` and call `notifyListeners()` after repository operations. When adding or updating behavior, follow this pattern so UI updates correctly.
- Repositories throw plain Exceptions for domain errors (e.g., vehicle not found / not available). Keep error messages short and Spanish where present (existing messages are Spanish).
- Routing is static: use `AppRouter.routes` map for new screens (no nested or generated routes currently).

### Files to consult for examples

- App bootstrap: `lib/main.dart` (provider wiring, sample seeding).
- Routes: `lib/core/app_router.dart`.
- State example: `lib/state/client_controller.dart`.
- Repository examples: `lib/data/repositories/reservation_repository.dart`, `vehicle_repository.dart`.
- Persistence helper: `lib/data/persistence/local_prefs.dart`.

### Recommended small tasks for agents (safe, discoverable changes)

- Add a new screen: create UI under `lib/ui/<feature>/...`, register route in `AppRouter.routes`, and expose necessary controllers via Provider in `main.dart` if it needs state.
- Add repository method: follow pattern in existing repositories (synchronous list ops, clear Spanish error messages, keep invariants for vehicle availability when affecting reservations).
- Add unit/widget tests: project uses `test/widget_test.dart`. Prefer adding focused widget tests for new screens and small unit tests for repository logic.

### Build/test/debug hints

- Build & run: standard Flutter commands (e.g., `flutter run -d <device>`). The project is a normal Flutter app with Android/iOS/web/desktop folders present.
- Tests: `flutter test` will run unit/widget tests. Existing test references `lib/main.dart`.
- Lints/format: the repo contains `analysis_options.yaml` and standard Flutter tooling; prefer `dart format .` and `flutter analyze`.

### Integration points & external deps

- `shared_preferences` is used in `lib/data/persistence/local_prefs.dart`. Persistence is currently minimal; if adding persistent storage, keep calls isolated in `data/persistence`.
- No network or backend integration currently — all data is in-memory. For adding backend sync, introduce a service layer under `lib/data/services/` and keep repositories thin facades that can switch between MemoryStore and remote sources.

### Language and style notes

- Source code mixes Spanish identifiers/comments/messages (e.g., `idVehiculo`, `disponible`, Spanish exception text). Preserve Spanish for domain texts and user-facing strings unless asked otherwise.
- Use Material 3 style (see `ThemeData(useMaterial3: true)` in `main.dart`).

### Quick examples (use these exact paths)

- To mark a vehicle available after delivery: see `lib/data/repositories/reservation_repository.dart` -> `completeDelivery`.
- To filter vehicles by marca/modelo: see `lib/data/repositories/vehicle_repository.dart` -> `all({String? filtro})`.

If anything is unclear or you need additional project-specific rules (naming, testing conventions, or CI commands), tell me which area to expand and I'll iterate.
