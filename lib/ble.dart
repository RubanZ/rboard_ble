import 'package:flutter/material.dart';
import 'package:rx_ble/rx_ble.dart';

class BLEError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.black.withOpacity(0.65),
            ),
            Text(
                'Для работы приложения требуется\nправа на управление Bluetooth',
                textAlign: TextAlign.center),
            FlatButton(
              onPressed: () {
                RxBle.requestAccess();
              },
              child: Text(
                "Включить Bluetooth",
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/list');
              },
              child: Text(
                "Попробовать снова",
              ),
            )
          ],
        ),
      ),
    );
  }
}
