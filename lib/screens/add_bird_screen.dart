import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;
  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add bird"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
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
            const TextField(),
            const TextField(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
        },
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
