import 'package:dart_basics_dyachuk/models/course.dart';
import 'package:dart_basics_dyachuk/models/student.dart';
import 'package:dart_basics_dyachuk/models/university.dart';
import 'package:test/test.dart';

Student makeStudent() => Student(
    id: 'S1',
    firstName: 'Олена',
    lastName: 'Коваль',
    birthDate: DateTime(2004, 3, 12));

void main() {
  group('Student', () {
    test('fullName', () => expect(makeStudent().fullName, 'Олена Коваль'));

    test('gpa порожній = 0', () => expect(makeStudent().gpa, 0));

    test('gpa середнє', () {
      final s = makeStudent()
        ..addGrade('A', 80)
        ..addGrade('B', 60);
      expect(s.gpa, 70);
    });

    test('getPassedCourses >= 60', () {
      final s = makeStudent()
        ..addGrade('A', 59)
        ..addGrade('B', 60);
      expect(s.getPassedCourses(), ['B']);
    });

    test('некоректна оцінка', () {
      expect(() => makeStudent().addGrade('A', 101), throwsArgumentError);
    });

    test('toJson/fromJson', () {
      final s = makeStudent()
        ..enrollInCourse('A')
        ..addGrade('A', 75);
      final r = Student.fromJson(s.toJson());
      expect(r.id, s.id);
      expect(r.grades['A'], 75);
    });
  });

  group('Course', () {
    final c = Course(
        id: 'CS201',
        name: 'ООП',
        description: '',
        credits: 5,
        instructor: 'X',
        prerequisites: ['CS101']);

    test('без пререквізиту не можна', () {
      expect(c.canStudentEnroll(makeStudent()), isFalse);
    });

    test('з пререквізитом можна', () {
      final s = makeStudent()..addGrade('CS101', 80);
      expect(c.canStudentEnroll(s), isTrue);
    });
  });

  group('University', () {
    test('CRUD', () {
      final u = University(name: 'U');
      u.addStudent(makeStudent());
      expect(u.findStudentById('S1'), isNotNull);
      u.removeStudent('S1');
      expect(u.findStudentById('S1'), isNull);
    });
  });
}
