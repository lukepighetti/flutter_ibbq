import 'package:flutter/widgets.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

extension DeviceConnectionStateX on DeviceConnectionState {
  /// Format this as a pretty string
  ///
  /// ie `DeviceConnectionState.connecting.asPrettyString == 'connecting'`
  String get asPrettyString {
    switch (this) {
      case DeviceConnectionState.connecting:
        return 'connecting';
      case DeviceConnectionState.connected:
        return 'connected';
      case DeviceConnectionState.disconnecting:
        return 'disconnecting';
      case DeviceConnectionState.disconnected:
      default:
        return 'disconnected';
    }
  }
}

extension IterableDiscoveredDeviceX on Iterable<DiscoveredDevice> {
  /// Check if this iterable contains a device.
  ///
  /// Compares [DiscoveredDevice.id] to make the determiniation.
  bool containsDevice(DiscoveredDevice device) {
    return any((e) => e.id == device.id);
  }
}

extension WidgetX on Widget {
  /// Add `10px` of horizontal padding
  Widget get withHorizontalPadding =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: this);

  /// Add `0.5` opacity.
  Widget get withTransparency => Opacity(opacity: 0.5, child: this);

  /// Nudge a widget x/y pixels.
  Widget nudge({double x = 0, double y = 0}) =>
      Transform.translate(offset: Offset(x, y), child: this);
}
