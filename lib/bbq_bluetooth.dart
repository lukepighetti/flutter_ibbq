import 'package:bbq/models/bbq_probe.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';

import 'bbq_constants.dart';
import 'bbq_service.dart';
import 'extensions.dart';
import 'models/bbq_battery.dart';
import 'models/bbq_status.dart';

class BBQBluetooth {
  static final ble = FlutterReactiveBle();

  /// List devices feature
  final devices = <DiscoveredDevice>{};

  /// Scan for iBBQ devices.
  Stream<Set<DiscoveredDevice>> scanForDevices() async* {
    final stream = ble.scanForDevices(
        withServices: [BBQConstants.serviceId], scanMode: ScanMode.lowLatency);

    /// When a new device is found
    await for (var device in stream) {
      /// Guard against devices without the `iBBQ` bluetooth name.
      if (device.name != BBQConstants.bluetoothName) return;

      /// Add the device to the list if it's new.
      if (devices.containsDevice(device) == false) {
        devices.add(device);
        yield devices;
      }
    }
  }

  Stream<BBQStatus> deviceEvents(DiscoveredDevice device) async* {
    var status = BBQStatus.initial();

    /// Device connection status events
    await for (var e in ble.connectToDevice(id: device.id)) {
      /// Update connection state if there's new data
      if (e.connectionState != status.connectionState) {
        status = status.copyWith(connectionState: e.connectionState);
      }

      /// Continue if we're not connected
      if (e.connectionState != DeviceConnectionState.connected) continue;

      final service = await BBQService.setup(device);
      status = status.copyWith(service: service);

      /// Subscribe to all iBBQ events
      final combinedStream =
          CombineLatestStream.combine2<Set<BBQProbe>, BBQBattery, BBQStatus>(
        service.probeEvents(),
        service.batteryEvents(),
        (a, b) {
          status = status.copyWith(probes: a, battery: b);
          return status;
        },
      );

      /// Temperature probe and battery events
      await for (var e in combinedStream) {
        status = e;
        yield status;
      }
    }
  }
}
