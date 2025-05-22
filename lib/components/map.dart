import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/theme.provider.dart';
import '../menus/custom-side-menu.dart' as Sidebar;

/**
 * This page shows the headquarter of the shop with a Google Maps integration.
 */

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String dayTheme = '';
  String nightTheme = '';

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarker() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/custom-map-marker.png')
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng SHOP_Coordinates =
      LatLng(46.247128705394985, 20.14254592525978);
  static const String SHOP =
      'SZTE József Attila Tanulmányi és Információs Központ';

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    setCustomMarker();
  }

  Future _loadMapStyles() async {
    dayTheme = await DefaultAssetBundle.of(context)
        .loadString('assets/google-maps-json/day-mode.json');
    nightTheme = await DefaultAssetBundle.of(context)
        .loadString('assets/google-maps-json/night-mode.json');
  }

  void _launchMaps() {
    MapsLauncher.launchQuery(SHOP);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        drawer: Sidebar.CustomSideMenu(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 15),
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 15),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  iconTheme: IconThemeData(
                      color: themeProvider.themeMode == ThemeMode.light
                          ? Colors.black
                          : Colors.white),
                  toolbarHeight: 70,
                  title: LocaleText(
                    'our_shop',
                    style: GoogleFonts.cabin(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white),
                  ),
                ))),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: ((GoogleMapController controller) {
                controller.setMapStyle(themeProvider.themeMode == ThemeMode.dark
                    ? nightTheme
                    : dayTheme);
                _mapController.complete(controller);
              }),
              initialCameraPosition: CameraPosition(
                target: SHOP_Coordinates,
                zoom: 18,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("shop"),
                  icon: markerIcon,
                  position: SHOP_Coordinates,
                  infoWindow: InfoWindow(
                    title: 'Hooodies!',
                    snippet:
                        'SZTE József Attila Tanulmányi és Információs Központ',
                  ),
                ),
              },
            ),
            Positioned(
              left: 10,
              bottom: 35,
              child: ElevatedButton.icon(
                onPressed: _launchMaps,
                icon: Image.asset(
                  'assets/images/google-maps.png',
                  width: 30,
                  height: 30,
                ),
                label: Text(
                  "${Locales.string(context, 'direction')} | Google Maps",
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
        ));
  }
}
