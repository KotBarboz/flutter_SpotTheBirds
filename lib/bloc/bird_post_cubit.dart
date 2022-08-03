import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';

part "bird_post_state.dart";

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit(): super(const BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

void addBirdPost(BirdModel birdModel) {
  emit(state.copyWith(status: BirdPostStatus.loading));

  List<BirdModel> birdPosts = state.birdPosts;

  // birdPosts.add(birdModel);

  birdPosts = [...birdPosts, birdModel];


  emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));


}

}