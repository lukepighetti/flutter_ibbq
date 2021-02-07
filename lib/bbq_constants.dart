import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' show Uuid;

class BBQConstants {
  /// iBBQ protocol devices have a bluetooth name of `iBBQ`
  static const bluetoothName = 'iBBQ';

  /// The service id used by the iBBQ protocol.
  static final serviceId = Uuid.parse('fff0');

  /// The time between battery polling.
  static const batteryPollingInterval = const Duration(seconds: 5);

  /// The max voltage reported during charging.
  static const chargingVoltage = 6615;

  /// The 1 byte header leading a battery level event.
  static const batteryLevelHeader = 0x24;

  /// The payload to send to the `login` characteristic to login.
  ///
  /// Must be called right after connecting to a device or else the host
  /// iBBQ device will timeout by disconnecting.
  static const loginPayload = [
    0x21,
    0x07,
    0x06,
    0x05,
    0x04,
    0x03,
    0x02,
    0x01,
    0xb8,
    0x22,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
  ];

  /// The payload to send to the `settingUpdate` characteristic to start
  /// the realtime data stream.
  static const enableRealtimeDataPayload = [
    0x0B,
    0x01,
    0x00,
    0x00,
    0x00,
    0x00,
  ];

  /// The payload to send to the `settingUpdate` characteristic to request
  /// the battery level.
  static const requestBatteryLevelPayload = [
    0x08,
    0x24,
    0x00,
    0x00,
    0x00,
    0x00,
  ];

  static const voltages = [
    5580,
    5595,
    5609,
    5624,
    5639,
    5644,
    5649,
    5654,
    5661,
    5668,
    5676,
    5683,
    5698,
    5712,
    5727,
    5733,
    5739,
    5744,
    5750,
    5756,
    5759,
    5762,
    5765,
    5768,
    5771,
    5774,
    5777,
    5780,
    5783,
    5786,
    5789,
    5792,
    5795,
    5798,
    5801,
    5807,
    5813,
    5818,
    5824,
    5830,
    5830,
    5830,
    5835,
    5840,
    5845,
    5851,
    5857,
    5864,
    5870,
    5876,
    5882,
    5888,
    5894,
    5900,
    5906,
    5915,
    5924,
    5934,
    5943,
    5952,
    5961,
    5970,
    5980,
    5989,
    5998,
    6007,
    6016,
    6026,
    6035,
    6044,
    6052,
    6062,
    6072,
    6081,
    6090,
    6103,
    6115,
    6128,
    6140,
    6153,
    6172,
    6191,
    6211,
    6230,
    6249,
    6265,
    6280,
    6296,
    6312,
    6328,
    6344,
    6360,
    6370,
    6381,
    6391,
    6407,
    6423,
    6431,
    6439,
    6455
  ];
}
