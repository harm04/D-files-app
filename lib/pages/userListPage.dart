import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divyang_sir_app/model/userModel.dart';
import 'package:divyang_sir_app/pages/topNavigationBar.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 7, 36),
        title: Text(
          "Hello Divyang Sir!",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 7, 36),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          UserModel _userModel =
                              UserModel.fromJson(snapshot.data.docs[index]);

                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                .collection('media')
                .doc(_userModel.uid)
                .snapshots(),
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      '${_userModel.firstName} ${_userModel.lastName}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onTap: () {
                                    
                              
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            print('_userModel.documentType');
                                        return TopNavigationBar(
                                      email: _userModel.email,firstName: _userModel.firstName,lastName: _userModel.lastName,uid: _userModel.uid,
                                     
                                        );
                                      }));
                                      // print('_userModel.documentType');
                                    },
                                  ),
                                  Divider()
                                ],
                              );
                            }
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('No data found'),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
