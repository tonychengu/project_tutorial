class EventsData {
  // required field
  String? uid;
  String tutor_uid;
  String student_uid;
  String tutor_name;
  String student_name;
  DateTime start;
  DateTime end;
  String status;
  String course;
  String code;
  int? cost;

  // optional field
  String? location;
  String? review;
  int rating;

  //TODO: add time table

  EventsData(
      {this.uid,
      required this.tutor_uid,
      required this.student_uid,
      required this.tutor_name,
      required this.student_name,
      required this.start,
      required this.end,
      required this.status,
      required this.location,
      required this.course,
      this.cost,
      this.review,
      this.rating = 0,
      this.code = '123456'});

  // convert profile to map
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'tutor_uid': tutor_uid,
        'student_uid': student_uid,
        'tutor_name': tutor_name,
        'student_name': student_name,
        'start': start,
        'end': end,
        'location': location,
        'status': status,
        'rating': rating,
        'cost': cost,
        'review': review,
        'course': course,
      };

  // convert map to profile
  static EventsData fromJson(Map<String, dynamic> json) => EventsData(
        uid: json['uid'],
        tutor_uid: json['tutor_uid'],
        student_uid: json['student_uid'],
        tutor_name: json['tutor_name'],
        student_name: json['student_name'],
        start: json['start'],
        end: json['end'],
        location: json['location'],
        status: json['status'],
        rating: json['rating'],
        cost: json['cost'],
        review: json['review'],
        course: json['course'],
      );

  // copy UserData
  EventsData copy(
          {String? uid,
          String? tutor_uid,
          String? student_uid,
          String? tutor_name,
          String? student_name,
          DateTime? start,
          DateTime? end,
          String? location,
          String? status,
          int? rating,
          int? cost,
          String? review,
          String? course}) =>
      EventsData(
        uid: uid ?? this.uid,
        tutor_uid: tutor_uid ?? this.tutor_uid,
        student_uid: student_uid ?? this.student_uid,
        start: start ?? this.start,
        end: end ?? this.end,
        location: location ?? this.location,
        status: status ?? this.status,
        rating: rating ?? this.rating,
        cost: cost ?? this.cost,
        review: review ?? this.review,
        course: course ?? this.course,
        tutor_name: tutor_name ?? this.tutor_name,
        student_name: student_name ?? this.student_name,
      );

  void updateStatus(String newStatus) {
    this.status = newStatus;
  }

  // updateImage(XFile image){

  // }
}
