import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divyang_sir_app/model/userModel.dart';
import 'package:flutter/material.dart';

class OtherFilePage extends StatefulWidget {
  final uid;
  const OtherFilePage({super.key, this.uid});

  @override
  State<OtherFilePage> createState() => _OtherFilePageState();
}

class _OtherFilePageState extends State<OtherFilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('media')
                .doc(widget.uid)
                .collection('others')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: const CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return const Center(child: Text("No data found"));
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      FileModel _fileModel =
                          FileModel.fromJson(snapshot.data.docs[index]);

                      return Image.network(
                        _fileModel.fileUrl,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                );
              }
            }),
      ],
    );
  }
}
