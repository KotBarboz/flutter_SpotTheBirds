import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
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

  //final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final FocusNode _descriptionFocusNode;

  void _submit(BirdModel birdModel) {
    final FormState? form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving Data')),
    );

    _formKey.currentState!.save();

    context.read<BirdPostCubit>().addBirdPost(birdModel);


    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add bird"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  decoration:
                      const InputDecoration(hintText: "Enter a bird name"),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    name = value!.trim();
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter a name";
                    }
                    if (value!.length < 2) {
                      return "Please enter a longer name";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Enter a bird description"),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {

                    final BirdModel birdModel = BirdModel(
                        image: widget.image,
                        latitude: widget.latLng.latitude,
                        longitude: widget.latLng.longitude,
                        birdDescription: description,
                        birdName: name);

                    _submit(birdModel);
                  },
                  onSaved: (value) {
                    description = value!.trim();
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                       return "Please enter a description";
                    }
                    if (value!.length < 2) {
                      print("Please enter a longer description");
                      return "Please enter a longer description";
                    }

                    print(value);
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //

          // if (description != null && name != null) {
          //   if (description != "" && name != "") {
          final BirdModel birdModel = BirdModel(
              image: widget.image,
              latitude: widget.latLng.latitude,
              longitude: widget.latLng.longitude,
              birdDescription: description,
              birdName: name);

          // context.read<BirdPostCubit>().addBirdPost(birdModel);

          //   }
          // }
          _submit(birdModel);

        },
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
