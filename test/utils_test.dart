import 'package:dart_basics_dyachuk/utils/calculator.dart';
import 'package:dart_basics_dyachuk/utils/data_processor.dart';
import 'package:dart_basics_dyachuk/utils/math_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Calculator', () {
    final calc = Calculator();
    test('add', () => expect(calc.add(2, 3), 5));
    test('divide', () => expect(calc.divide(10, 4), 2.5));
    test('divide by zero', () {
      expect(() => calc.divide(1, 0), throwsArgumentError);
    });
    test('power', () => expect(calc.power(2, 8), 256));
  });

  group('math', () {
    test('factorial(5)', () => expect(factorial(5), 120));
    test('fibonacci(10)', () => expect(fibonacci(10), 55));
  });

  group('DataProcessor', () {
    test('filterEvenNumbers', () {
      expect(DataProcessor.filterEvenNumbers([1, 2, 3, 4]), [2, 4]);
    });
    test('countWords', () {
      expect(
          DataProcessor.countWords('Dart dart, fun!'), {'dart': 2, 'fun': 1});
    });
  });
}
