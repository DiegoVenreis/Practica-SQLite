import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Tabla SQLite que almacena las tareas del usuario.
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text().withLength(min: 1, max: 500)();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor para pruebas automatizadas con un executor controlado.
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  Stream<List<Tarea>> watchTareas() {
    return (select(tareas)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();
  }

  Future<int> agregarTarea(String titulo) {
    return into(tareas).insert(
      TareasCompanion.insert(titulo: titulo.trim()),
    );
  }

  Future<bool> editarTitulo(int id, String titulo) {
    return (update(tareas)..where((t) => t.id.equals(id))).write(
          TareasCompanion(titulo: Value(titulo.trim())),
        ).then((filas) => filas > 0);
  }

  Future<bool> cambiarCompletada(int id, bool completada) {
    return (update(tareas)..where((t) => t.id.equals(id))).write(
          TareasCompanion(completada: Value(completada)),
        ).then((filas) => filas > 0);
  }

  Future<int> eliminarTarea(int id) {
    return (delete(tareas)..where((t) => t.id.equals(id))).go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'gestor_tareas_local',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}