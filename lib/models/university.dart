import 'course.dart';
import 'person.dart';
import 'student.dart';

export 'person.dart';

class Professor extends Person {
  final String department;
  final List<String> taughtCourses;
  final double salary;

  Professor({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required this.department,
    required this.salary,
    List<String>? taughtCourses,
  }) : taughtCourses = taughtCourses ?? [];

  @override
  String get role => 'Professor';

  void assignCourse(String courseId) {
    if (!taughtCourses.contains(courseId)) taughtCourses.add(courseId);
  }

  @override
  String toString() => 'Professor($fullName, кафедра $department)';
}

class University {
  final String name;
  final List<Student> students;
  final List<Professor> professors;
  final List<Course> courses;

  University({
    required this.name,
    List<Student>? students,
    List<Professor>? professors,
    List<Course>? courses,
  })  : students = students ?? [],
        professors = professors ?? [],
        courses = courses ?? [];

  void addStudent(Student student) {
    if (findStudentById(student.id) != null) {
      throw StateError('Студент ${student.id} уже існує');
    }
    students.add(student);
  }

  void removeStudent(String studentId) {
    students.removeWhere((s) => s.id == studentId);
  }

  Student? findStudentById(String id) =>
      students.where((s) => s.id == id).firstOrNull;

  List<Student> getStudentsByCourse(String courseId) =>
      students.where((s) => s.enrolledCourses.contains(courseId)).toList();

  List<Course> getAvailableCoursesForStudent(String studentId) {
    final student = findStudentById(studentId);
    if (student == null) return [];
    return courses.where((c) => c.canStudentEnroll(student)).toList();
  }

  Map<String, dynamic> generateStatistics() {
    final avgGpa = students.isEmpty
        ? 0.0
        : students.fold<double>(0, (a, s) => a + s.gpa) / students.length;
    final enrollments = <String, int>{
      for (final c in courses) c.id: getStudentsByCourse(c.id).length,
    };
    final top = students.isEmpty
        ? null
        : students.reduce((a, b) => a.gpa >= b.gpa ? a : b);
    return {
      'university': name,
      'students': students.length,
      'professors': professors.length,
      'courses': courses.length,
      'averageGpa': double.parse(avgGpa.toStringAsFixed(2)),
      'topStudent': top?.fullName,
      'enrollmentsPerCourse': enrollments,
    };
  }
}
