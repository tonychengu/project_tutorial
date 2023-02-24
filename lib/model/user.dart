class UserData {
  // required field
  String id;
  String name;
  String year;
  String major;
  //List<String> availableCourses;
  String availableCourses;
  // optional field
  String? minor;
  String? about;
  String imagePath;
  //TODO: add time table

  UserData({
    required this.id,
    required this.name,
    required this.year,
    required this.major,
    this.minor,
    required this.availableCourses,
    this.about,
    this.imagePath =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
  });

  // convert profile to map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'year': year,
        'major': major,
        'minor': minor,
        'about': about,
        'imagePath': imagePath,
        'availableCourses': availableCourses,
      };

  // convert map to profile
  static UserData fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'],
        name: json['name'],
        year: json['year'],
        major: json['major'],
        minor: json['minor'],
        about: json['about'],
        imagePath: json['imagePath'],
        availableCourses: json['availableCourses'],
      );

  // copy UserData
  UserData copy({
    String? id,
    String? name,
    String? year,
    String? major,
    String? minor,
    String? about,
    String? imagePath,
    String? availableCourses,
  }) =>
      UserData(
        id: id ?? this.id,
        name: name ?? this.name,
        year: year ?? this.year,
        major: major ?? this.major,
        minor: minor ?? this.minor,
        about: about ?? this.about,
        imagePath: imagePath ?? this.imagePath,
        availableCourses: availableCourses ?? this.availableCourses,
      );

  // write a method to get rating
  getRating() {
    // query id from database
    return 4.5;
  }

  getNumOfRating() {
    // query rating from database
    return 100;
  }

  getAvlCourses() {
    List<String> courses = availableCourses.split(',');
    return courses;
  }

  UserData updateAvlCourses(String courses) {
    List<String> newCourses = courses.split(',');
    String coursesString = '';
    for (var course in newCourses) {
      coursesString += course + ',';
    }
    return this.copy(availableCourses: coursesString);
  }

  // updateImage(XFile image){

  // }
}
