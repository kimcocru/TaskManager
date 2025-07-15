import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:task_manager/models/task.dart';

class ExportFileUtils {
  Future<File> exportTasksToCSV(List<Task> tasks) async {
    List<List<dynamic>> rows = [
      ['ID', 'Título', 'Descripción', 'Fecha Límite', 'Estado']
    ];

    for (var task in tasks) {
      rows.add([
        task.id,
        task.title,
        task.description ?? '',
        task.deadline?.toIso8601String() ?? '',
        task.isCompleted ? 'Completada' : 'Pendiente',
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/tareas_exportadas.csv';
    final file = File(path);

    return await file.writeAsString(csvData);
  }
}
