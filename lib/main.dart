import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/UI/Home/cubit/HomeCubit.dart';
import 'package:movies/UI/Search/cubit/SearchCubit.dart';
import 'package:movies/UI/Watchlist/cubit/cubitWatchlist.dart';
import 'package:movies/UI/splash/splashScreen.dart';
import 'package:movies/shared/BlocObserver/BlocObserver.dart';
import 'package:movies/shared/component/component.dart';
import 'package:movies/shared/cubit/AppCubit.dart';
import 'package:movies/shared/cubit/AppStates.dart';
import 'package:movies/shared/network/dio_helper.dart';
import 'UI/movieDetails/cubit/movieDetailsCubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit()
            ..getPopular()
            ..getNewReleases()
            ..getTopRated()
            ..getMore(),
        ),
        BlocProvider(
          create: (context) => MovieDetailsCubit(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(),
        ),
        BlocProvider(
          create: (context) => WatchListCubit()..getData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: backgroundColor, //Color(0xff121312),
            ),
          ),
          // floatingActionButtonTheme: FloatingActionButtonThemeData(
          //     backgroundColor: Color(0xff121312)),
        ),
        home:   SplashScreen(), /*const GetTokenScreen(),*/
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = BlocProvider.of(context);
        return WillPopScope(
          onWillPop: () async {
            if (cubit.currentInd != 0) {
              cubit.changeInd(0);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // backgroundColor: backgroundColor,
                      title: const Text(
                        'Are you sure?',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: const Text(
                        'Do you want to exit?',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: const Text(
                            "NO",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => SystemNavigator.pop(),
                          child: const Text(
                            "YES",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 2),
                      ],
                      // icon: Icon(Icons.warning_amber),
                    );
                  });
              return true;
            }
            return false;
          },
          child: Scaffold(
            body: cubit.screens[cubit.currentInd],
            bottomNavigationBar: BottomNavigationBar(
              // showSelectedLabels: true,
              unselectedItemColor: Colors.white,
              onTap: (value) => cubit.changeInd(value),
              currentIndex: cubit.currentInd,
              showUnselectedLabels: true,
              selectedItemColor: Colors.amber,
              backgroundColor: Color(0xff121312),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home'.toUpperCase(),
                    backgroundColor: Color(0xff121312)),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search'.toUpperCase(),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: 'Watchlist'.toUpperCase()),
              ],

              // elevation: 5.0,
            ),
          ),
        );
      },
    );
  }
}
