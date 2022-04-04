class User {
  final String email, firstName, lastName;

  User({required this.email, required this.firstName, required this.lastName});

  User.fromJSON(Map<String, dynamic> json)
      : email = json['email'],
        firstName = json['first_name'],
        lastName = json['last_name'];
}
