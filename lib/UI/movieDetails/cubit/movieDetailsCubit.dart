import 'package:bloc/bloc.dart';
import 'package:movies/Model/MovieModel.dart';
import 'package:movies/Model/TrailerModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../shared/network/dio_helper.dart';
import 'movieDetailsState.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit() : super(InitialState());
  MovieModel? movieModel;
  List<MovieModel>? moreLike = [];
  List<MovieModel>? similar = [];
  TrailerModel? trailerModel;
  List<TrailerModel>? trailers = [];
  String? videoKey = "";

  void getMovieData(id) {
    trailers!.clear();
    moreLike!.clear();
    similar!.clear();
    emit(LoadingState());
    DioHelper.getData(
      url:
          "https://api.themoviedb.org/3/movie/$id?api_key=4ca03030e39414c5b8067716ec42ac90&language=en-US",
    ).then((value) {
      movieModel = MovieModel.fromJson(value.data);
      DioHelper.getData(
        url:
            "https://api.themoviedb.org/3/movie/$id/recommendations?api_key=4ca03030e39414c5b8067716ec42ac90&language=en-US&page=1",
      ).then((value) {
        for (var i = 0; i < value.data["results"].length; i++) {
          moreLike!.add(MovieModel.fromJson(value.data["results"][i]));
        }
        DioHelper.getData(
          url:
              "https://api.themoviedb.org/3/movie/$id/similar?api_key=4ca03030e39414c5b8067716ec42ac90&language=en-US&page=1",
        ).then((value) {
          for (var i = 0; i < value.data["results"].length; i++) {
            similar!.add(MovieModel.fromJson(value.data["results"][i]));
          }
        }).then((value) async {
          await DioHelper.getData(
                  url:
                      "https://api.themoviedb.org/3/movie/$id/videos?api_key=4ca03030e39414c5b8067716ec42ac90&language=en-US")
              .then((value) {
                for (var i = 0; i < value.data["results"].length; i++) {
                  trailers!
                      .add(TrailerModel.fromJson(value.data["results"][i]));
                }
                emit(GetDataSuccess());
              })
              .then((value) => getTrailer(trailers!.last.key))
              .catchError((error) {
                print(error);
                emit(GetDataError());
              });
        }).catchError((error) {
          print(error);
          emit(GetDataError());
        });
      });
    });
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  late YoutubePlayerController youtubeController;

  void getTrailer(key) {
    if (key != null) {
      youtubeController = YoutubePlayerController(
          initialVideoId: key,
          flags: YoutubePlayerFlags(
            autoPlay: false,
            enableCaption: true,
            forceHD: false,
            loop: true,
            // mute:true,
          ));
    }
  }
}
