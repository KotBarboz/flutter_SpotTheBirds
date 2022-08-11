import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';
import 'package:spot_the_bird/services/sqflite.dart';
// import 'package:shared_preferences/shared_preferences.dart';

part "bird_post_state.dart";

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(
            const BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  final dbHelper = DatabaseHelper();

  Future<void> loadPosts() async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    List<BirdModel> birdPosts = [];

    // final List<String>? birdPostsJsonStringList =
    //     prefs.getStringList("birdPosts");

    // if (birdPostsJsonStringList != null) {
    //   for (var postJsonData in birdPostsJsonStringList) {
    //     final Map<String, dynamic> data =
    //         await json.decode(postJsonData) as Map<String, dynamic>;
    //
    //     final File imageFile = File(data["filePath"] as String);
    //     final String birdName = data["birdName"] as String;
    //     final String birdDescription = data["birdDescription"] as String;
    //     final double latitude = data["latitude"] as double;
    //     final double longitude = data["longitude"] as double;
    //
    //     birdPosts = [...birdPosts, BirdModel(
    //         image: imageFile,
    //         latitude: latitude,
    //         longitude: longitude,
    //         birdDescription: birdDescription,
    //         birdName: birdName)];
    //
    //   }
    // }

    final List<Map<String, dynamic>>? rows = await dbHelper.queryAllRows();

    if (rows?.length == 0) {
      print("rows are empty");
    } else {
      for (var row in rows!) {
        print(row["url"]);
        birdPosts = [
          ...birdPosts,
          BirdModel(
            id: row["id"],
            image: File(row["url"]),
            latitude: row["latitude"],
            longitude: row["longitude"],
            birdDescription: row["birdDescription"],
            birdName: row["birdName"],
          )
        ];
      }
    }

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    // birdPosts.add(birdModel);

    birdPosts = [...birdPosts, birdModel];

    // _saveToSharedPrefs(birdPosts);


    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle : birdModel.birdName,
      DatabaseHelper.columnDescription : birdModel.birdDescription,
      DatabaseHelper.latitude: birdModel.latitude,
      DatabaseHelper.longitude : birdModel.longitude,
      DatabaseHelper.columnUrl : birdModel.image.path,
    };

    final int? id = await dbHelper.insert(row);

    birdModel.id = id;


    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> removeBirdPost(BirdModel birdModel) async{
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.removeWhere((element) => element == birdModel);

    // _saveToSharedPrefs(birdPosts);

    await dbHelper.delete(birdModel.id!);

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> _saveToSharedPrefs(List<BirdModel> posts) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonDataList = posts
        .map((post) => json.encode({
              "birdName": post.birdName,
              "filePath": post.image.path,
              "latitude": post.latitude,
              "longitude": post.longitude,
              "birdDescription": post.birdDescription,
            }))
        .toList();

    // prefs.setStringList("birdPosts", jsonDataList);
  }
}
