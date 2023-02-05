import 'dart:ui';
import '../local/DataBase/DataBase.dart';

Color backgroundColor = Color(0xff212020);

String token = "4ca03030e39414c5b8067716ec42ac90" ;
// Color(0xff121312),
void printAllText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String imageUrl = "http://image.tmdb.org/t/p/w500";
String URL2 = "https://shahed4u.mobi/search?s=";
String URL = "https://shahed4u.party/?s=";

var dbHelper = DatabaseHelper();
