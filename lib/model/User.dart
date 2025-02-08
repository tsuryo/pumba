class User {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;

  User(
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
  );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'gender': gender,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        json['firstName'] as String,
        json['lastName'] as String,
        json['email'] as String,
        json['gender'] as String,
      );
}
