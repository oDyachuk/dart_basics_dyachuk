import 'person.dart';

class Student extends Person {
  final int year;
  final List<String> enrolledCourses;
  final Map<String, double> grades;

  Student({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    this.year = 1,
    List<String>? enrolledCourses,
    Map<String, double>? grades,
  })  : enrolledCourses = enrolledCourses ?? [],
        grades = grades ?? {};

  @override
  String get role => 'Student';

  double get gpa {
    if (grades.isEmpty) return 0;
    final sum = grades.values.fold<double>(0, (a, b) => a + b);
    return sum / grades.length;
  }

  void enrollInCourse(String courseId) {
    if (!enrolledCourses.contains(courseId)) {
      enrolledCourses.add(courseId);
    }
  }

  void addGrade(String courseId, double grade) {
    if (grade < 0 || grade > 100) {
      throw ArgumentError('Оцінка має бути в діапазоні 0..100');
    }
    grades[courseId] = grade;
  }

  List<String> getPassedCourses() =>
      grades.entries.where((e) => e.value >= 60).map((e) => e.key).toList();

  @override
  String toString() =>
      'Student($id, $fullName, рік $year, GPA ${gpa.toStringAsFixed(1)})';

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate.toIso8601String(),
        'year': year,
        'enrolledCourses': enrolledCourses,
        'grades': grades,
      };

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      year: json['year'] as int,
      enrolledCourses: List<String>.from(json['enrolledCourses'] as List),
      grades: (json['grades'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }
}
