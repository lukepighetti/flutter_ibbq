class BBQBattery {
  /// The current status of an iBBQ battery.
  BBQBattery(this.maxVoltage, this.voltage, this.isCharging);

  /// The maximum voltage for this battery.
  final double maxVoltage;

  /// The current voltage of this battery.
  final double voltage;

  /// If this battery is currently plugged in and charging.
  final bool isCharging;

  /// The current battery percentage.
  ///
  /// ie 25% remaining is `0.25`
  double get percentage => voltage / maxVoltage;
}
