class BBQProbe {
  BBQProbe(this.number, this.connected, this.temperature);
  final int number;
  final bool connected;
  final double temperature;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BBQProbe &&
        o.number == number &&
        o.connected == connected &&
        o.temperature == temperature;
  }

  @override
  int get hashCode =>
      number.hashCode ^ connected.hashCode ^ temperature.hashCode;

  @override
  String toString() =>
      'BBQProbe(number: $number, connected: $connected, temperature: $temperature)';
}
