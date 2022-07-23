import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/add_bird_screen.dart';

class MapScreen extends StatelessWidget {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
          listener: (previousState, currentState) {
            if (currentState is LocationLoaded) {
              _mapController.onReady.then((_) => _mapController.move(
                  LatLng(currentState.latitude, currentState.longitude), 14.0));
            }

            if (currentState is LocationError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red.withOpacity(0.6),
                content: const Text("Error! Unable to fetch location :-( "),
              ));
            }
          },
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onLongPress: (tapPosition, latLng) {
                // TODO:- Go to create Bird post screen

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBirdScreen(
                            latLng: latLng,
                          )),
                );
              },
              center: LatLng(0, 0),
              zoom: 15.3,
              maxZoom: 17.0,
              minZoom: 3.5,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                retinaMode: true,
              ),
            ],
          )),
    );
  }
}
