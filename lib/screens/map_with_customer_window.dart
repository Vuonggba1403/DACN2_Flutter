import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

class MapWithCustomerWindow extends StatefulWidget {
  const MapWithCustomerWindow({super.key});

  @override
  State<MapWithCustomerWindow> createState() => _MapWithCustomerWindowState();
}

class _MapWithCustomerWindowState extends State<MapWithCustomerWindow> {
  // Location my current
  LatLng myCurentLocation =
      const LatLng(15.990017458289968, 108.26972410251842);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController googleMapController;
  // custom window
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  //firebase collection to load latlng of place
  final CollectionReference placeCollection =
      FirebaseFirestore.instance.collection('hotel');
  List<Marker> markers = [];
  // for custom marker
  Future<void> _loadMarker() async {
    customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/marker.png',
      height: 40,
      width: 30,
    );
    Size size = MediaQuery.of(context).size;

    placeCollection.snapshots().listen((QuerySnapshot streamSnapshot) {
      if (streamSnapshot.docs.isNotEmpty) {
        final List allMarkers = streamSnapshot.docs;
        List<Marker> myMarker = [];
        for (final marker in allMarkers) {
          final dat = marker.data();
          final data = (dat) as Map;
          myMarker.add(
            Marker(
              markerId: MarkerId(
                data['name'],
              ),
              position: LatLng(
                data['latitude'],
                data['longitude'],
              ),
              onTap: () {
                _customInfoWindowController.addInfoWindow!(
                  Container(
                    height: size.height * 0.32,
                    width: size.width * 0.8,
                    color: Colors.amber,
                  ),
                  LatLng(
                    data['latitude'],
                    data['longitude'],
                  ),
                );
              },
              icon: customIcon,
            ),
          );
        }
        setState(() {
          markers = myMarker;
        });
      }
    });
  }

  @override
  // create marker
  void initState() {
    super.initState();
    _loadMarker();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // fuction click map
        onPressed: () {
          showModalBottomSheet(
              clipBehavior: Clip.none,
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  color: Colors.white,
                  height: size.height * 0.77,
                  width: size.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: size.height * 0.77,
                        child: GoogleMap(
                          // my location
                          initialCameraPosition:
                              CameraPosition(target: myCurentLocation),

                          // create marker
                          onMapCreated: (GoogleMapController controller) {
                            googleMapController = controller;
                            _customInfoWindowController.googleMapController =
                                controller;
                          },
                          onTap: (argument) {},
                          onCameraMove: (position) {
                            _customInfoWindowController.onCameraMove!();
                          },
                          markers: markers.toSet(),
                        ),
                      ),
                      CustomInfoWindow(
                        controller: _customInfoWindowController,
                        height: size.height * 0.34,
                        width: size.width * 0.85,
                        offset: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 170,
                            vertical: 5,
                          ),
                          child: Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        label: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            children: [
              SizedBox(width: 5),
              Text(
                "Map",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "OpenSans"),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.map_outlined, color: Colors.white),
            ],
          ),
        ));
  }
}
