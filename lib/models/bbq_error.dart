class BBQError extends Error {
  BBQError(this.message);

  final String message;

  @override
  String toString() => 'BBQError(message: $message)';
}
