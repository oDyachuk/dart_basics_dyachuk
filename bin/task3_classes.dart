import 'package:dart_basics_dyachuk/models/course.dart';
import 'package:dart_basics_dyachuk/models/student.dart';
import 'package:dart_basics_dyachuk/models/university.dart';

void main() {
  print('=== University Management System Demo ===');
  runUniversityDemo();
}

void runUniversityDemo() {
  // 1. Університет
  final uni = University(name: 'KNU');
  print('\n1. Створено університет: ${uni.name}');

  // 2. Люди
  final s1 = Student(
      id: 'S1',
      firstName: 'Олена',
      lastName: 'Коваль',
      birthDate: DateTime(2004, 3, 12),
      year: 2);
  final s2 = Student(
      id: 'S2',
      firstName: 'Петро',
      lastName: 'Мельник',
      birthDate: DateTime(2005, 7, 1),
      year: 1);
  final prof = Professor(
      id: 'P1',
      firstName: 'Ірина',
      lastName: 'Бондар',
      birthDate: DateTime(1980, 5, 20),
      department: 'Інформатика',
      salary: 45000);
  uni.addStudent(s1);
  uni.addStudent(s2);
  uni.professors.add(prof);
  print('2. Додано: $s1, $s2, $prof');

  // 3. Курси
  uni.courses.addAll([
    Course(
        id: 'CS101',
        name: 'Основи програмування',
        description: 'Вступ до Dart',
        credits: 5,
        instructor: prof.fullName),
    Course(
        id: 'CS201',
        name: 'ООП',
        description: 'Класи та об\'єкти',
        credits: 5,
        instructor: prof.fullName,
        prerequisites: ['CS101']),
    Course(
        id: 'MA101',
        name: 'Математика',
        description: 'Алгебра',
        credits: 4,
        instructor: 'Т. Лис'),
  ]);
  prof.assignCourse('CS101');
  prof.assignCourse('CS201');
  print('3. Створено курсів: ${uni.courses.length}');

  // 4. Запис на курси
  print('\n4. Доступні курси для S1 до запису: '
      '${uni.getAvailableCoursesForStudent('S1').map((c) => c.id).toList()}');
  s1.enrollInCourse('CS101');
  s1.enrollInCourse('MA101');
  s2.enrollInCourse('CS101');
  print('   Студенти на CS101: ${uni.getStudentsByCourse('CS101')}');

  // 5. Оцінки
  s1.addGrade('CS101', 90);
  s1.addGrade('MA101', 55);
  s2.addGrade('CS101', 70);
  print('\n5. Складені курси S1: ${s1.getPassedCourses()}');
  print('   GPA S1: ${s1.gpa.toStringAsFixed(1)}');
  print('   Доступні для S1 після CS101: '
      '${uni.getAvailableCoursesForStudent('S1').map((c) => c.id).toList()}');

  // Поліморфізм
  final List<Person> people = [s1, s2, prof];
  print('\nПоліморфізм (List<Person>):');
  for (final p in people) {
    print('  ${p.role}: ${p.fullName}, ${p.age} р.');
  }

  // CRUD: пошук і видалення
  print('\nПошук S2: ${uni.findStudentById('S2')}');
  uni.removeStudent('S2');
  print('Після видалення S2 знайдено: ${uni.findStudentById('S2')}');

  // JSON
  final restored = Student.fromJson(s1.toJson());
  print('JSON round-trip: $restored');

  // 6. Статистика
  print('\n6. Статистика:');
  uni.generateStatistics().forEach((k, v) => print('  $k: $v'));
}
