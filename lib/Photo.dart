class Photo {
  final String name;
  final String height;
  final String mass;
  final String gender;
  String url;


  Photo(this.name, this.height, this.mass, this.gender, this.url);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        json["name"],
        json["height"],
        json["mass"],
        json["gender"],
        json["url"].replaceAll("https://swapi.dev/api/people/", "&").replaceAll("/",".jpg").replaceAll("&", "https://starwars-visualguide.com/assets/img/characters/") );
  }

  static List<Photo> parseList(List<dynamic> list) {
    return list.map((i) => Photo.fromJson(i)).toList();
  }
}