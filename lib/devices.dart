import 'package:flutter/material.dart';
import 'package:rboard_ble/core/ble.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  static const routeName = 'devices';

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List<DiscoveredDevice> deviceList = [];

  Future<void> getList() async {
    var res = await BLEManager().listDevices();

    setState(() {
      deviceList = res;
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  Widget _cardDevice(DiscoveredDevice device) {
    return Stack(
      children: [
        Material(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          elevation: 8.0,
          child: Hero(
            tag: "tag1",
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 0, 100, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              height: 120.0,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${device.name}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color.fromRGBO(255, 255, 255, 1.0)),
              ),
              Text("${device.id}")
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Список устроств'), actions: <Widget>[
          IconButton(onPressed: getList, icon: const Icon(Icons.refresh))
        ]),
        body: ListView.separated(
          itemBuilder: (context, index) {
            return _cardDevice(deviceList[index]);
          },
          itemCount: deviceList.length,
          padding: EdgeInsets.all(16.0),
          separatorBuilder: (context, index) => const Divider(),
        ));
  }
}
