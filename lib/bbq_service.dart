import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'bbq_constants.dart';
import 'models/bbq_probe.dart';

class BBQService {
  static final ble = FlutterReactiveBle();

  /// Create a BBQ service
  static Future<BBQService> create(DiscoveredDevice device) async {
    final services = await ble.discoverServices(device.id);
    final service = services.firstWhere(
        (e) => e.serviceId == BBQConstants.serviceId,
        orElse: () => null);

    if (service == null)
      throw StateError('No suitable services found.');
    else
      return BBQService(device, service);
  }

  /// An iBBQ service that acts on a specific device.
  BBQService(this.device, this.service);

  /// The device with the service
  final DiscoveredDevice device;

  /// The service to communicate with
  final DiscoveredService service;

  BBQCharacteristics get characteristics =>
      BBQCharacteristics(device.id, service.serviceId);

  /// Must be called right after connecting
  Future<void> login() async {
    return ble.writeCharacteristicWithResponse(characteristics.login,
        value: BBQConstants.loginPayload);
  }

  /// Call to enable data flowing on [characteristics.realTimeData]
  Future<void> enableRealtimeData() async {
    return ble.writeCharacteristicWithResponse(characteristics.settingUpdate,
        value: BBQConstants.enableRealtimeDataPayload);
  }

  // /// Call to trigger a battery event on [characteristics.settingResult]
  // Future<void> requestBatteryLevel() async {
  //   return ble.writeCharacteristicWithResponse(characteristics.settingUpdate,
  //       value: BBQPayloads.requestBatteryLevel);
  // }

  /// A stream of temperature events.
  Stream<Set<BBQProbe>> probeEvents() async* {
    final stream = ble.subscribeToCharacteristic(characteristics.realTimeData);

    await for (var data in stream) {
      final buffer = Uint8List.fromList(data).buffer;
      final probeTemps = buffer.asInt16List();
      var probes = <BBQProbe>{};

      for (var i = 0; i < probeTemps.length; i++) {
        final probeNumber = i + 1;
        final temperature = probeTemps[i] / 10;
        final isConnected = temperature > -1.0;
        probes.add(BBQProbe(probeNumber, isConnected, temperature));
      }

      yield probes;
    }
  }
}

class BBQCharacteristics {
  BBQCharacteristics(this.deviceId, this.serviceId);

  /// The device with the service.
  final String deviceId;

  /// The service with these characteristics.
  final Uuid serviceId;

  /// `notify`
  QualifiedCharacteristic get settingResult => _qc('fff1');

  /// `write`
  QualifiedCharacteristic get login => _qc('fff2');

  /// `notify`
  QualifiedCharacteristic get historicData => _qc('fff3');

  /// `notify`
  QualifiedCharacteristic get realTimeData => _qc('fff4');

  /// `write`
  QualifiedCharacteristic get settingUpdate => _qc('fff5');

  QualifiedCharacteristic _qc(String uuidString) {
    return QualifiedCharacteristic(
      characteristicId: Uuid.parse(uuidString),
      serviceId: serviceId,
      deviceId: deviceId,
    );
  }
}
