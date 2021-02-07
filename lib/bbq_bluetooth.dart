import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'bbq_constants.dart';
import 'bbq_service.dart';
import 'extensions.dart';
import 'models/bbq_status.dart';

class BBQBluetooth {
  static final ble = FlutterReactiveBle();

  /// List devices feature
  final devices = <DiscoveredDevice>{};

  /// Scan for iBBQ devices.
  Stream<Set<DiscoveredDevice>> scanForDevices() async* {
    final stream = ble.scanForDevices(
        withServices: [BBQConstants.serviceId], scanMode: ScanMode.lowLatency);

    await for (var device in stream) {
      if (devices.containsDevice(device) == false) {
        devices.add(device);
        yield devices;
      }
    }
  }

  Stream<BBQStatus> deviceEvents(DiscoveredDevice device) async* {
    var status = BBQStatus({}, DeviceConnectionState.disconnected, null);

    /// Device connection status events
    await for (var e in ble.connectToDevice(id: device.id)) {
      /// Update connection state if there's new data
      if (e.connectionState != status.connectionState) {
        status = status.copyWith(connectionState: e.connectionState);
      }

      /// Continue if we're not connected
      if (e.connectionState != DeviceConnectionState.connected) continue;

      final service = await BBQService.create(device);
      status = status.copyWith(service: service);

      await service.login();
      await service.enableRealtimeData();

      /// Temperature probe events
      await for (var e in service.probeEvents()) {
        status = status.copyWith(probes: e);
        yield status;
      }

      print('It does go beyond probe events!');
    }
  }
}
