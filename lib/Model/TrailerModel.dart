class TrailerModel {
  String? key;
  String? type;
  String? id;
  String? site;

  TrailerModel({this.key, this.id, this.site, this.type});

  TrailerModel.fromJson(dynamic json) {
    key = json['key'];
    type = json['type'];
    id = json['id'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['key'] = key;
    json['type'] = type;
    json['id'] = id;
    json['site'] = site;
    return json;
  }
}
/*
"iso_639_1": "en",
"iso_3166_1": "US",
"name": "Official Trailer",
"key": "xgZLXyqbYOc",
"site": "YouTube",
"size": 1080,
"type": "Trailer",
"official": true,
"published_at": "2022-03-15T15:00:17.000Z",
"id": "6230c10362fcd3007179c616"*/
