import '../models/student.dart';
import '../models/university.dart';

class DataProcessor {
  // ---------- Lists ----------
  static List<int> filterEvenNumbers(List<int> numbers) =>
      numbers.where((n) => n.isEven).toList();

  static Map<String, int> countWords(String text) {
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\p{L}\s]', unicode: true), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty);
    final result = <String, int>{};
    for (final w in words) {
      result[w] = (result[w] ?? 0) + 1;
    }
    return result;
  }

  static List<Map<String, dynamic>> sortStudentsByGPA(List<Student> students) {
    final sorted = [...students]..sort((a, b) => b.gpa.compareTo(a.gpa));
    return sorted
        .map((s) => {
              'id': s.id,
              'name': s.fullName,
              'gpa': double.parse(s.gpa.toStringAsFixed(2)),
            })
        .toList();
  }

  // ---------- Sets ----------
  static Set<String> getUniqueCourses(List<Student> students) =>
      students.expand((s) => s.enrolledCourses).toSet();

  static Set<String> findCommonCourses(List<Student> students) {
    if (students.isEmpty) return {};
    var common = students.first.enrolledCourses.toSet();
    for (final s in students.skip(1)) {
      common = common.intersection(s.enrolledCourses.toSet());
    }
    return common;
  }

  // ---------- Maps ----------
  static Map<String, List<Student>> groupStudentsByYear(
      List<Student> students) {
    final groups = <String, List<Student>>{};
    for (final s in students) {
      groups.putIfAbsent('Рік ${s.year}', () => []).add(s);
    }
    return groups;
  }

  static Map<String, double> calculateAverageGradesByCourse(
      List<Student> students) {
    final sums = <String, double>{};
    final counts = <String, int>{};
    for (final s in students) {
      s.grades.forEach((course, grade) {
        sums[course] = (sums[course] ?? 0) + grade;
        counts[course] = (counts[course] ?? 0) + 1;
      });
    }
    return {
      for (final c in sums.keys)
        c: double.parse((sums[c]! / counts[c]!).toStringAsFixed(2)),
    };
  }

  // ---------- Advanced ----------
  static List<Map<String, dynamic>> generateReport(University university) {
    return university.students
        .map((s) => {
              'id': s.id,
              'name': s.fullName,
              'year': s.year,
              'gpa': double.parse(s.gpa.toStringAsFixed(2)),
              'courses': s.enrolledCourses.length,
              'passed': s.getPassedCourses().length,
              'status': s.gpa >= 85
                  ? 'відмінник'
                  : s.gpa >= 60
                      ? 'норма'
                      : 'ризик',
            })
        .toList();
  }

  // ---------- CSV ----------
  static List<Student> parseCsv(String content) {
    final lines = content
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final students = <Student>[];
    for (final line in lines.skip(1)) {
      final p = line.split(',');
      final s = Student(
        id: p[0],
        firstName: p[1],
        lastName: p[2],
        birthDate: DateTime.parse(p[3]),
        year: int.parse(p[4]),
      );
      for (final item in p[5].split(';')) {
        final kv = item.split(':');
        s.enrollInCourse(kv[0]);
        s.addGrade(kv[0], double.parse(kv[1]));
      }
      students.add(s);
    }
    return students;
  }
}
