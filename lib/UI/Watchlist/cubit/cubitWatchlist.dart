import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies/Model/MovieModel.dart';
import 'package:movies/shared/component/component.dart';
import 'package:sqflite/sqflite.dart';
import 'StateWatchlist.dart';

class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit() : super(InitialState());
  Map<String, int> check = {};
  String msg = "";
  List<MovieModel> watchList = [];

  void insertDate(MovieModel model) async {
    emit(LoadingState());
    if (check.containsKey(model.id.toString()) == true) {
      msg = ("already Added");
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,

      );
      print(msg);
      emit(SuccessState());
    } else {
      await dbHelper
          .insert({
            "title": model.title!,
            "movId": model.id!,
            "backdropPath": model.releaseDate,
            "popularity": model.popularity!,
            "posterPath": model.posterPath!,
          })
          .then((value) {
            msg = ("Success Add");
            Fluttertoast.showToast(
              msg: msg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,

            );
            print(msg);
            emit(SuccessState());
          })
          .then((value) => getData())
          .catchError((error) {
            printAllText(error.toString());
            emit(ErrorState());
          });

    }
  }

  void getData() async {
    emit(GetDataLoadingState());
    await dbHelper.queryAllRows().then((value) {
      watchList.clear();
      check.clear();
      for (var element in value) {
        MovieModel model = MovieModel(
          voteAverage: element["_id"],
          id: element["MovId"],
          backdropPath: element["backdropPath"],
          title: element["title"],
          posterPath: element["posterPath"],
          popularity: element["popularity"],
          releaseDate: element["releaseDate"],
        );
        watchList.add(model);
        check[model.id!] = 1;
      }
      // watchList = watchList.toSet().toList();
      check.forEach((key, value) {
        print("$key --> $value");
      });
      emit(GatDataSuccessState());
    }).catchError((error) {
      printAllText(error.toString());
      emit(GetDataErrorState());
    });
  }

  void delete(id) async {
    await dbHelper.delete(id).then((value) async {
      print("sucess Deleted");
      emit(SuccessState());
    }).then((value) async {
      getData();
    }).catchError((error) {
      printAllText(error.toString());
      emit(ErrorState());
    });
  }

  Future<void> clearDataBase() async {
    emit(LoadingState());
    for (var element in watchList) {
      delete(element.voteAverage);
    }
    getData();
  }
}
