import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/UI/Home/cubit/HomeState.dart';
import 'package:movies/UI/Watchlist/cubit/cubitWatchlist.dart';
import 'package:movies/UI/movieDetails/cubit/movieDetailsCubit.dart';
import 'package:movies/shared/cubit/AppCubit.dart';
import '../../shared/component/component.dart';
import '../movieDetails/movieDetailsScreen.dart';
import 'cubit/HomeCubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = BlocProvider.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => ConditionalBuilder(
        condition: cubit.popular!.isNotEmpty && cubit.newRelease!.isNotEmpty,
        builder: (context) => Container(
          color: Colors.black,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Column(
                    children: [
                      (cubit.newRelease![0].backdropPath != null
                          ? Image.network(
                              "http://image.tmdb.org/t/p/w500/${cubit.newRelease![0].backdropPath}")
                          : Image.asset("assets/Images/moviesPoster.png")),
                      Container(
                        height: 50,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 15),
                            height: 200,
                            width: 150,
                            child: (cubit.newRelease![0].posterPath != null
                                ? Image.network(
                                    "http://image.tmdb.org/t/p/w500/${cubit.newRelease![0].posterPath}")
                                : Image.asset(
                                    "assets/Images/moviesPoster.png")),
                          ),
                          // "http://image.tmdb.org/t/p/w500/${cubit.newRelease![0].posterPath}",
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                top: 0, start: 25),
                            child: SizedBox(
                              height: 40,
                              width: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  WatchListCubit watchCubit =
                                      BlocProvider.of(context);
                                  watchCubit.insertDate(cubit.newRelease![0]);
                                },
                                icon: Image.asset(cubit.selected
                                    ? cubit.bookmarkSelected
                                    : cubit.bookmarkAdd),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              cubit.newRelease![0].title!,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            cubit.newRelease![0].releaseDate!,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                elevation: 10,
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, top: 12),
                      child: Text(
                        "NewRelease",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 235,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            MovieDetailsCubit movCubit =
                                BlocProvider.of(context);
                            movCubit.getMovieData(
                                cubit.newRelease![index].id.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetails(),
                              ),
                            );
                          },
                          child: SizedBox(
                            // height: 200,
                            width: 120,
                            child: Card(
                              elevation: 10,
                              color: Color(0xff353434),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Stack(
                                    alignment: AlignmentDirectional.topStart,
                                    children: [
                                      (cubit.newRelease![index].posterPath !=
                                              null
                                          ? Image.network(
                                              "http://image.tmdb.org/t/p/w500/${cubit.newRelease![index].posterPath!}",
                                              height: 150,
                                              width: 125,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset(
                                              "assets/Images/moviesPoster.png")),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                top: 0, start: 8),
                                        child: SizedBox(
                                          height: 40,
                                          width: 20,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              WatchListCubit watchCubit =
                                                  BlocProvider.of(context);
                                              watchCubit.insertDate(
                                                  cubit.newRelease![index]);
                                            },
                                            icon: Image.asset(cubit.selected
                                                ? cubit.bookmarkSelected
                                                : cubit.bookmarkAdd),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          // "7.8",
                                          cubit.newRelease![index].voteAverage
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8),
                                    child: Text(
                                      cubit.newRelease![index].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8, top: 5),
                                    child: Text(
                                      cubit.newRelease![index].releaseDate!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 18,
                        ),
                        itemCount: cubit.newRelease!.length,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                elevation: 10,
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, top: 12),
                      child: Text(
                        "Popular",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 235,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            MovieDetailsCubit movCubit =
                                BlocProvider.of(context);
                            movCubit.getMovieData(
                                cubit.popular![index].id.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetails(),
                              ),
                            );
                          },
                          child: SizedBox(
                            // height: 200,
                            width: 120,
                            child: Card(
                              elevation: 10,
                              color: Color(0xff353434),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Stack(
                                    alignment: AlignmentDirectional.topStart,
                                    children: [
                                      (cubit.popular![index].posterPath !=
                                          null
                                          ? Image.network(
                                        "http://image.tmdb.org/t/p/w500/${cubit.popular![index].posterPath!}",
                                        height: 150,
                                        width: 125,
                                        fit: BoxFit.fill,
                                      )
                                          : Image.asset(
                                          "assets/Images/moviesPoster.png")),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                top: 0, start: 8),
                                        child: SizedBox(
                                          height: 40,
                                          width: 20,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              // cubit.selectItem();
                                              WatchListCubit watchCubit =
                                                  BlocProvider.of(context);
                                              watchCubit.insertDate(
                                                  cubit.popular![index]);
                                            },
                                            icon: Image.asset(cubit.selected
                                                ? cubit.bookmarkSelected
                                                : cubit.bookmarkAdd),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          // "7.8",
                                          cubit.popular![index].voteAverage
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8),
                                    child: Text(
                                      cubit.popular![index].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8, top: 5),
                                    child: Text(
                                      cubit.popular![index].releaseDate!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 18,
                        ),
                        itemCount: cubit.popular!.length,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                elevation: 10,
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, top: 12),
                      child: Text(
                        "TopRated",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 235,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            MovieDetailsCubit movCubit =
                                BlocProvider.of(context);
                            movCubit.getMovieData(
                                cubit.topRated![index].id.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetails(),
                              ),
                            );
                          },
                          child: SizedBox(
                            // height: 200,
                            width: 120,
                            child: Card(
                              elevation: 10,
                              color: Color(0xff353434),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Stack(
                                    alignment: AlignmentDirectional.topStart,
                                    children: [
                                      (cubit.topRated![index].posterPath !=
                                          null
                                          ? Image.network(
                                        "http://image.tmdb.org/t/p/w500/${cubit.topRated![index].posterPath!}",
                                        height: 150,
                                        width: 125,
                                        fit: BoxFit.fill,
                                      )
                                          : Image.asset(
                                          "assets/Images/moviesPoster.png")),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                top: 0, start: 8),
                                        child: SizedBox(
                                          height: 40,
                                          width: 20,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              // cubit.selectItem();
                                              WatchListCubit watchCubit =
                                                  BlocProvider.of(context);
                                              watchCubit.insertDate(
                                                  cubit.topRated![index]);
                                            },
                                            icon: Image.asset(cubit.selected
                                                ? cubit.bookmarkSelected
                                                : cubit.bookmarkAdd),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          // "7.8",
                                          cubit.topRated![index].voteAverage
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8),
                                    child: Text(
                                      cubit.topRated![index].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8, top: 5),
                                    child: Text(
                                      cubit.topRated![index].releaseDate!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 18,
                        ),
                        itemCount: cubit.topRated!.length,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                elevation: 10,
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, top: 12),
                      child: Text(
                        "More",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 235,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            MovieDetailsCubit movCubit =
                                BlocProvider.of(context);
                            movCubit
                                .getMovieData(cubit.more![index].id.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetails(),
                              ),
                            );
                          },
                          child: SizedBox(
                            // height: 200,
                            width: 120,
                            child: Card(
                              elevation: 10,
                              color: Color(0xff353434),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Stack(
                                    alignment: AlignmentDirectional.topStart,
                                    children: [
                                      (cubit.more![index].posterPath !=
                                          null
                                          ? Image.network(
                                        "http://image.tmdb.org/t/p/w500/${cubit.more![index].posterPath!}",
                                        height: 150,
                                        width: 125,
                                        fit: BoxFit.fill,
                                      )
                                          : Image.asset(
                                          "assets/Images/moviesPoster.png")),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                top: 0, start: 8),
                                        child: SizedBox(
                                          height: 40,
                                          width: 20,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              // cubit.selectItem();
                                              WatchListCubit watchCubit =
                                                  BlocProvider.of(context);
                                              watchCubit.insertDate(
                                                  cubit.more![index]);
                                            },
                                            icon: Image.asset(cubit.selected
                                                ? cubit.bookmarkSelected
                                                : cubit.bookmarkAdd),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          // "7.8",
                                          cubit.more![index].voteAverage
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8),
                                    child: Text(
                                      cubit.more![index].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8, top: 5),
                                    child: Text(
                                      cubit.more![index].releaseDate!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 18,
                        ),
                        itemCount: cubit.more!.length,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        fallback: (context) => Container(
            color: backgroundColor,
            child: Center(
              child: CircularProgressIndicator(color: Colors.black),
            )),
      ),
    );
  }
}
