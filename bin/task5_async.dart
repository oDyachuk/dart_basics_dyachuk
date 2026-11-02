import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_basics_dyachuk/models/student.dart';

void main() async {
  print('=== Dart Async Programming Demo ===');
  await demonstrateFutures();
  await demonstrateStreams();
  await demonstrateFileOperations();
}

List<Student> sampleStudents() => [
      Student(
          id: 'S1',
          firstName: 'Олена',
          lastName: 'Коваль',
          birthDate: DateTime(2004, 3, 12),
          year: 2,
          enrolledCourses: ['CS101'],
          grades: {'CS101': 90}),
      Student(
          id: 'S2',
          firstName: 'Петро',
          lastName: 'Мельник',
          birthDate: DateTime(2005, 7, 1),
          year: 1,
          enrolledCourses: ['CS101'],
          grades: {'CS101': 70}),
      Student(
          id: 'S3',
          firstName: 'Ірина',
          lastName: 'Шевчук',
          birthDate: DateTime(2004, 11, 23),
          year: 2,
          enrolledCourses: ['CS201'],
          grades: {'CS201': 88}),
    ];

Future<String> fetchStudentData(String studentId) async {
  await Future.delayed(const Duration(seconds: 1)); // симуляція API
  if (studentId.isEmpty) {
    throw ArgumentError('Порожній id');
  }
  return '{"id": "$studentId", "status": "active"}';
}

Future<void> saveStudentsToFile(List<Student> students, String filename) async {
  final file = File(filename);
  await file.parent.create(recursive: true);
  final json = jsonEncode(students.map((s) => s.toJson()).toList());
  await file.writeAsString(json);
}

Future<List<Student>> loadStudentsFromFile(String filename) async {
  final file = File(filename);
  if (!await file.exists()) {
    throw FileSystemException('Файл не знайдено', filename);
  }
  final content = await file.readAsString();
  final list = jsonDecode(content) as List<dynamic>;
  return list.map((e) => Student.fromJson(e as Map<String, dynamic>)).toList();
}

Stream<Student> studentStream() async* {
  for (final s in sampleStudents()) {
    await Future.delayed(const Duration(milliseconds: 300));
    yield s;
  }
}

Future<void> demonstrateFutures() async {
  print('\n--- Futures ---');
  final ids = ['S1', 'S2', 'S3'];

  // Послідовно
  var sw = Stopwatch()..start();
  for (final id in ids) {
    await fetchStudentData(id);
  }
  sw.stop();
  print('Послідовно: ${sw.elapsedMilliseconds} мс');

  // Паралельно
  sw = Stopwatch()..start();
  final results = await Future.wait(ids.map(fetchStudentData));
  sw.stop();
  print(
      'Future.wait: ${sw.elapsedMilliseconds} мс, результатів: ${results.length}');
  print('Перший результат: ${results.first}');

  // Обробка помилок
  try {
    await fetchStudentData('');
  } on ArgumentError catch (e) {
    print('Перехоплено помилку: ${e.message}');
  } finally {
    print('finally виконано');
  }

  // Timeout
  try {
    await fetchStudentData('S9').timeout(const Duration(milliseconds: 300));
  } on TimeoutException {
    print('Timeout: відповідь надто повільна');
  }
}

Future<void> demonstrateStreams() async {
  print('\n--- Streams ---');
  await for (final s in studentStream()) {
    print('Отримано: ${s.fullName}');
  }

  final good = await studentStream()
      .where((s) => s.grades.values.any((g) => g >= 80))
      .map((s) => s.lastName)
      .toList();
  print('Студенти з оцінкою >= 80: $good');

  final completer = Completer<void>();
  int count = 0;
  studentStream().listen(
    (s) => count++,
    onDone: () {
      print('listen: потік завершено, елементів: $count');
      completer.complete();
    },
  );
  await completer.future;
}

Future<void> demonstrateFileOperations() async {
  print('\n--- File I/O ---');
  const path = 'data/students.json';
  try {
    await saveStudentsToFile(sampleStudents(), path);
    print('Збережено у $path');
    final loaded = await loadStudentsFromFile(path);
    print('Прочитано ${loaded.length} студентів: $loaded');
    await loadStudentsFromFile('data/missing.json');
  } on FileSystemException catch (e) {
    print('Помилка файлу: ${e.message} (${e.path})');
  }
}
