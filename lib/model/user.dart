class User {
  // required field
  String id;
  String name;
  String year;
  String major;
  List<String> availableCourses;
  // optional field
  String? minor;
  String? about;
  String? imagePath;
  //TODO: add time table

  User({
    required this.id,
    required this.name,
    required this.year,
    required this.major,
    this.minor,
    required this.availableCourses,
    this.about,
    this.imagePath,
  });

  // write a method to get rating
  getRating() {
    // query id from database
    return 4.5;
  }

  getNumOfRating() {
    // query rating from database
    return 100;
  }
}
