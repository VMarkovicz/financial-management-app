import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  Future<UserModel> updateUser(String userName) async {
    final user = _authInstance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    await user.updateProfile(displayName: userName);

    final updatedUser = _authInstance.currentUser;

    return UserModel(
      id: updatedUser?.uid ?? '',
      username: updatedUser?.displayName ?? '',
      email: updatedUser?.email ?? '',
    );
  }

  Future<void> deleteUser(String id) async {
    final user = _authInstance.currentUser;
    if (user == null || user.uid != id) {
      throw Exception('No user is currently signed in or ID does not match.');
    }

    await user.delete();
  }

  Future<double> updateBalance(double value) async {
    final user = _authInstance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    final userDoc = _firestoreInstance.collection('users').doc(user.uid);
    final userData = await userDoc.get();

    if (!userData.exists) {
      throw Exception('User document not found.');
    }

    double currentBalance = userData.data()?['balance'] ?? 0.0;
    double newBalance = currentBalance + value;

    await userDoc.update({'balance': newBalance});

    return newBalance;
  }
}
