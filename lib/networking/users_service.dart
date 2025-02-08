import 'package:cloud_firestore/cloud_firestore.dart';

class UsersService {
  Future<void> addUser(String name, String email, int age, String gender) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users
        .add({
          'name': name,
          'email': email,
          'age': age,
          'gender': gender,
        })
        .then((value) => {print("User added successfully!${value.id}")})
        .catchError((error) => print("Failed to add user: $error"));
  }
}
