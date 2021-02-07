import 'package:bbq/bbq_bluetooth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'extensions.dart';
import 'models/bbq_status.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ble = FlutterReactiveBle();
  final bbq = BBQBluetooth();

  /// List devices feature
  var isScanningForDevices = false;
  var devices = <DiscoveredDevice>{};
  DiscoveredDevice selectedDevice;

  var status = BBQStatus.initial();

  /// Scan for devices and add them to the [devices] list.
  void _scanForDevices() async {
    setState(() {
      isScanningForDevices = true;
    });

    await for (var devices in bbq.scanForDevices()) {
      setState(() {
        this.devices = devices;
      });
    }
  }

  /// Connect to a specific device and start getting temperature updates.
  void _connectToDevice(DiscoveredDevice device) async {
    /// Guard against connecting twice in a row
    if (selectedDevice != null) return;

    setState(() {
      selectedDevice = device;
    });

    await for (var e in bbq.deviceEvents(device)) {
      setState(() {
        status = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),

            if (status.probes.isNotEmpty) ...[
              Text('Probes').withHorizontalPadding,
              Row(
                children: [
                  for (var e in status.probes)
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                '${e.number}',
                                style: theme.textTheme.subtitle1,
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                height: 30,
                                child: Center(
                                  child: e.connected
                                      ? Text(
                                          '${e.temperature}°c',
                                          style: theme.textTheme.headline5,
                                        )
                                      : Icon(Icons.cloud_off),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              )
            ],

            SizedBox(height: 20),
            Spacer(),

            /// List feature
            if (devices.isNotEmpty) ...[
              Text('Found devices').withHorizontalPadding,
              for (var e in devices)
                ListTile(
                  leading: Icon(
                    selectedDevice == e
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ).nudge(y: 8),
                  title: Text(e.name),
                  subtitle: Text(
                    e.id,
                    style: theme.textTheme.caption,
                  ),
                  trailing: () {
                    switch (status.connectionState) {
                      case DeviceConnectionState.connecting:
                        return Icon(Icons.bluetooth_searching);
                      case DeviceConnectionState.connected:
                        return Icon(Icons.bluetooth_connected);
                      case DeviceConnectionState.disconnecting:
                      case DeviceConnectionState.disconnected:
                        return Text('${e.rssi}');
                    }
                  }(),
                  onTap: selectedDevice == e ? null : () => _connectToDevice(e),
                ),
            ],
            ElevatedButton(
              child: Text('Scan for devices'),
              onPressed: isScanningForDevices ? null : () => _scanForDevices(),
            ).withHorizontalPadding,
          ],
        ),
      ),
    );
  }
}
