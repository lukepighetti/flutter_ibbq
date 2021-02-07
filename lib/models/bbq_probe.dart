class BBQProbe {
  /// The current status of a iBBQ probe.
  BBQProbe(this.number, this.connected, this.temperature);

  /// The probe number.
  ///
  /// ie probe number `1` of 4.
  final int number;

  /// If the probe is currently connected.
  final bool connected;

  /// The temperature in celcius.
  ///
  /// Is `-1.0` when the probe is disconnected
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
