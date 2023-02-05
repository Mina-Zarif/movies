import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/UI/movieDetails/cubit/movieDetailsCubit.dart';
import 'package:movies/UI/movieDetails/cubit/movieDetailsState.dart';
import 'package:movies/shared/component/component.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Watchlist/cubit/cubitWatchlist.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({Key? key, id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MovieDetailsCubit cubit = BlocProvider.of(context);
    return BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
      builder: (context, state) => ConditionalBuilder(
        condition: state is! LoadingState,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(cubit.movieModel!.title!),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: Container(
            color: backgroundColor,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                (cubit.movieModel!.backdropPath != null
                    ? Image.network(
                        "http://image.tmdb.org/t/p/w500/${cubit.movieModel!.backdropPath}",
                        // height: 150,
                        // width: 125,
                        fit: BoxFit.fill,
                      )
                    : Image.asset("assets/Images/moviesPoster.png")),
                /* Image.network(
                    "http://image.tmdb.org/t/p/w500${cubit.movieModel!.backdropPath}"
                )*/
                // (cubit.topRated![index].posterPath !=
                //                                           null
                //                                           ? Image.network(
                //                                         "http://image.tmdb.org/t/p/w500/${cubit.topRated![index].posterPath!}",
                //                                         height: 150,
                //                                         width: 125,
                //                                         fit: BoxFit.fill,
                //                                       )
                //                                           : Image.asset(
                //                                           "assets/Images/moviesPoster.png")),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        cubit.movieModel!.title!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        cubit.movieModel!.releaseDate!,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 120,
                                child: (cubit.movieModel!.posterPath != null
                                    ? Image.network(
                                        "http://image.tmdb.org/t/p/w500/${cubit.movieModel!.posterPath!}",
                                        height: 150,
                                        width: 125,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        "assets/Images/moviesPoster.png")),
                              ),
                              // "http://image.tmdb.org/t/p/w500${cubit.movieModel!.posterPath!}"),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    top: 8, start: 8),
                                child: SizedBox(
                                  height: 40,
                                  width: 20,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      WatchListCubit watchCubit =
                                          BlocProvider.of(context);
                                      watchCubit.insertDate(cubit.movieModel!);
                                    },
                                    icon: Image.asset(
                                        "assets/Icons/bookmark.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cubit.movieModel!.overview!,
                                  // "Having spent most of her life exploring the jungle, nothing could prepare Dora for her most dangerous adventure yet — high school. ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      cubit.movieModel!.voteAverage!.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        /*URL +=
                                            cubit.movieModel!.title!.toString();*/
                                        Uri myUri = Uri.parse(URL +
                                            cubit.movieModel!.title!
                                                .toString());
                                        cubit.launchInBrowser(myUri);
                                      },
                                      child: Icon(
                                        Icons.play_circle_outlined,
                                        size: 35,
                                        color: Color(0xffbaddf9),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        /*URL +=
                                            cubit.movieModel!.title!.toString();*/
                                        Uri myUri = Uri.parse(URL2 +
                                            cubit.movieModel!.title!
                                                .toString());
                                        cubit.launchInBrowser(myUri);
                                      },
                                      child: Icon(
                                        Icons.download_for_offline_outlined,
                                        size: 35,
                                        color: Color(0xffbaddf9),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: cubit.trailers!.last.key != null,
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: YoutubePlayer(
                      controller: cubit.youtubeController,
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff1c1c1c),
                  height: 15,
                  width: double.infinity,
                ),
                Visibility(
                  visible: cubit.similar!.isNotEmpty,
                  child: Card(
                    elevation: 10,
                    color: Color(0xff2e2d2d),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 8, top: 12),
                          child: Text(
                            "Similar",
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
                                cubit.getMovieData(
                                    cubit.similar![index].id.toString());
                                Navigator.pushReplacement(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Stack(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        children: [
                                          (cubit.similar![index].posterPath !=
                                                  null
                                              ? Image.network(
                                                  "http://image.tmdb.org/t/p/w500${cubit.similar![index].posterPath!}",
                                                  height: 150,
                                                  width: 125,
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.asset(
                                                  "assets/Images/moviesPoster.png")),
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
                                              cubit.similar![index].voteAverage!
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 8),
                                        child: Text(
                                          cubit.similar![index].title!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 8, top: 5),
                                        child: Text(
                                          cubit.similar![index].releaseDate!,
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
                            itemCount: cubit.similar!.length,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: cubit.moreLike!.isNotEmpty,
                  child: Card(
                    elevation: 10,
                    color: Color(0xff2e2d2d),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 8, top: 12),
                          child: Text(
                            "Recommendations",
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
                                cubit.getMovieData(
                                    cubit.moreLike![index].id.toString());
                                Navigator.pushReplacement(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Stack(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        children: [
                                          (cubit.moreLike![index].posterPath !=
                                                  null
                                              ? Image.network(
                                                  "http://image.tmdb.org/t/p/w500${cubit.moreLike![index].posterPath!}",
                                                  height: 150,
                                                  width: 125,
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.asset(
                                                  "assets/Images/moviesPoster.png")),
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
                                              cubit
                                                  .moreLike![index].voteAverage!
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 8),
                                        child: Text(
                                          cubit.moreLike![index].title!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 8, top: 5),
                                        child: Text(
                                          cubit.moreLike![index].releaseDate!,
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
                            itemCount: cubit.moreLike!.length,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
