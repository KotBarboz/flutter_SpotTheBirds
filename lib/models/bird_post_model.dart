import 'dart:io';

class BirdModel {
  int? id;
  final String? birdName;
  final double latitude;
  final double longitude;
  final String? birdDescription;
  final File image;

  BirdModel({
    this.id,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.birdDescription,
    required this.birdName,
  });
}
