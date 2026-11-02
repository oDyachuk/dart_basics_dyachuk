import 'dart:io';

import 'package:dart_basics_dyachuk/models/university.dart';
import 'package:dart_basics_dyachuk/utils/data_processor.dart';

void main() {
  print('=== Dart Collections & Data Processing Demo ===');
  demonstrateLists();
  demonstrateSets();
  demonstrateMaps();
  demonstrateAdvancedOperations();
}

void demonstrateLists() {
  print('\n--- Lists ---');
  final nums = [7, 2, 9, 4, 6, 1, 8];
  print('Парні: ${DataProcessor.filterEvenNumbers(nums)}');
  print('map x^2: ${nums.map((n) => n * n).toList()}');
  print('where >5: ${nums.where((n) => n > 5).toList()}');
  print('fold sum: ${nums.fold<int>(0, (a, b) => a + b)}');
  print('reduce max: ${nums.reduce((a, b) => a > b ? a : b)}');
  final sorted = [...nums]..sort();
  print('sorted: $sorted');
  final desc = [...nums]..sort((a, b) => b.compareTo(a));
  print('sorted desc: $desc');
  print(
      'any >8: ${nums.any((n) => n > 8)}, every >0: ${nums.every((n) => n > 0)}');
}

void demonstrateSets() {
  print('\n--- Sets ---');
  final a = {'CS101', 'MA101', 'EN101'};
  final b = {'CS101', 'CS201', 'EN101'};
  print('union: ${a.union(b)}');
  print('intersection: ${a.intersection(b)}');
  print('difference a-b: ${a.difference(b)}');
}

void demonstrateMaps() {
  print('\n--- Maps ---');
  final text = 'Dart is fun and Dart is fast. Fast and fun!';
  final freq = DataProcessor.countWords(text);
  print('Частоти слів: $freq');
  final top = freq.entries.toList()..sort((x, y) => y.value.compareTo(x.value));
  print('Топ-3: ${top.take(3).map((e) => '${e.key}=${e.value}').toList()}');
  final inverted = freq.map((k, v) => MapEntry(k.toUpperCase(), v));
  print('Ключі у верхньому регістрі: $inverted');
}

void demonstrateAdvancedOperations() {
  print('\n--- Advanced: аналіз студентів із CSV ---');
  final file = File('data/students.csv');
  if (!file.existsSync()) {
    print('Файл data/students.csv не знайдено. Запускайте з кореня проєкту.');
    return;
  }
  final students = DataProcessor.parseCsv(file.readAsStringSync());
  final uni = University(name: 'KNU', students: students);

  final buffer = StringBuffer()..writeln('=== ЗВІТ ПО СТУДЕНТАХ ===');

  buffer.writeln('\nРейтинг за GPA:');
  for (final row in DataProcessor.sortStudentsByGPA(students)) {
    buffer.writeln('  ${row['name']}: ${row['gpa']}');
  }

  buffer.writeln('\nГрупування за роком:');
  DataProcessor.groupStudentsByYear(students).forEach((year, list) {
    buffer.writeln('  $year: ${list.map((s) => s.lastName).join(', ')}');
  });

  buffer.writeln('\nСередні оцінки по курсах:');
  DataProcessor.calculateAverageGradesByCourse(students)
      .forEach((c, avg) => buffer.writeln('  $c: $avg'));

  buffer.writeln(
      '\nУнікальні курси: ${DataProcessor.getUniqueCourses(students)}');
  buffer.writeln(
      'Спільні курси всіх: ${DataProcessor.findCommonCourses(students)}');

  buffer.writeln('\nДетальний звіт:');
  for (final r in DataProcessor.generateReport(uni)) {
    buffer.writeln('  $r');
  }

  buffer.writeln('\nСтатистика: ${uni.generateStatistics()}');

  print(buffer);
  File('data/report.txt').writeAsStringSync(buffer.toString());
  print('Звіт збережено в data/report.txt');
}
