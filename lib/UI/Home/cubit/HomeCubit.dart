import 'package:bloc/bloc.dart';
import 'package:movies/UI/Home/cubit/HomeState.dart';
import 'package:movies/shared/network/dio_helper.dart';

import '../../../Model/MovieModel.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialState());
  bool selected = true;
  String bookmarkSelected = "assets/Icons/bookmark.png";
  String bookmarkAdd = "assets/Icons/Icon awesome-bookmark.png";

  void selectItem() {
    selected = !selected;
    emit(SelectItemState());
  }

  List<MovieModel>? popular = [];
  List<MovieModel>? more = [];

  MovieModel? movieModel;
  String? msgError;

  void getPopular() {
    DioHelper.getData(
      url:
          "movie/popular?api_key=4ca03030e39414c5b8067716ec42ac90&language=en-US&page=1",
    ).then((value) {
      for (var i = 0; i < value.data["results"].length; i++) {
        popular!.add(MovieModel.fromJson(value.data["results"][i]));
      }

      emit(GetPopularSuccess());
    }).catchError((error) {
      print(error);
      msgError = error.toString();
      emit(GetPopularError());
    });
  }
  void getMore() {
    DioHelper.getData(
      url:
      "movie/popular?api_key=4ca03030e39414c5b8067716ec42ac90&language=en-US&page=2",
    ).then((value) {
      for (var i = 0; i < value.data["results"].length; i++) {
        more!.add(MovieModel.fromJson(value.data["results"][i]));
      }

      emit(GetPopularSuccess());
    }).catchError((error) {
      print(error);
      msgError = error.toString();
      emit(GetPopularError());
    });
  }
  List<MovieModel>? newRelease = [];
  void getNewReleases() {
    DioHelper.getData(
      url:
      "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1&api_key=4ca03030e39414c5b8067716ec42ac90",
    ).then((value) {
      for (var i = 0; i < value.data["results"].length; i++) {
        newRelease!.add(MovieModel.fromJson(value.data["results"][i]));
      }
      emit(GetPopularSuccess());
    }).catchError((error) {
      print(error);
      msgError = error.toString();
      emit(GetPopularError());
    });
  }
  List<MovieModel>? topRated = [];
  void getTopRated() {
    DioHelper.getData(
      url:
        "https://api.themoviedb.org/3/movie/top_rated?api_key=4ca03030e39414c5b8067716ec42ac90&language=en-US&page=1"
    ).then((value) {
      for (var i = 0; i < value.data["results"].length; i++) {
        topRated!.add(MovieModel.fromJson(value.data["results"][i]));
      }
      emit(GetTopRatedSuccess());
    }).catchError((error) {
      print(error);
      msgError = error.toString();
      emit(GetTopRatedError());
    });
  }


}
