class Photo {
  final String name;
  final String height;
  final String mass;
  final String gender;
  final String hcolor; //json["hair_color"],
  final String scolor; //json["skin_color"],
  final String ecolor; //json["eye_color"],
  final String byear; //json["birth_year"]

  String url;


  Photo(this.name, this.height, this.mass, this.gender, this.hcolor, this.scolor, this.ecolor, this.byear, this.url);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        json["name"],
        json["height"],
        json["mass"],
        json["gender"],
        json["hair_color"],
        json["skin_color"],
        json["eye_color"],
        json["birth_year"],
        json["url"].replaceAll("https://swapi.dev/api/people/", "&").replaceAll("/",".jpg").replaceAll("&", "https://starwars-visualguide.com/assets/img/characters/") );
  }

  static List<Photo> parseList(List<dynamic> list) {
    return list.map((i) => Photo.fromJson(i)).toList();
  }
}