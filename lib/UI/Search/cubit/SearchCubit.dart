import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:movies/UI/Search/cubit/SearchStates.dart';
import 'package:movies/shared/component/component.dart';
import 'package:movies/shared/network/dio_helper.dart';

import '../../../Model/MovieModel.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(InitialState());

  List<MovieModel>? searches = [];
  var searchText = TextEditingController();
  void getSearchData(value) {
    searches!.clear();
    emit(LoadingState());
      DioHelper.getData(
        url:
            "https://api.themoviedb.org/3/search/movie?api_key=$token&language=en-US&page=1&include_adult=false&query=$value",
      ).then((value) {
        for (var element in value.data!["results"]) {
          searches!.add(MovieModel.fromJson(element!));
        }
        emit(SucessState());
      }).catchError((error) {
        print(error);
        emit(ErrorState());
      });

  }
}
