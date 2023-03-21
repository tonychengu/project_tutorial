class EventsData {
  // required field
  String uid;
  String tutor_uid;
  String student_uid;
  String time;
  String status;
  int cost;

  // optional field
  String? location;
  String? review;
  int rating;

  //TODO: add time table

  EventsData({
    required this.uid,
    required this.tutor_uid,
    required this.student_uid,
    required this.time,
    required this.status,
    required this.cost,
    this.location,
    this.review,
    this.rating = 0,
  });

  // convert profile to map
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'tutor_uid': tutor_uid,
        'student_uid': student_uid,
        'time': time,
        'location': location,
        'status': status,
        'rating': rating,
        'cost': cost,
        'review': review,
      };

  // convert map to profile
  static EventsData fromJson(Map<String, dynamic> json) => EventsData(
        uid: json['uid'],
        tutor_uid: json['tutor_uid'],
        student_uid: json['student_uid'],
        time: json['time'],
        location: json['location'],
        status: json['status'],
        rating: json['rating'],
        cost: json['cost'],
        review: json['review'],
      );

  // copy UserData
  EventsData copy(
          {String? uid,
          String? tutor_uid,
          String? student_uid,
          String? time,
          String? location,
          String? status,
          int? rating,
          int? cost,
          String? review}) =>
      EventsData(
          uid: uid ?? this.uid,
          tutor_uid: tutor_uid ?? this.tutor_uid,
          student_uid: student_uid ?? this.student_uid,
          time: time ?? this.time,
          location: location ?? this.location,
          status: status ?? this.status,
          rating: rating ?? this.rating,
          cost: cost ?? this.cost,
          review: review ?? this.review);

  void updateStatus(String newStatus) {
    this.status = newStatus;
  }

  // updateImage(XFile image){

  // }
}