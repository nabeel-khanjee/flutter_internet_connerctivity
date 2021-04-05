import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var connectivityStatus = "Unkhown";
  var connectivity;
  StreamSubscription<ConnectivityResult> streamSubscription;

  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    streamSubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityStatus = result.toString();
      print(connectivityStatus);

      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        getData();
      }
    });
  }

  Future getData() async {
    final response = await http
        .get(Uri.http("http://jsonplaceholder.typicode.com", "posts"));

    print(response);

    if (response.statusCode == HttpStatus.OK) {
      var result = jsonDecode(response.body);
      setState(() {
      });      
      return result;
      
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Connectivity"),
      ),
      body: new FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var mydata = snapshot.data;
              return new ListView.builder(
                itemBuilder: (context, index) => ListTile(title: new Text(mydata[index]["title"]),),
                itemCount: mydata.length,
              );
            } else {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
