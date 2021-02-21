import 'package:flutter/material.dart';
import 'package:rx_ble/rx_ble.dart';

import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dynamic_widget_json_exportor.dart';

import 'package:flutter/rendering.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.device}) : super(key: key);

  final ScanResult device;

  DynamicWidgetJsonExportor _exportor;
  var rowJsonApp = "";
  var currentPacket = 0;
  var procentDownload = 0;

  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
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

  Future<void> _getApp() async {
    final value = await RxBle.readChar(
        widget.device.deviceId, '2cbd3d41-390a-4b07-8ad1-b1de2d88b500');
    var msg = RxBle.charToString(value, allowMalformed: true);
    var countPacket = msg[0].codeUnitAt(0);
    widget.rowJsonApp += msg.substring(1);
    for (widget.currentPacket = 1;
        widget.currentPacket < countPacket + 1;
        widget.currentPacket++) {
      widget.procentDownload = countPacket ~/ 100 * widget.currentPacket;
      final valueNew = await RxBle.readChar(
          widget.device.deviceId, '2cbd3d41-390a-4b07-8ad1-b1de2d88b500');
      msg = RxBle.charToString(valueNew, allowMalformed: true);
      widget.rowJsonApp += msg.substring(1);
    }
  }

  Future<Widget> _buildWidget(BuildContext context, String app) async {
    return DynamicWidgetBuilder.build(app, context, new HandlerClick());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.device.deviceName + " - dashboard"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                await RxBle.disconnect(deviceId: widget.device.deviceId);
                Navigator.pop(context);
              },
            )),
        body: //loading("Подключение")
            FutureBuilder(
          future: _getApp(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.done) {
              print(widget.rowJsonApp);
              return FutureBuilder<Widget>(
                future: _buildWidget(context, widget.rowJsonApp),
                builder:
                    (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return snapshot.hasData
                      ? widget._exportor = DynamicWidgetJsonExportor(
                          child: snapshot.data,
                        )
                      : Text("Loading...");
                },
              );
            }
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => PreviewPage(widget.rowJsonApp)));
            else {
              return loading("Получение данных " +
                  widget.procentDownload.toString() +
                  "%");
            }
            // return Text(widget.rowJsonApp);
          },
        ));
  }
}

class CodeEditorPage extends StatefulWidget {
  final String jsonString;

  CodeEditorPage(this.jsonString);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CodeEditorPageState(jsonString);
  }
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  String jsonString;
  TextEditingController controller = TextEditingController();

  _CodeEditorPageState(this.jsonString);

  @override
  Widget build(BuildContext context) {
    var widget = Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Code Editor"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints.expand(
                    width: double.infinity, height: double.infinity),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Enter json string'),
                  maxLines: 1000000,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
              child: Text("Preview"),
              onPressed: () {
                setState(() {
                  jsonString = controller.text;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviewPage(controller.text)));
              },
            )
          ],
        ));
    controller.text = jsonString;
    return widget;
  }
}

// ignore: must_be_immutable
class PreviewPage extends StatelessWidget {
  final String jsonString;

  PreviewPage(this.jsonString);

  DynamicWidgetJsonExportor _exportor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Preview"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Widget>(
              future: _buildWidget(context),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                return snapshot.hasData
                    ? _exportor = DynamicWidgetJsonExportor(
                        child: snapshot.data,
                      )
                    : Text("Loading...");
              },
            ),
          ),
          RaisedButton(
            child: Text("Edit"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CodeEditorPage(jsonString))); //CodeEditorPage
            },
          ),
          RaisedButton(
            onPressed: () {
              var exportJsonString = _exportor.exportJsonString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CodeEditorPage(exportJsonString)));
            },
            child: Text("export json code"),
          )
        ],
      ),
    );
  }

  Future<Widget> _buildWidget(BuildContext context) async {
    return DynamicWidgetBuilder.build(jsonString, context, new HandlerClick());
  }
}

class HandlerClick implements ClickListener {
  @override
  void onClicked(String event) {
    var body = event.split(':');
    if (body[0] == "route") {
      print("Route to: " + body[1]);
    }
    print("Receive click event2: " + body.toString());
  }
}

class JSONExporter extends StatefulWidget {
  @override
  _JSONExporterState createState() => _JSONExporterState();
}

class _JSONExporterState extends State<JSONExporter> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("export example"),
      ),
      body: Builder(
        builder: (context) => Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: DynamicWidgetJsonExportor(
                  key: key,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Image.asset("assets/vip.png"),
                      Positioned(
                        child: Image.asset("assets/vip.png"),
                        top: 50,
                        left: 50,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text("Export"),
                  onPressed: () {
                    var exportor =
                        key.currentWidget as DynamicWidgetJsonExportor;
                    var exportJsonString = exportor.exportJsonString();
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text("json string was exported to editor page.")));
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CodeEditorPage(exportJsonString)));
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
