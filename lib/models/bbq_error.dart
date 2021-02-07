class BBQError extends Error {
  /// A generic error class for `flutter_ibbq`
  BBQError(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'BBQError(message: $message)';
}
