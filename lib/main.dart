import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rboard_ble/devices.dart';
import 'package:rboard_ble/core/ble.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BLEManager().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RBoard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: MyHomePage(title: 'RBoard test page'),
        initialRoute: DevicesPage.routeName,
        routes: {
          DevicesPage.routeName: (context) => const DevicesPage(),
        });
  }
}
// https://github.com/PhilipsHue/flutter_reactive_ble