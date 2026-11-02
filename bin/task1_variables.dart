import 'dart:math';

void main() {
  print('=== Dart Variables & Types Demo ===');
  demonstrateNumbers();
  demonstrateStrings();
  demonstrateBooleans();
  demonstrateCollections();
  demonstrateNullSafety();
}

void demonstrateNumbers() {
  print('\n--- Numbers ---');
  int count = 7;
  double price = 19.99;
  num anything = 5; // num може бути і int, і double
  anything = 5.5;
  print('int: $count, double: $price, num: $anything');

  print('Додавання: ${count + price}');
  print('Ділення: ${count / 2}'); // завжди double
  print('Цілочисельне ділення: ${count ~/ 2}');
  print('Остача: ${count % 2}');
  print('Степінь: ${pow(2, 10)}');
  print('sqrt(144) = ${sqrt(144)}');

  // Конвертація типів
  int parsed = int.parse('42');
  double parsedD = double.parse('3.14');
  int? bad = int.tryParse('abc'); // null, якщо не число
  print('parse: $parsed, $parsedD, tryParse("abc") = $bad');
  print('3.7.toInt() = ${3.7.toInt()}, 5.toDouble() = ${5.toDouble()}');
  print('round: ${3.65.round()}, ceil: ${3.1.ceil()}, floor: ${3.9.floor()}');
  print('toStringAsFixed(2): ${3.14159.toStringAsFixed(2)}');
}

void demonstrateStrings() {
  print('\n--- Strings ---');
  String first = 'Іван';
  String last = "Дяченко";
  print('Інтерполяція: $first $last, довжина імені: ${first.length}');

  String multi = '''
Рядок 1
Рядок 2
Рядок 3''';
  print(multi);
  print('Escape: табуляція\tтут, лапки: "ok", слеш: \\');
  print(r'Raw string: \n не обробляється');

  String text = '  Dart is Awesome  ';
  print('trim: "${text.trim()}"');
  print('upper: ${text.toUpperCase()}');
  print('lower: ${text.toLowerCase()}');
  print('contains "Dart": ${text.contains('Dart')}');
  print('replaceAll: ${text.replaceAll('Awesome', 'Fun')}');
  print('split: ${text.trim().split(' ')}');
  print('substring(2, 6): ${text.trim().substring(2, 6)}');
  print('startsWith: ${text.trim().startsWith('Dart')}');
  print('padLeft: ${'7'.padLeft(3, '0')}');
  print('Повтор: ${'ab' * 3}');
}

void demonstrateBooleans() {
  print('\n--- Booleans ---');
  int a = int.parse('10');
  int b = int.parse('20');
  bool isGreater = a > b;
  bool isEqual = a == b;
  print('a > b: $isGreater, a == b: $isEqual, a != b: ${a != b}');

  bool hasTicket = int.parse('1') == 1;
  bool isAdult = a >= 18;
  print('AND: ${hasTicket && isAdult}');
  print('OR: ${hasTicket || isAdult}');
  print('NOT: ${!hasTicket}');

  String result = a > 5 ? 'a більше 5' : 'a не більше 5';
  print('Тернарний оператор: $result');

  if (a < b && b < 30) {
    print('Умова if: a < b < 30');
  } else if (a == b) {
    print('Рівні');
  } else {
    print('Інакше');
  }
}

void demonstrateCollections() {
  print('\n--- Collections ---');
  // List
  List<int> numbers = [5, 3, 8, 1];
  numbers.add(10);
  numbers.addAll([2, 4]);
  numbers.remove(8);
  numbers.sort();
  print('List: $numbers, перший: ${numbers.first}, останній: ${numbers.last}');
  print('Індекс 2: ${numbers[2]}, contains(3): ${numbers.contains(3)}');
  print('map x2: ${numbers.map((n) => n * 2).toList()}');

  // Set (унікальні значення)
  List<String> rawTags = ['dart', 'flutter', 'dart'];
  Set<String> tags = rawTags.toSet(); // дублікати зникають
  tags.add('mobile');
  print('Список: $rawTags -> Set: $tags, довжина: ${tags.length}');
  Set<String> other = {'flutter', 'web'};
  print('union: ${tags.union(other)}');
  print('intersection: ${tags.intersection(other)}');

  // Map
  Map<String, int> ages = {'Олена': 20, 'Петро': 22};
  ages['Ірина'] = 19;
  ages.remove('Петро');
  ages.putIfAbsent('Максим', () => 21);
  print('Map: $ages, ключі: ${ages.keys}, значення: ${ages.values}');
  print('containsKey: ${ages.containsKey('Олена')}');
  ages.forEach((name, age) => print('  $name -> $age'));
}

String? findNickname(bool exists) => exists ? 'DartDev' : null;

String describe({required String name, int age = 0}) =>
    'Ім\'я: $name, вік: $age';

void demonstrateNullSafety() {
  print('\n--- Null Safety ---');
  String? nick1 = findNickname(true);
  String? nick2 = findNickname(false);

  print('nick1 = $nick1, nick2 = $nick2');
  print('?? : ${nick2 ?? 'немає нікнейма'}');
  print('?. : ${nick2?.length}'); // null, без помилки
  print('?. : ${nick1?.length}');
  print('! : ${nick1!.toUpperCase()}'); // впевнені, що не null

  nick2 ??= 'Гість'; // присвоїти, якщо null
  print('після ??= : $nick2');

  // late: ініціалізація відкладена
  late String config;
  config = 'завантажено';
  print('late: $config');

  print(describe(name: 'Олег', age: 21));
  print(describe(name: 'Анна'));
}
