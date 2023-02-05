import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/Model/MovieModel.dart';
import 'package:movies/UI/Home/cubit/HomeCubit.dart';
import 'package:movies/UI/Search/cubit/SearchCubit.dart';
import 'package:movies/UI/Search/cubit/SearchStates.dart';
import 'package:movies/shared/component/component.dart';

import '../Watchlist/cubit/cubitWatchlist.dart';
import '../movieDetails/cubit/movieDetailsCubit.dart';
import '../movieDetails/movieDetailsScreen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchCubit cubit = BlocProvider.of(context);
    return BlocBuilder<SearchCubit, SearchStates>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          color: backgroundColor,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(73),
                  color: Color(0xff514F4F),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width * 0.90,
                height: 44,
                child: TextFormField(
                  controller: cubit.searchText,
                  onChanged: (value) => cubit.getSearchData(value),
                  style: TextStyle(
                    fontSize: 16.7,
                    color: Colors.grey[400],
                  ),
                  cursorColor: Colors.grey[400],
                  autocorrect: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIconColor: Colors.white,
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 3,
                child: (state is LoadingState
                    ? LinearProgressIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.grey,
                      )
                    : null),
              ),
              ConditionalBuilder(
                condition: cubit.searches!.isNotEmpty,
                builder: (context) => Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        bulidItem(context, cubit.searches![index]),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 25,
                      child: Divider(
                        color: Colors.grey,
                        height: 10,
                      ),
                      // color: Colors.grey,
                    ),
                    itemCount: cubit.searches!.length,
                  ),
                ),
                fallback: (context) => Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Icon(
                      Icons.local_movies,
                      size: 100,
                      color: Colors.white,
                    ),
                    Text("No movies found",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bulidItem(context, MovieModel model) {
    HomeCubit homeCubit = BlocProvider.of(context);
    return InkWell(
      onTap: () {
        MovieDetailsCubit movCubit = BlocProvider.of(context);
        movCubit.getMovieData(model.id.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetails(),
          ),
        );
      },
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Stack(
            children: [
              SizedBox(
                height: 150,
                width: 125,
                child: (model.posterPath != null
                    ? Image.network(
                        "$imageUrl${model.posterPath}",
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/Images/moviesPoster.png")),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 0, start: 8),
                child: SizedBox(
                  height: 40,
                  width: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      WatchListCubit watchCubit = BlocProvider.of(context);
                      watchCubit.insertDate(model);
                    },
                    icon: Image.asset(homeCubit.selected
                        ? homeCubit.bookmarkSelected
                        : homeCubit.bookmarkAdd),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  model.title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                model.releaseDate!,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  model.originalTitle!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
