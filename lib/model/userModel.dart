


import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;

  String firstName;
  String lastName;
  String email;


  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
   
  });

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(
      uid: snapshot['uid'],
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      email:snapshot['email'],
  
    );
  }
}

class FileModel{
  String documentType;
   String fileUrl;
   String fileName;
   final fileDate;
   final fileSize;
   final fileType;

   FileModel({
    required this.documentType,
    required this.fileUrl,
    required this.fileName,
     required this.fileDate,
      required this.fileSize,
       required this.fileType,
   });

   factory FileModel.fromJson(DocumentSnapshot snapshot){
    return FileModel(documentType: snapshot['documentType'], fileUrl: snapshot['fileUrl'],fileName: snapshot['fileName'],fileDate: snapshot['date'],fileSize: snapshot['fileSize'],fileType: snapshot['fileSize'])  ;
   }
}