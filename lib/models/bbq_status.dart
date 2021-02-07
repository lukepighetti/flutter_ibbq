import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../bbq_service.dart';
import 'bbq_battery.dart';
import 'bbq_probe.dart';

class BBQStatus {
  /// The current status of a particular device.
  const BBQStatus(
      this.probes, this.connectionState, this.battery, this.service);

  /// The initial status.
  const BBQStatus.initial()
      : probes = const {},
        connectionState = DeviceConnectionState.disconnected,
        battery = null,
        service = null;

  /// The last known temperature readout from all supported probes.
  final Set<BBQProbe> probes;

  /// If we're connected or disconnected from this device.
  final DeviceConnectionState connectionState;

  /// The current status of this battery.
  final BBQBattery battery;

  /// The service for communicating with this specific device.
  final BBQService service;

  BBQStatus copyWith({
    Set<BBQProbe> probes,
    DeviceConnectionState connectionState,
    BBQBattery battery,
    BBQService service,
  }) {
    return BBQStatus(
      probes ?? this.probes,
      connectionState ?? this.connectionState,
      battery ?? this.battery,
      service ?? this.service,
    );
  }

  @override
  String toString() {
    return 'BBQStatus(probes: $probes, connectionState: $connectionState, battery: $battery)';
  }
}
