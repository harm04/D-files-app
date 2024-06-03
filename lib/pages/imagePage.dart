import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divyang_sir_app/model/userModel.dart';
import 'package:divyang_sir_app/pages/image_view_page.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  final uid;
  final firstName;
  final lastName;
  const ImagePage({super.key, this.uid, this.firstName, this.lastName});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('media')
                .doc(widget.uid)
                .collection('images')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return Center(child: Text("No data found"));
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      FileModel _fileModel =
                          FileModel.fromJson(snapshot.data.docs[index]);

                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ImageViewPage(fileUrl: _fileModel.fileUrl,date: _fileModel.fileDate,documentType: _fileModel.documentType,fileName: _fileModel.fileName,fileSize: _fileModel.fileSize,fileType: _fileModel.fileType,firstName: widget.firstName,lastName: widget.lastName,);
                            }));
                          },
                          child: Image.network(
                            _fileModel.fileUrl,
                            fit: BoxFit.cover,
                          ));
                    },
                  ),
                );
              }
            }),
      ],
    );
  }
}
