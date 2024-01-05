import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users_app/global/global_var.dart';
import 'package:permission_handler/permission_handler.dart';



class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage>
{
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;


  void updateMapTheme(GoogleMapController controller)
  {
    getJsonFileFromThemes("themes/night_style.json").then((value)=> setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async
  {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller)
  {
    controller.setMapStyle(googleMapStyle);
  }



  Future<void> getCurrentLiveLocationOfUser() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      // Permission is already granted, get the location
      Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      // Rest of your code...
    } else if (status.isDenied || status.isRestricted) {
      // Permission is not granted, request it
      status = await Permission.location.request();
      if (status.isGranted) {
        // Permission granted on request, get the location
        Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
        currentPositionOfUser = positionOfUser;

        LatLng positionOfUserInLatLng = LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

        CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng, zoom: 15);
        controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        // Rest of your code...
      } else {
        // Handle the case where the user denied the permission
        // You can show an in-app explanation here
      }
    } else if (status.isPermanentlyDenied) {
      // The user opted not to grant permission and not to be asked again
      // Here, you can prompt the user to open app settings
      openAppSettings();
    }
  }

  // getCurrentLiveLocationOfUser() async
  // {
  //
  //   Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   currentPositionOfUser = positionOfUser;
  //
  //   LatLng positionOfUserInLatLng = LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  //
  //   CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng, zoom: 15);
  //   controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController)
            {
              controllerGoogleMap = mapController;
              updateMapTheme(controllerGoogleMap!);

              googleMapCompleterController.complete(controllerGoogleMap);

              getCurrentLiveLocationOfUser();
            },
          ),

        ],
      ),
    );
  }
}
