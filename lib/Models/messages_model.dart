import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  String? chatId;
  String? senderId;
  String? receiverId;
  Timestamp? msgTime;
  String? msgType;
  String? message;
  dynamic fileName;

  MessagesModel({
    this.chatId,
    this.senderId,
    this.receiverId,
    this.msgTime,
    this.msgType,
    this.message,
    this.fileName,
  });

  MessagesModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'] ?? '';
    senderId = json['senderId'] ?? '';
    receiverId = json['receiverId'] ?? '';
    msgTime = json['msgTime'];
    msgType = json['msgType'] ?? '';
    message = json['message'] ?? '';
    fileName = json['fileName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['msgTime'] = msgTime;
    data['msgType'] = msgType;
    data['message'] = message;
    data['fileName'] = fileName;
    return data;
  }
}
