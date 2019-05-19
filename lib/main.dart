import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

Map _data;
List _features;

void main() async {
  _data = await getQuakes();
  _features = _data['features'];
  print(_features);
  runApp(MaterialApp(
    title: "My earthquake app",
    home: Home(),
  ));
}

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        title: Text("Earthquakes!"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: ListView.builder(
        itemCount: _features.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) return Divider();
          final index = position ~/ 2;

          var format = new DateFormat.yMMMd("en_US").add_jm();
          var date = format.format(DateTime.fromMillisecondsSinceEpoch(_features[index]['properties']['time'], isUtc: true));
          
          return ListTile(
            title: Text("$date",
            style: TextStyle(fontSize: 19.5, color: Colors.black,
            fontWeight: FontWeight.w500),),
            subtitle: Text("${_features[index]['properties']['place']}",
            style:  TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.normal,
              color: Colors.blueAccent,
              fontStyle: FontStyle.italic
            ),),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,

              child: Text("${_features[index]['properties']['mag']}",
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 16.5,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
          onTap: () {
              _showAlertMessage(context, "${_features[index]['properties']['mag']}" + " Location: ${_features[index]['properties']['place']}");
          },);
        },),
      ),
    );
  }

  void _showAlertMessage(BuildContext context, String message) {
    var alert = AlertDialog(
      title: Text("Details:"),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: () {Navigator.pop(context);},
        child:  Text("OK"),)
      ],
    );
    showDialog(context: context, child: alert);
  }
}

Future<Map> getQuakes() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}
