import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(4.601943, -74.066632);

  final Set<Marker> _marker = {};

  Future loadString() async {
    var url = "http://159.89.181.20:5003/getAll";
    var response = await http.get(Uri.parse(url));
    List<dynamic> list = json.decode(response.body);
    for (var item in list){
      _marker.add(Marker(markerId: MarkerId(item['id'].toString()), position: LatLng(item['latitud'], item['longitud']), infoWindow: InfoWindow(title: item['descripcion'], snippet: "Estado: "+item['estado'])));
    }
    return list;
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      loadString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: loadString(), 
      builder: (context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData) {
          return Scaffold(
      body: GoogleMap(onMapCreated: _onMapCreated, initialCameraPosition: CameraPosition(target: _center, zoom: 16.0), markers: _marker)
    );
        }
        else {
          return CircularProgressIndicator(backgroundColor: Colors.white, color: Colors.white,);
        }
      }
    );
  }
}