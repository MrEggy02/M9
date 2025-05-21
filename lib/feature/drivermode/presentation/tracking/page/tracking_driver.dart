import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:m9/core/config/theme/app_color.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class TrackingDriver extends StatefulWidget {
  const TrackingDriver({super.key});

  @override
  State<TrackingDriver> createState() => _TrackingDriverState();
}

class _TrackingDriverState extends State<TrackingDriver> {
  PointAnnotationManager? _annotationManager;
  MapboxMap? mapboxMap;
  // ---
  AnnotationManager? _annotation;
  PolygonAnnotation? polygonAnnotation;
  AnimationController? controller;
  AnimationController? animationController1;
  AnimationController? animationController2;
  AnimationController? animationController3;
  //----
  List<dynamic> coordinates = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            onMapCreated: (MapboxMap map) {
              mapboxMap = map;
              mapboxMap!.location.updateSettings(
                LocationComponentSettings(enabled: true, pulsingEnabled: true),
              );
            },
            onMapIdleListener: (mapIdleEventData) {},
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(102.62293008431034,18.014079533955524),
              ),
              zoom: 16.5,
              anchor:  ScreenCoordinate(
                  x: MediaQuery.of(context).size.width / 2,
                  y: MediaQuery.of(context).size.height / 2,
                ),
            ),
          ),
        // Crosshair
          Center(
            child: Container(
              height: 120,
              
              child: Column(
                children: [
                  // Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(color: Color(0xFFF7DCB2),borderRadius:BorderRadius.circular(20) ),
                  // child: Column(children: [
                  //   Text("ຖະໜົນ",style: TextStyle(),)
                  // ],),
                  // ),
                  Image.asset('assets/icons/pin.png',fit: BoxFit.cover,),
                ],
              )),
          ),
          Positioned(
            top: 60,
            left: 15,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(child: Icon(Icons.menu, size: 30)),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 15,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Center(child: Icon(Icons.chat_outlined, size: 30)),
                  Positioned(
                    top: 5,
                    right: 10,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

         
        ],
      ),
    );
  }

  /// Add a marker to the map
  // void _addMarker() async {
  //   _annotationManager =
  //       await mapboxMap!.annotations.createPointAnnotationManager();

  //   // Load the image from assets
  //   final ByteData bytes = await rootBundle.load('assets/image/red-flag.png');
  //   final Uint8List imageData = bytes.buffer.asUint8List();
  //   final ByteData bytes2 = await rootBundle.load('assets/image/flag.png');
  //   final Uint8List imageData2 = bytes2.buffer.asUint8List();

  //   // Create a PointAnnotationOptions
  //   PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
  //     geometry: Point(
  //       coordinates: Position(102.6206935381605, 18.027194217521288),
  //     ),
  //     image: imageData,
  //     iconSize: 3.0,
  //   );
  //   PointAnnotationOptions pointAnnotationOptions2 = PointAnnotationOptions(
  //     geometry: Point(
  //       coordinates: Position(102.61494561121299, 17.98355954224959),
  //     ),
  //     image: imageData2,
  //     iconSize: 3.0,
  //   );

  //   // Add the annotation to the map
  //   _annotationManager?.create(pointAnnotationOptions);
  //   _annotationManager?.create(pointAnnotationOptions2);
  // }

  // Future<List<dynamic>> fetchRoute({
  //   required String accessToken,
  //   required String profile,
  //   required Position origin,
  //   required Position destination,
  // }) async {
  //   final url = Uri.parse(
  //     'https://api.mapbox.com/directions/v5/mapbox/$profile/${origin.lng},${origin.lat};${destination.lng},${destination.lat}?geometries=geojson&access_token=$accessToken',
  //   );

  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);

  //     if (data['routes'] != null && data['routes'].isNotEmpty) {
  //       return data['routes'][0]['geometry']['coordinates'];
  //     } else {
  //       throw Exception('No routes found.');
  //     }
  //   } else {
  //     throw Exception('Failed to fetch route: ${response.body}');
  //   }
  // }

  // void _fetchAndDisplayRoute() async {
  //   try {
  //     coordinates = await fetchRoute(
  //       accessToken:
  //           "pk.eyJ1Ijoic2FpeXZvdWQiLCJhIjoiY200dmc1bG1yMDM1OTJpcDd5YXQ4bHo5cSJ9.ntQwsHxu7yybd60lmkjV2Q",
  //       profile: "driving",
  //       origin: Position(102.62326755168499, 18.01433921586265),
  //       destination: Position(102.6206935381605, 18.027194217521288),
  //     );

  //     var geoJsonData = {
  //       "type": "Feature",
  //       "geometry": {"type": "LineString", "coordinates": coordinates},
  //     };
  //     print(geoJsonData);
  //     mapboxMap!.style.addSource(
  //       GeoJsonSource(id: "line", data: json.encode(geoJsonData)),
  //     );
  //     // line
  //     mapboxMap!.style.addLayer(
  //       LineLayer(
  //         id: "line-layer",
  //         sourceId: "line",
  //         lineColor: Colors.blue.value,
  //         lineWidth: 5.0,
  //         slot: "middle",
  //       ),
  //     );
  //     mapboxMap!.style.addLayer(
  //       SymbolLayer(
  //         id: "line-sysbol",
  //         sourceId: "line",
  //         //iconImage:
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error fetching or displaying route: $e');
  //   }
  // }

}
