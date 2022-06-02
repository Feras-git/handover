import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'models/models.dart';

//TODO Exceptions..

class UserDataRepository {
  final CollectionReference<Map<String, dynamic>> _userCollection =
      FirebaseFirestore.instance.collection('users');

  /// Adds a new user document to the users collection.
  ///
  /// Error handling is done by the caller.
  Future addNewUser({required UserData userData}) async {
    await _userCollection.doc(userData.id).set(userData.toJson());
  }

  /// Updates a user document
  ///
  /// Error handling is done by the caller
  Future updateUser({required UserData userData}) async {
    await _userCollection.doc(userData.id).update(userData.toJson());
  }

  /// Get user's data as UserData model from database.
  ///
  /// Error handling is done by the caller.
  Future<UserData> getUserData({required String userId}) async {
    DocumentSnapshot snapshot = await _userCollection.doc(userId).get();
    Map data = snapshot.data() as Map;
    return UserData.fromJson(data);
  }

  /// Get device FCM TOKEN using fcm package.
  ///
  /// ! This is NOT reading stored tokens in database, there's another function for that.
  static Future<String> _getDeviceToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      return fcmToken;
    } else {
      throw ('Exception happened on calling getToken, The returned Token is null!');
    }
  }

  /// Get FCM TOKENS that are stored in user's doc in database.
  ///
  /// ! This is reading from database, usefull to get tokens of the notification receiver.
  ///
  /// Error handling is done by the caller.
  Future<List> getUserTokens({
    required String userId,
  }) async {
    return await getUserData(userId: userId).then((user) => user.tokens);
  }

  /// Register user's fcm token in user's doc.
  ///
  /// Error handling is done by the caller.
  Future registerUserToken({
    required String userId,
  }) async {
    String token = await _getDeviceToken();
    await _userCollection.doc(userId).update({
      'tokens': FieldValue.arrayUnion([token])
    });
  }

  /// Unregister user's fcm token in user's doc.
  ///
  /// Error handling is done by the caller.
  Future unRegisterUserToken({
    required String userId,
  }) async {
    String token = await _getDeviceToken();
    await _userCollection.doc(userId).update({
      'tokens': FieldValue.arrayRemove([token])
    });
  }
}
