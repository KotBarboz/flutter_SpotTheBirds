import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;
  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  String? name;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add bird"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Text("${widget.latLng.latitude} ${widget.latLng.longitude}"),
              // ElevatedButton(
              //     onPressed: () => Navigator.of(context).pop(),
              //     child: const Text("Back"))
              TextField(
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //

          if (description != null && name != null) {
            if (description != "" && name != "") {
              final BirdModel birdModel = BirdModel(
                  image: widget.image,
                  latitude: widget.latLng.latitude,
                  longitude: widget.latLng.longitude,
                  birdDescription: description!,
                  birdName: name!);
            }
          }

          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
