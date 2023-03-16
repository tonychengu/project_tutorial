class UserData {
  // required field
  String uid;
  String name;
  String year;
  String major;
  //List<String> availableCourses;
  String availableCourses;
  // optional field
  String? minor;
  String? about;
  String imagePath;
  int taughtCount;
  int ratings;
  String fullPath;
  int balance;
  //TODO: add time table

  UserData({
    required this.uid,
    required this.name,
    required this.year,
    required this.major,
    this.minor,
    required this.availableCourses,
    this.about,
    this.imagePath =
        'https://firebasestorage.googleapis.com/v0/b/cs370-329f4.appspot.com/o/profileImg.png?alt=media',
    this.taughtCount = 0,
    this.ratings = 0,
    this.balance = 0,
    this.fullPath = '',
  });

  // convert profile to map
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'year': year,
        'major': major,
        'minor': minor,
        'about': about,
        'imagePath': imagePath,
        'availableCourses': availableCourses,
        'taughtCount': taughtCount,
        'ratings': ratings,
        'balance': balance,
        'fullPath': fullPath,
      };

  // convert map to profile
  static UserData fromJson(Map<String, dynamic> json) => UserData(
        uid: json['uid'],
        name: json['name'],
        year: json['year'],
        major: json['major'],
        minor: json['minor'],
        about: json['about'],
        imagePath: json['imagePath'],
        availableCourses: json['availableCourses'],
        taughtCount: json['taughtCount'],
        ratings: json['ratings'],
        balance: json['balance'],
        fullPath: json['fullPath'],
      );

  // copy UserData
  UserData copy(
          {String? uid,
          String? name,
          String? year,
          String? major,
          String? minor,
          String? about,
          String? imagePath,
          String? availableCourses,
          int? taughtCount,
          int? ratings,
          String? fullPath,
          int? balance}) =>
      UserData(
          uid: uid ?? this.uid,
          name: name ?? this.name,
          year: year ?? this.year,
          major: major ?? this.major,
          minor: minor ?? this.minor,
          about: about ?? this.about,
          imagePath: imagePath ?? this.imagePath,
          availableCourses: availableCourses ?? this.availableCourses,
          taughtCount: taughtCount ?? this.taughtCount,
          ratings: ratings ?? this.ratings,
          balance: balance ?? this.balance,
          fullPath: fullPath ?? this.fullPath);

  String getRating() {
    return (1.0 * ratings / taughtCount).toStringAsFixed(1);
  }

  String getNumTaught() {
    return taughtCount.toString();
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
    coursesString = coursesString.substring(0, coursesString.length - 1);
    return this.copy(availableCourses: coursesString);
  }

  // updateImage(XFile image){

  // }
}
