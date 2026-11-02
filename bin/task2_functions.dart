import 'package:dart_basics_dyachuk/utils/calculator.dart';
import 'package:dart_basics_dyachuk/utils/math_utils.dart';

void main() {
  print('=== Dart Functions Demo ===');
  testBasicFunctions();
  testAdvancedFunctions();
  testFunctionalProgramming();
  testCalculator();
  testTextAnalyzer('Dart is fun. Dart is fast, and Dart is typed!');
}

int calculateSum(int a, int b) => a + b;

double calculateAverage(List<double> numbers) {
  if (numbers.isEmpty) return 0;
  double sum = 0;
  for (final n in numbers) {
    sum += n;
  }
  return sum / numbers.length;
}

String formatName(String firstName, String lastName,
    {String? middleName, bool uppercase = false}) {
  final parts = [firstName, if (middleName != null) middleName, lastName];
  final full = parts.join(' ');
  return uppercase ? full.toUpperCase() : full;
}

void testBasicFunctions() {
  print('\n--- Basic ---');
  print('sum(3, 4) = ${calculateSum(3, 4)}');
  print('average = ${calculateAverage([80, 90.5, 70])}');
  print('average(empty) = ${calculateAverage([])}');
}

void testAdvancedFunctions() {
  print('\n--- Named / optional params, recursion ---');
  print(formatName('Іван', 'Дяченко'));
  print(formatName('Іван', 'Дяченко', middleName: 'Петрович'));
  print(formatName('Іван', 'Дяченко', uppercase: true));
  print('fibonacci(10) = ${fibonacci(10)}');
  print('factorial(5) = ${factorial(5)}');
}

int Function() makeCounter() {
  int count = 0;
  return () => ++count; // замикання захоплює count
}

int applyTwice(int Function(int) f, int x) => f(f(x));

void testFunctionalProgramming() {
  print('\n--- Functional ---');
  final nums = [1, 2, 3, 4, 5, 6];
  print('map x2: ${nums.map((n) => n * 2).toList()}');
  print('where even: ${nums.where((n) => n.isEven).toList()}');
  print('fold sum: ${nums.fold<int>(0, (acc, n) => acc + n)}');
  print('applyTwice(+3, 1) = ${applyTwice((x) => x + 3, 1)}');

  final counter = makeCounter();
  counter();
  counter();
  print('closure counter: ${counter()}');
}

void testCalculator() {
  print('\n--- Calculator ---');
  final calc = Calculator();
  print('10 + 5 = ${calc.add(10, 5)}');
  print('10 - 5 = ${calc.subtract(10, 5)}');
  print('10 * 5 = ${calc.multiply(10, 5)}');
  print('10 / 4 = ${calc.divide(10, 4)}');
  print('2 ^ 8 = ${calc.power(2, 8)}');
  try {
    calc.divide(1, 0);
  } on ArgumentError catch (e) {
    print('Помилка: ${e.message}');
  }
}

void testTextAnalyzer(String text) {
  print('\n--- Text analyzer ---');
  final words = text
      .toLowerCase()
      .replaceAll(RegExp(r'[^\wа-яіїєґ\s]'), '')
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  final freq = <String, int>{};
  for (final w in words) {
    freq[w] = (freq[w] ?? 0) + 1;
  }
  print('Символів: ${text.length}');
  print('Слів: ${words.length}');
  print('Унікальних слів: ${freq.length}');
  print('Частоти: $freq');
}
