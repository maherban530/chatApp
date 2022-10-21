class Users {
  String? uid;
  String? name;
  String? phoneNumber;
  String? email;
  String? userPic;
  String? fcmToken;
  dynamic userStatus;

  Users(
      {this.uid,
      this.name,
      this.phoneNumber,
      this.email,
      this.userPic,
      this.fcmToken,
      this.userStatus});

  Users.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    email = json['email'] ?? '';
    userPic = json['userPic'] ?? '';
    fcmToken = json['fcmToken'] ?? '';
    userStatus = json['userStatus'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['userPic'] = userPic;
    data['fcmToken'] = fcmToken;
    data['userStatus'] = userStatus;
    return data;
  }
}

class UserIdModel {
  final String? userId;

  UserIdModel(this.userId);
}
