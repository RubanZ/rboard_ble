import 'widget/card.dart';
import 'package:flutter/material.dart';
import 'package:rx_ble/rx_ble.dart';
import 'dart:math';
import 'ble.dart';
import 'dashboard.dart';

class ListDevices extends StatelessWidget {
  var returnValue = 0;
  final results = <String, ScanResult>{};
  List<String> resultsId = [];
  List colors = [
    Colors.lightGreen[100],
    Colors.redAccent[100],
    Colors.orangeAccent[100],
    Colors.lightGreenAccent[100],
    Colors.lightBlueAccent[100],
    Colors.tealAccent[100],
    Colors.greenAccent[100]
  ];

  Color randomColor(var id) {
    if (id > colors.length) id = colors.length - 1;
    return colors[id];
  }

  Widget loading(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            backgroundColor: Color(0xFFECECEC),
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black.withOpacity(0.65),
            ),
          ),
          Text(message)
        ],
      ),
    );
  }

  Widget cardDevice(BuildContext context, ScanResult device) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: SelectionCard(
        backgroundColor: randomColor(resultsId.indexOf(device.deviceName)),
        backgroundHeroTag: "${device.deviceName}",
        contentHeader: Text("${device.deviceName}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        contentText: Text("${device.deviceId}"),
        // onTap: () {
        //   Navigator.push(
        //       context,
        //       new MaterialPageRoute(
        //           builder: (BuildContext context) =>
        //               new Dashboard(device: device)));
        // },
        onTap: () async {
          await for (final state in RxBle.connect(device.deviceId)) {
            if (state == BleConnectionState.connected) {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new Dashboard(device: device)));
            }
            // return loading("Подключение");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RBoard'),
      ),
      body: FutureBuilder(
        future: RxBle.hasAccess(),
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return BLEError();
          } else {
            return StreamBuilder(
              stream: RxBle.startScan(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data.deviceName != null) {
                      results[snapshot.data.deviceName] = snapshot.data;
                      if (resultsId.indexOf(snapshot.data.deviceName) == -1) {
                        resultsId.add(snapshot.data.deviceName);
                      }
                    }
                  }
                  if (results.length > 0) {
                    return SafeArea(
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Доступные устройства",
                                  ),
                                  for (var scanResult in results.values)
                                    cardDevice(context, scanResult)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
                return loading("Поиск устройств");
              },
            );
          }
        },
      ),
    );
  }
}
