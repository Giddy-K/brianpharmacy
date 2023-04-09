class User {
  String id;
  final String name;
  List location = [];
  List drugs = [];
  final String profession;
  final String mobileNumber;

  User({
    this.id = '',
    required this.name,
    required this.drugs,
    required this.location,
    required this.profession,
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'drugs': drugs,
        'location': location,
        'profession': profession,
        'mobileNumber': mobileNumber
      };

  static User fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        drugs: json['drugs'],
        location: json['location'],
        profession: json['profession'],
        mobileNumber: json['mobileNumber'],
      );
}
