import 'dart:async';
import 'package:android_studio_projects/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import '../menu/custom-drawer.dart' as sidebar;
import '../provider/theme-changer.provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();

  String dayTheme = '';
  String nightTheme = '';

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _currentPosition = null;

  static const LatLng TIK_Coordinates =
      LatLng(46.247128705394985, 20.14254592525978);
  static const String TIK =
      'SZTE József Attila Tanulmányi és Információs Központ';

  Map<PolylineId, Polyline> polylines = {};

  // TODO - Shouldn't be part of initState, only if direction is requested.
  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    getLocationUpdates().then((_) => {
          _currentPosition = LatLng(49, 23),
          if (_currentPosition != null)
            {
              getPolylinePoints().then(
                  (coordinates) => generatePolylineFromPoints(coordinates))
            }
        });
  }

  Future _loadMapStyles() async {
    dayTheme = await DefaultAssetBundle.of(context)
        .loadString('assets/google-maps-json/day-mode.json');
    nightTheme = await DefaultAssetBundle.of(context)
        .loadString('assets/google-maps-json/night-mode.json');
  }

  void _launchMaps() {
    MapsLauncher.launchQuery(TIK);
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 18,
    );
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          print('Lefut időben...................................');
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        _cameraToPosition(_currentPosition!);
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    print(
        '------------------------------------getPolylinePoints---------------------------------------------');
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(TIK_Coordinates.latitude, TIK_Coordinates.longitude),
      PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    print(
        '------------------------------------generatePolylineFromPoints---------------------------------------------');
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        drawer: sidebar.NavigationDrawer(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 15),
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 15),
                child: AppBar(
                  /* backgroundColor: themeChanger.themeMode == ThemeMode.light
                      ? Colors.white12
                      : Colors.indigo,*/
                  backgroundColor: Colors.transparent,
                  iconTheme: IconThemeData(
                      color: themeChanger.themeMode == ThemeMode.light
                          ? Colors.black
                          : Colors.white),
                  toolbarHeight: 70,
                  title: Text(
                    'Üzletünk',
                    style: GoogleFonts.cabin(
                        fontWeight: FontWeight.bold,
                        color: themeChanger.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white),
                  ),
                  // backgroundColor: Colors.green.shade200,
                ))),
        body: /*_currentPosition != null
          ?*/
            Stack(
          children: [
            GoogleMap(
                onMapCreated: ((GoogleMapController controller) {
                  print('This is the dayTheme: ' + dayTheme);
                  controller.setMapStyle(
                      themeChanger.themeMode == ThemeMode.dark
                          ? nightTheme
                          : dayTheme);
                  _mapController.complete(controller);
                }),
                initialCameraPosition: CameraPosition(
                  target: TIK_Coordinates,
                  zoom: 18,
                ),
                markers: {
                  const Marker(
                      markerId: MarkerId("_company"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: TIK_Coordinates),
                  /*Marker(
                    markerId: MarkerId('_currentPosition'),
                    // TODO - Add a custom marker here!
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentPosition!,
                  )*/
                },
                polylines: Set<Polyline>.of(polylines.values)),
            Positioned(
              left: 10,
              bottom: 35,
              child: ElevatedButton.icon(
                onPressed: _launchMaps,
                icon: Image.asset(
                  'assets/img/google-maps.png',
                  width: 30,
                  height: 30,
                ),
                label: Text(
                  "Google Maps",
                  style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold, fontSize: 17.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        )
        // TODO - This is the normal widget. DO NOT DELETE! Add a Google billing account!
        /*: Stack(
              children: [
                GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: TIK_Coordinates,
                      zoom: 13,
                    ),
                    markers: {
                      const Marker(
                          markerId: MarkerId("_company"),
                          icon: BitmapDescriptor.defaultMarker,
                          position: TIK_Coordinates),
                    }),
                Positioned(
                  left: 10,
                  bottom: 35,
                  child: ElevatedButton.icon(
                    onPressed: _launchMaps,
                    icon: Image.asset(
                      'assets/img/google-maps.png',
                      width: 30,
                      height: 30,
                    ),
                    label: Text(
                      "Google Maps",
                      style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, fontSize: 17.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),*/
        );
  }
}
