class HTTPEXCEPTION implements Exception {
  final String message;
  HTTPEXCEPTION(this.message);

  @override
  String toString() {
    return message;
  }
}
