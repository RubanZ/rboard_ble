import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dart:convert';

import 'list_devices.dart';

var rowJson = '''
{
  "type": "Row",
  "crossAxisAlignment": "start",
  "mainAxisAlignment": "start",
  "mainAxisSize": "max",
  "textBaseline": "alphabetic",
  "textDirection": "ltr",
  "verticalDirection": "down",
  "children":[
    {
      "type" : "Text",
      "data" : "Flutter"
    },
    {
      "type": "RaisedButton",
      "color": "##FF00FF",
      "padding": "8,8,8,8",
      "textColor": "#00FF00",
      "elevation" : 8.0,
      "splashColor" : "#00FF00",
      "child" : {
        "type": "Text",
        "data": "Widget"
      }
    },
    {
      "type" : "Text",
      "data" : "Demo"
    },
    {
      "type": "RaisedButton",
      "color": "##FF00FF",
      "padding": "8,8,8,8",
      "textColor": "#00FF00",
      "elevation" : 8.0,
      "splashColor" : "#00FF00",
      "click_event" : "route:/list",
      "child" : {
        "type": "Text",
        "data": "Go to List"
      }
    }
  ]
}
''';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RBoard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: MyHomePage(title: 'RBoard test page'),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) =>
              ListDevices(), //MyHomePage(title: 'RBoard test page'),
          '/list': (BuildContext context) => ListDevices()
        });
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             RaisedButton(
//               child: Text("Row"),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             PreviewPage(rowJson))); //CodeEditorPage
//               },
//             ),
//             RaisedButton(
//               child: Text("List"),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/list');
//               },
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
