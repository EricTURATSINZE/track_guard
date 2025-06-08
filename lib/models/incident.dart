class Incident {
  int? id;
  String title;
  String description;
  String category;
  String location;
  String dateTime;
  String status;
  String? photo;

  Incident(
      {this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.location,
      required this.dateTime,
      required this.status,
      this.photo});

  Incident.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        category = json['category'],
        location = json['location'],
        dateTime = json['dateTime'],
        status = json['status'],
        photo = json['photo'];

  Map<String, Object> toJson() {
    final Map<String, Object> data = <String, Object>{};
    if (id != null) {
      data['id'] = id!;
    }
    data['title'] = title;
    data['description'] = description;
    data['category'] = category;
    data['location'] = location;
    data['dateTime'] = dateTime;
    data['status'] = status;
    if (photo != null) {
      data['photo'] = photo!;
    }
    return data;
  }

  // to string
  @override
  String toString() {
    return '''
      Incident {
        id: $id,
        title: $title,
        description: $description,
        category: $category,
        location: $location,
        dateTime: $dateTime,
        status: $status,
        photo: $photo,
      }
    ''';
  }
}
