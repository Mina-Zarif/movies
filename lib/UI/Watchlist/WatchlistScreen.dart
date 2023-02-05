import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movies/Model/MovieModel.dart';
import 'package:movies/UI/Watchlist/cubit/StateWatchlist.dart';
import 'package:movies/UI/movieDetails/cubit/movieDetailsCubit.dart';
import 'package:movies/UI/movieDetails/movieDetailsScreen.dart';

import '../../shared/component/component.dart';
import 'cubit/cubitWatchlist.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchListCubit, WatchListState>(
      builder: (context, state) {
        WatchListCubit cubit = BlocProvider.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text("Watchlist"),
            backgroundColor: backgroundColor,
            elevation: 1.5,
            actions: [
              TextButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: backgroundColor,
                        // title: const Text('AlertDialog Title'),
                        content: const Text('Do you sure to clear watchList?',style: TextStyle(color: Colors.red),),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel',style: TextStyle(color: Colors.white),),
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.clearDataBase();
                              Navigator.pop(context, 'Sure');
                            },
                            child: const Text('Sure',style: TextStyle(color: Colors.red),),
                          ),
                        ],
                      ),
                    );
                    // cubit.clearDataBase();
                  },
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Text(
                    "clear",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            color: backgroundColor,
            child: ConditionalBuilder(
              condition: cubit.watchList.isNotEmpty,
              builder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return bulidItem(context, cubit.watchList[index]);
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: cubit.watchList.length,
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
            ),
          ),
        );
      },
    );
  }

  Widget bulidItem(context, MovieModel model) {
    WatchListCubit cubit = BlocProvider.of(context);
    return Slidable(
      startActionPane:ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) => cubit.delete(model.voteAverage!),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(17),topRight: Radius.circular(17)),
        ),
      ]),
      child: InkWell(
        onTap: () {
          MovieDetailsCubit movCubit = BlocProvider.of(context);
          movCubit.getMovieData(model.id!.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetails(),
            ),
          );
        },
        child: Row(children: [
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 80,
            height: 120,
            child: Image.network(
              "$imageUrl${model.posterPath}",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 220,
                child: Text(
                  model.title!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                model.backdropPath!,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
