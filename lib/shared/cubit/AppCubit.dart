import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies/Model/MovieModel.dart';
import 'package:movies/UI/Home/HomeScreen.dart';
import 'package:movies/UI/Search/SearchScreen.dart';
import 'package:movies/UI/Watchlist/WatchlistScreen.dart';
import 'package:movies/shared/cubit/AppStates.dart';
import 'package:sqflite/sqflite.dart';

import '../../UI/Browse/BrowseScreen.dart';
import '../component/component.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialState());

  int currentInd = 0;

  void changeInd(value) {
    currentInd = value;
    emit(ChangeIndex());
  }

  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    Watchlist(),
  ];
  late Database database;

  // var databasesPath =  getDatabasesPath();
  void createDatabase() async {
    // open the database
    database = await openDatabase(
      "Movies",
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Movies (id INTEGER PRIMARY KEY,backdropPath TEXT, originalLanguage TEXT, originalTitle TEXT,popularity DOUBLE, posterPath TEXT, title TEXT)');
      },
      onOpen: (database) async {
        getFromDataBase(database);
        print('Opened Data Base');
      },
    );
  }

  List<MovieModel> watchList = [];

  Future insertDatabase({
    required MovieModel movieModel,
  }) async {
    return await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Movies(id,title, backdropPath, originalLanguage,popularity,posterPath) VALUES(${movieModel.id.toString()},${movieModel.title}, ${movieModel.backdropPath}, ${movieModel.originalLanguage},${movieModel.popularity},${movieModel.posterPath})');
    }).catchError((error) {
      printAllText(error.toString());
    });
  }

  void getFromDataBase(dp) async {
    emit(LoadingState());
    /*await dp.rawQuery('SELECT * FROM Movies').then((value) {
      dp = value;
      value.forEach((element) {
        print("DATA ------------------ : ${element.toString()}");
      });
      // print(value);
      emit(SuccessState());
      // emit(AppGetDataBase());
    });*/
        await database.rawQuery('SELECT * FROM Movies').then((value) {
      printAllText("DATA ------------> ${value.toString()}");
    }).catchError((error) {
      print(error);
    });
  }
}
