int fibonacci(int n) {
  if (n < 0) throw ArgumentError('n має бути >= 0');
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

int factorial(int n) {
  if (n < 0) throw ArgumentError('n має бути >= 0');
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}
