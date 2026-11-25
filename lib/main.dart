import 'package:flutter/material.dart';
import 'data/database.dart';
import 'screens/tareas_page.dart';

final AppDatabase appDatabase = AppDatabase();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GestorTareasApp());
}

/// Punto de entrada de la aplicación.
/// La configuración del almacenamiento se agregará como parte de la tarea.
class GestorTareasApp extends StatelessWidget {
  final AppDatabase? database;
  
  const GestorTareasApp({super.key, this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TareasPage(database: database ?? appDatabase,),
    );
  }
}
