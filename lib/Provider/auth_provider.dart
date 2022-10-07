import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Core/route_path.dart';
import '../Database/database_path.dart';
import '../Models/last_message_model.dart';
import '../Models/messages_model.dart';
import '../Models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  FirebaseFirestore get _firebaseStore => FirebaseFirestore.instance;
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? "";

  Users? peerUserData;
  List<Users> userList = [];

  Future signUp(Users users) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: users.email!, password: users.password!);
      // userCredential.user?.sendEmailVerification();
      users.uid = currentUserId;
      await _firebaseStore
          .doc('${DatabasePath.userCollection}/$currentUserId')
          .set(users.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      print("SignUp Error is: $e");
      return false;
    }
  }

  Future logIn(String email, String password) async {
    try {
      // final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // if (!(userCredential.user!.emailVerified)) {
      return true;
    } catch (e) {
      print("LogIn Error is: $e");
      return false;
    }
  }

  void logOut() {
    _firebaseAuth.signOut();
  }

  Stream<List<Users>> getUsersData() {
    return _firebaseStore
        .collection(DatabasePath.userCollection)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => Users.fromJson(document.data()))
            .toList());
    // Users.fromJson(_receivedData as Map<String, dynamic>);
    // return Users.fromJson(_receivedData.docs as Map<String, dynamic>);
    // final allData = _receivedData.docs.map((doc) => doc.data()).toList();
    // for (var element in receivedData.docs) {
    //   final mapData = Users.fromJson(element.data());
    //   userList.add(mapData);
    // }
    // notifyListeners();
  }

  Stream<Users> getLastSeenChat() {
    return _firebaseStore
        .collection(DatabasePath.userCollection)
        .where('uid', isEqualTo: peerUserData!.uid)
        .snapshots()
        .map((snapShot) => Users.fromJson(snapShot.docs[0].data()));
    //     .then((QuerySnapshot value) {
    //   peerUserData =
    //       Users.fromJson(value.docs[0].data() as Map<String, dynamic>);
    // });
  }

  Stream<LastMessageModel> getLastMessage({required String chatId}) {
    return _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .collection(DatabasePath.messages)
        .where('chatId', isEqualTo: chatId)
        .snapshots()
        .map((snapShot) => LastMessageModel.fromJson(snapShot.docs[0].data()));

    //     .then((QuerySnapshot value) {
    //   peerUserData =
    //       Users.fromJson(value.docs[0].data() as Map<String, dynamic>);
    // });
  }

  Stream<List<MessagesModel>> getMessages({required String chatId}) {
    return FirebaseFirestore.instance
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .orderBy("msgTime", descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => MessagesModel.fromJson(document.data()))
            .toList());
  }

  void usersClickListener(Users snapshot, BuildContext context) {
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .where('uid', isEqualTo: snapshot.uid)
        .get()
        .then((QuerySnapshot value) {
      peerUserData =
          Users.fromJson(value.docs[0].data() as Map<String, dynamic>);

      Navigator.pushNamed(
        context,
        AppRoutes.chat,
      );
    });
    notifyListeners();
  }

  void updateUserStatus(userStatus) {
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .update({'userStatus': userStatus});
  }

  UploadTask getRefrenceFromStorage(file, voiceMessageName, context) {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("Media")
        .child(getChatId(context))
        .child(file is File
            ? voiceMessageName
            : file.runtimeType == FilePickerResult
                ? file.files.single.name
                : file.name);
    return ref.putFile(file is File
        ? file
        : File(file.runtimeType == FilePickerResult
            ? file!.files.single.path
            : file.path));
  }

  void sendMessage(
      {required chatId,
      required senderId,
      required receiverId,
      required msgTime,
      required msgType,
      required message,
      required fileName}) {
    ///current user
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .doc("${Timestamp.now().millisecondsSinceEpoch}")
        .set({
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'msgTime': msgTime,
      'msgType': msgType,
      'message': message,
      'fileName': fileName,
    });

    ///peer user
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(peerUserData!.uid)
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .doc("${Timestamp.now().millisecondsSinceEpoch}")
        .set({
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'msgTime': msgTime,
      'msgType': msgType,
      'message': message,
      'fileName': fileName,
    });

    ////last message create current user
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .get()
        .then((QuerySnapshot value) {
      if (value.size == 1) {
        ///current user
        _firebaseStore
            .collection(DatabasePath.userCollection)
            .doc(currentUserId)
            .collection(DatabasePath.messages)
            .doc(chatId)
            .set({
          'chatId': chatId,
          'lastSenderId': senderId,
          'lastReceiverId': receiverId,
          'lastMsgTime': msgTime,
          'lastMsgType': msgType,
          'lastMessage': message,
          'lastFileName': fileName,
        });

        ///peer user
        _firebaseStore
            .collection(DatabasePath.userCollection)
            .doc(peerUserData!.uid)
            .collection(DatabasePath.messages)
            .doc(chatId)
            .set({
          'chatId': chatId,
          'lastSenderId': senderId,
          'lastReceiverId': receiverId,
          'lastMsgTime': msgTime,
          'lastMsgType': msgType,
          'lastMessage': message,
          'lastFileName': fileName,
        });
      }

      ////last message update current user
      _firebaseStore
          .collection(DatabasePath.userCollection)
          .doc(currentUserId)
          .collection(DatabasePath.messages)
          .doc(chatId)
          .update({
        'chatId': chatId,
        'lastSenderId': senderId,
        'lastReceiverId': receiverId,
        'lastMsgTime': msgTime,
        'lastMsgType': msgType,
        'lastMessage': message,
        'lastFileName': fileName,
      });

      ////last message update peer user
      _firebaseStore
          .collection(DatabasePath.userCollection)
          .doc(peerUserData!.uid)
          .collection(DatabasePath.messages)
          .doc(chatId)
          .update({
        'chatId': chatId,
        'lastSenderId': senderId,
        'lastReceiverId': receiverId,
        'lastMsgTime': msgTime,
        'lastMsgType': msgType,
        'lastMessage': message,
        'lastFileName': fileName,
      });
    });

    ///
  }

  // update last message
  // void updateLastMessage(
  //     {required chatId,
  //     required senderId,
  //     required receiverId,
  //     required receiverUsername,
  //     required msgTime,
  //     required msgType,
  //     required message,
  //     required context}) {
  //   lastMessageForPeerUser(receiverId, senderId, chatId, context,
  //       receiverUsername, msgTime, msgType, message);
  //   lastMessageForCurrentUser(receiverId, senderId, chatId, context,
  //       receiverUsername, msgTime, msgType, message);
  // }

  // void lastMessageForPeerUser(receiverId, senderId, chatId, context,
  //     receiverUsername, msgTime, msgType, message) {
  //   _firebaseStore
  //       .collection(DatabasePath.userCollection)
  //       .doc(currentUserId)
  //       .collection("lastMessages")
  //       .doc(receiverId)
  //       .collection(receiverId)
  //       .where('chatId', isEqualTo: chatId)
  //       .get()
  //       .then((QuerySnapshot value) {
  //     if (value.size == 0) {
  //       _firebaseStore
  //           .collection(DatabasePath.userCollection)
  //           .doc(currentUserId)
  //           .collection("lastMessages")
  //           .doc(receiverId)
  //           .collection(receiverId)
  //           .doc("${Timestamp.now().millisecondsSinceEpoch}")
  //           .set({
  //         'chatId': chatId,
  //         'messageFrom': FirebaseAuth.instance.currentUser?.displayName,
  //         'messageTo': receiverUsername,
  //         'messageSenderId': senderId,
  //         'messageReceiverId': receiverId,
  //         'msgTime': msgTime,
  //         'msgType': msgType,
  //         'message': message,
  //       });
  //     } else {
  //       _firebaseStore
  //           .collection(DatabasePath.userCollection)
  //           .doc(currentUserId)
  //           .collection("lastMessages")
  //           .doc(receiverId)
  //           .collection(receiverId)
  //           .doc(value.docs[0].id)
  //           .update({
  //         'messageFrom': FirebaseAuth.instance.currentUser?.displayName,
  //         'messageTo': receiverUsername,
  //         'messageSenderId': senderId,
  //         'messageReceiverId': receiverId,
  //         'msgTime': msgTime,
  //         'msgType': msgType,
  //         'message': message,
  //       });
  //     }
  //   });
  // }

  // void lastMessageForCurrentUser(receiverId, senderId, chatId, context,
  //     receiverUsername, msgTime, msgType, message) {
  //   _firebaseStore
  //       .collection(DatabasePath.userCollection)
  //       .doc(currentUserId)
  //       .collection("lastMessages")
  //       .doc(senderId)
  //       .collection(senderId)
  //       .where('chatId', isEqualTo: chatId)
  //       .get()
  //       .then((QuerySnapshot value) {
  //     if (value.size == 0) {
  //       _firebaseStore
  //           .collection(DatabasePath.userCollection)
  //           .doc(currentUserId)
  //           .collection("lastMessages")
  //           .doc(senderId)
  //           .collection(senderId)
  //           .doc("${Timestamp.now().millisecondsSinceEpoch}")
  //           .set({
  //         'chatId': chatId,
  //         'messageFrom': FirebaseAuth.instance.currentUser?.displayName,
  //         'messageTo': receiverUsername,
  //         'messageSenderId': senderId,
  //         'messageReceiverId': receiverId,
  //         'msgTime': msgTime,
  //         'msgType': msgType,
  //         'message': message,
  //       });
  //     } else {
  //       _firebaseStore
  //           .collection(DatabasePath.userCollection)
  //           .doc(currentUserId)
  //           .collection("lastMessages")
  //           .doc(senderId)
  //           .collection(senderId)
  //           .doc(value.docs[0].id)
  //           .update({
  //         'messageFrom': FirebaseAuth.instance.currentUser?.displayName,
  //         'messageTo': receiverUsername,
  //         'messageSenderId': senderId,
  //         'messageReceiverId': receiverId,
  //         'msgTime': msgTime,
  //         'msgType': msgType,
  //         'message': message,
  //       });
  //     }
  //   });
  // }

  String getChatId(BuildContext context) {
    return "${peerUserData!.uid} - $currentUserId";
    // currentUserId.hashCode <= peerUserData!.uid.hashCode
    //     ? "$currentUserId - ${peerUserData!.uid}"
    //     :
  }
}
