class Users {
  String? uid;
  String? name;
  int? phoneNumber;
  String? email;
  String? password;

  Users({this.uid, this.name, this.phoneNumber, this.email, this.password});

  Users.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
