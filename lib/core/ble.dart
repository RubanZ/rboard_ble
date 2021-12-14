import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEManager {
  static final BLEManager _instance = BLEManager._();

  factory BLEManager() => _instance;

  BLEManager._();

  final _ble = FlutterReactiveBle();

  List<DiscoveredDevice> bleList = [];

  Future<void> init() async {
    return;
  }

  Future<List<DiscoveredDevice>> listDevices() async {
    _ble.scanForDevices(withServices: []).listen((device) {
      bool isExist = false;
      for (DiscoveredDevice _device in bleList) {
        if (_device.id == device.id) {
          isExist = true;
        }
      }
      if (!isExist) {
        bleList.add(device);
      }
    }, onError: (error) {
      // print(error);
    });
    return bleList;
  }
}
