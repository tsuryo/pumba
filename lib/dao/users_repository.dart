import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pumba_project/model/User.dart';

class UsersRepository {
  final CollectionReference<User> _usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  Future<User?> getUser(String id) async {
    try {
      DocumentSnapshot<User> docSnapshot = await _usersRef.doc(id).get();
      if (docSnapshot.exists) {
        return docSnapshot.data()!;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> saveUser(User user) async {
    try {
      DocumentReference<User> docRef = await _usersRef.add(user);
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      await _usersRef.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

}
