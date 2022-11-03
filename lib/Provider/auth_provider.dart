import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Core/route_path.dart';
import '../Database/database_path.dart';
import '../Models/messages_model.dart';
import '../Models/user_model.dart';
import '../Widgets/utils.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  FirebaseFirestore get _firebaseStore => FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FacebookAuth _facebookAuth = FacebookAuth.instance;

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? "";

  Users? peerUserData;
  List<Users> userList = [];
  bool scrollChat = false;
  final scrollController = ScrollController();

  scrolUp(bool value) => scrollChat = value;
  scrolDown(bool value) => scrollChat = value;

  Future<String> _fToken() async =>
      await FirebaseMessaging.instance.getToken() ?? "";

  /// Invoke to signIn user with phone number.
  Future<void> signInWithPhone(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException error) {
          throw Exception(error.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          Navigator.pushNamed(
            context,
            AppRoutes.otpscreen,
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } on FirebaseAuthException catch (e) {
      buildShowSnackBar(context, e.message!);
    }
  }

  /// Invoke to verify otp.
  Future<void> verifyOTP(
    BuildContext context,
    bool mounted, {
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // UserCredential userCredential =
      await _firebaseAuth
          .signInWithCredential(credential)
          .then((userCredential) async {
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            Users users = Users(
              email: '',
              fcmToken: await _fToken(),
              name: '',
              userStatus: 'Online',
              userPic: '',
              chatWith: '',
              uid: userCredential.user!.uid,
              phoneNumber: userCredential.user!.phoneNumber,
            );
            await _firebaseStore
                .doc('${DatabasePath.userCollection}/$currentUserId')
                .set(users.toJson(), SetOptions(merge: true))
                .then((value) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.userinfoget,
                arguments: UserIdModel(userCredential.user!.uid),
                (route) => false,
              );
            });
          } else {
            checkUserData(context);
            // _firebaseStore
            //     .collection(DatabasePath.userCollection)
            //     .doc(userCredential.user!.uid)
            //     .get()
            //     .then((snapShot) {
            //   var userData = Users.fromJson(snapShot.data()!);
            //   if (userData.email!.isEmpty || userData.name!.isEmpty) {
            //     Navigator.pushNamedAndRemoveUntil(
            //       context,
            //       AppRoutes.userinfoget,
            //       arguments: UserIdModel(userCredential.user!.uid),
            //       // {"userId": userCredential.user!.uid},
            //       (route) => false,
            //     );
            //   } else {
            //     Navigator.pushNamedAndRemoveUntil(
            //       context,
            //       AppRoutes.home,
            //       (route) => false,
            //     );
            //   }
            // });
            // .map((snapShot) => Users.fromJson(snapShot.data()!));

          }
        } else {
          throw Exception('Something went wrong');
        }
      });

// userCredential.additionalUserInfo.isNewUser

    } on FirebaseAuthException catch (e) {
      buildShowSnackBar(context, e.message!);
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth
        .signInWithCredential(credential)
        .then((userCredential) async {
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          Users users = Users(
            email: userCredential.user!.email,
            fcmToken: await _fToken(),
            name: userCredential.user!.displayName,
            userStatus: 'Online',
            userPic: userCredential.user!.photoURL,
            chatWith: '',
            uid: userCredential.user!.uid,
            phoneNumber: '',
          );
          await _firebaseStore
              .doc('${DatabasePath.userCollection}/$currentUserId')
              .set(users.toJson(), SetOptions(merge: true))
              .then((value) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              arguments: UserIdModel(userCredential.user!.uid),
              (route) => false,
            );
          });
        } else {
          checkUserData(context);
        }
      } else {
        throw Exception('Something went wrong');
      }
    });
  }

  Future<void> facebookSignIn(BuildContext context) async {
    // final LoginResult result =
    // FacebookAuth.instance
    //     .login(permissions: ['email', 'public_profile']).then((value) {
    //   FacebookAuth.instance.getUserData().then((userData) {
    //     print(userData);
    //   });
    // });
    final LoginResult result = await FacebookAuth.instance.login();
    // if (result.status == LoginStatus.success) {
    //   // _accessToken = result.accessToken;
    //   // _printCredentials();
    //   // get the user data
    //   // by default we get the userId, email,name and picture
    //   final userData = await FacebookAuth.instance.getUserData();
    //   // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
    //   // _userData = userData;
    //   print(userData);
    // } else {
    //   print(result.status);
    //   print(result.message);
    // }
    if (result.status == LoginStatus.success) {
      // var da = _facebookAuth.getUserData();
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await _firebaseAuth
          .signInWithCredential(credential)
          .then((userCredential) async {
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            Users users = Users(
              email: userCredential.user!.email,
              fcmToken: await _fToken(),
              name: userCredential.user!.displayName,
              userStatus: 'Online',
              userPic: userCredential.user!.photoURL,
              chatWith: '',
              uid: userCredential.user!.uid,
              phoneNumber: '',
            );
            await _firebaseStore
                .doc('${DatabasePath.userCollection}/$currentUserId')
                .set(users.toJson(), SetOptions(merge: true))
                .then((value) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                arguments: UserIdModel(userCredential.user!.uid),
                (route) => false,
              );
            });
          } else {
            checkUserData(context);
          }
        } else {
          throw Exception('Something went wrong');
        }
      });
    }
  }

  checkUserData(BuildContext context) {
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .get()
        .then((snapShot) {
      var userData = Users.fromJson(snapShot.data()!);
      if (userData.email!.isEmpty || userData.name!.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.userinfoget,
          arguments: UserIdModel(currentUserId),
          // {"userId": userCredential.user!.uid},
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      }
    });
  }

  Future signUp(Users users, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: users.email!, password: password);
      // userCredential.user?.sendEmailVerification();
      users.uid = currentUserId;
      users.fcmToken = await _fToken();
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

  void logOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    FacebookAuth.instance.logOut();
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

  void usersUpdate(BuildContext context, Users users, userId) {
    _firebaseStore.collection(DatabasePath.userCollection).doc(userId).update({
      "name": users.name,
      "email": users.email,
      "userPic": users.userPic,
    }).then((value) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    });

    notifyListeners();
  }

  void updateCallStatus(status) {
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .update({"chatWith": status});
  }

  void userProfilePicUpdate(BuildContext context, String? profilePic) {
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(currentUserId)
        .update({
      "userPic": profilePic,
    }).then((value) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    });

    notifyListeners();
  }

  Stream<Users> getLastSeenChat() {
    return _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(peerUserData!.uid)
        // .where('uid', isEqualTo: peerUserData!.uid)
        .snapshots()
        .map((snapShot) => Users.fromJson(snapShot.data()!));
    //     .then((QuerySnapshot value) {
    //   peerUserData =
    //       Users.fromJson(value.docs[0].data() as Map<String, dynamic>);
    // });
  }

  Stream<Users> getUserDetailsWithId(userId) {
    return _firebaseStore
        .collection(DatabasePath.userCollection)
        .doc(userId)
        // .where('uid', isEqualTo: userId)
        .snapshots()
        .map((snapShot) => Users.fromJson(snapShot.data()!));
    //     .then((QuerySnapshot value) {
    //   peerUserData =
    //       Users.fromJson(value.docs[0].data() as Map<String, dynamic>);
    // });
  }

  // Stream<LastMessageModel> getLastMessage({required String chatId}) {
  //   return _firebaseStore
  //       .collection(DatabasePath.messages)
  //       .where('chatId', isEqualTo: chatId)
  //       .snapshots()
  //       .map((snapShot) => LastMessageModel.fromJson(snapShot.docs[0].data()));

  //   //     .then((QuerySnapshot value) {
  //   //   peerUserData =
  //   //       Users.fromJson(value.docs[0].data() as Map<String, dynamic>);
  //   // });
  // }

  Stream<List<MessagesModel>> getMessages({required String chatId}) {
    return FirebaseFirestore.instance
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .orderBy("msgTime", descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => MessagesModel.fromJson(document.data()))
            .toList());
  }

  void usersClickListener(Users users, BuildContext context) {
    _firebaseStore
        .collection(DatabasePath.userCollection)
        .where('uid', isEqualTo: users.uid)
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

  void getMessagesListData({required String chatId}) {
    FirebaseFirestore.instance
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .orderBy("msgTime", descending: true)
        .get();
    // .map((snapShot) => snapShot.docs
    //     .map((document) => MessagesModel.fromJson(document.data()))
    //     .toList());
  }

  void updatePeerUserRead(chatId, isReadStatus) async {
    // var collectionExistt = _firebaseStore
    //     .collection(DatabasePath.messages)
    //     .doc(chatId)
    //     .collection(chatId)
    //     .where('isRead', isEqualTo: false);

    var collection = _firebaseStore
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false);

    var querySnapshots = await collection.get();

    for (var doc in querySnapshots.docs) {
      if (doc.exists) {
        await doc.reference.update({
          'isRead': isReadStatus,
        });
      }
    }
  }

  // void updatePeerUserReadLength() async {
  //   var collection = _firebaseStore
  //       .collection(DatabasePath.messages)
  //       .doc(getChatId())
  //       .collection(getChatId())
  //       .where('isRead', isEqualTo: false);

  //   var querySnapshots = await collection.get();
  //   return querySnapshots;
  // }

  UploadTask getRefrenceFromStorage(file, voiceMessageName, context) {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("Media").child(getChatId()).child(file is File
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

  UploadTask getRefrenceFromStorageProfileImage(
      file, voiceMessageName, context) {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("ProfilePic")
        .child(currentUserId!)
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
    var ref = _firebaseStore
        .collection(DatabasePath.messages)
        .doc(chatId)
        .collection(chatId)
        .doc("${Timestamp.now().millisecondsSinceEpoch}");

    MessagesModel messagesModel = MessagesModel(
      chatId: chatId,
      message: message,
      msgType: msgType,
      msgTime: msgTime,
      receiverId: receiverId,
      senderId: senderId,
      fileName: fileName,
      isRead: false,
      docId: ref.id,
    );
    // "${Timestamp.now().millisecondsSinceEpoch}"
    ref.set(messagesModel.toJson()
        //     {
        //   'chatId': chatId,
        //   'senderId': senderId,
        //   'receiverId': receiverId,
        //   'msgTime': msgTime,
        //   'msgType': msgType,
        //   'message': message,
        //   'fileName': fileName,
        // }
        );

    // ////last message create current user
    // _firebaseStore
    //     .collection(DatabasePath.userCollection)
    //     .doc(currentUserId)
    //     .collection(DatabasePath.messages)
    //     .doc(chatId)
    //     .collection(chatId)
    //     .get()
    //     .then((QuerySnapshot value) {
    //   if (value.size == 1) {
    //     ///current user
    //     _firebaseStore
    //         .collection(DatabasePath.userCollection)
    //         .doc(currentUserId)
    //         .collection(DatabasePath.messages)
    //         .doc(chatId)
    //         .set({
    //       'chatId': chatId,
    //       'lastSenderId': senderId,
    //       'lastReceiverId': receiverId,
    //       'lastMsgTime': msgTime,
    //       'lastMsgType': msgType,
    //       'lastMessage': message,
    //       'lastFileName': fileName,
    //     });

    //     ///peer user
    //     _firebaseStore
    //         .collection(DatabasePath.userCollection)
    //         .doc(peerUserData!.uid)
    //         .collection(DatabasePath.messages)
    //         .doc(chatId)
    //         .set({
    //       'chatId': chatId,
    //       'lastSenderId': senderId,
    //       'lastReceiverId': receiverId,
    //       'lastMsgTime': msgTime,
    //       'lastMsgType': msgType,
    //       'lastMessage': message,
    //       'lastFileName': fileName,
    //     });
    //   }

    //   ////last message update current user
    //   _firebaseStore
    //       .collection(DatabasePath.userCollection)
    //       .doc(currentUserId)
    //       .collection(DatabasePath.messages)
    //       .doc(chatId)
    //       .update({
    //     'chatId': chatId,
    //     'lastSenderId': senderId,
    //     'lastReceiverId': receiverId,
    //     'lastMsgTime': msgTime,
    //     'lastMsgType': msgType,
    //     'lastMessage': message,
    //     'lastFileName': fileName,
    //   });

    //   ////last message update peer user
    //   _firebaseStore
    //       .collection(DatabasePath.userCollection)
    //       .doc(peerUserData!.uid)
    //       .collection(DatabasePath.messages)
    //       .doc(chatId)
    //       .update({
    //     'chatId': chatId,
    //     'lastSenderId': senderId,
    //     'lastReceiverId': receiverId,
    //     'lastMsgTime': msgTime,
    //     'lastMsgType': msgType,
    //     'lastMessage': message,
    //     'lastFileName': fileName,
    //   });
    // });

    ///
  }

  //////////////////////////////
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

  // void lastMessageForCurrentUser(receiverId, senderId, chatId, context,
  //     receiverUsername, msgTime, msgType, message) {
  //   FirebaseFirestore.instance
  //       .collection("lastMessages")
  //       .doc(senderId)
  //       .collection(senderId)
  //       .where('chatId', isEqualTo: chatId)
  //       .get()
  //       .then((QuerySnapshot value) {
  //     if (value.size == 0) {
  //       FirebaseFirestore.instance
  //           .collection("lastMessages")
  //           .doc(senderId)
  //           .collection(senderId)
  //           .doc("${Timestamp.now().millisecondsSinceEpoch}")
  //           .set({
  //         'chatId': chatId,
  //         'messageFrom': FirebaseAuth.instance.currentUser!.displayName,
  //         'messageTo': receiverUsername,
  //         'messageSenderId': senderId,
  //         'messageReceiverId': receiverId,
  //         'msgTime': msgTime,
  //         'msgType': msgType,
  //         'message': message,
  //       });
  //     } else {
  //       FirebaseFirestore.instance
  //           .collection("lastMessages")
  //           .doc(senderId)
  //           .collection(senderId)
  //           .doc(value.docs[0].id)
  //           .update({
  //         'messageFrom': FirebaseAuth.instance.currentUser!.displayName,
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

  // void lastMessageForPeerUser(receiverId, senderId, chatId, context,
  //     receiverUsername, msgTime, msgType, message) {
  //   FirebaseFirestore.instance
  //       .collection("lastMessages")
  //       .doc(receiverId)
  //       .collection(receiverId)
  //       .where('chatId', isEqualTo: chatId)
  //       .get()
  //       .then((QuerySnapshot value) {
  //     if (value.size == 0) {
  //       FirebaseFirestore.instance
  //           .collection("lastMessages")
  //           .doc(receiverId)
  //           .collection(receiverId)
  //           .doc("${Timestamp.now().millisecondsSinceEpoch}")
  //           .set({
  //         'chatId': chatId,
  //         'messageFrom': FirebaseAuth.instance.currentUser!.displayName,
  //         'messageTo': receiverUsername,
  //         'messageSenderId': senderId,
  //         'messageReceiverId': receiverId,
  //         'msgTime': msgTime,
  //         'msgType': msgType,
  //         'message': message,
  //       });
  //     } else {
  //       FirebaseFirestore.instance
  //           .collection("lastMessages")
  //           .doc(receiverId)
  //           .collection(receiverId)
  //           .doc(value.docs[0].id)
  //           .update({
  //         'messageFrom': FirebaseAuth.instance.currentUser!.displayName,
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
/////////////////////////////
  // get all last messages
  // Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
  //     BuildContext context, String myId) {
  //   return FirebaseFirestore.instance
  //       .collection('lastMessages')
  //       .doc(myId)
  //       .collection(myId)
  //       .orderBy("msgTime", descending: true)
  //       .snapshots();
  // }
/////////////////////////////

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

  String getChatId() {
    if (currentUserId.hashCode <= peerUserData!.uid.hashCode) {
      return "$currentUserId - ${peerUserData!.uid}";
    } else {
      return "${peerUserData!.uid} - $currentUserId";
    }
  }

  String getLastMessageChatId(String? peerUserId) {
    if (currentUserId.hashCode <= peerUserId.hashCode) {
      return "$currentUserId - $peerUserId";
    } else {
      return "$peerUserId - $currentUserId";
    }
  }
}
