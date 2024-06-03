import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divyang_sir_app/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DocsPage extends StatefulWidget {
  final uid;
  const DocsPage({super.key, this.uid});

  @override
  State<DocsPage> createState() => _DocsPageState();
}

class _DocsPageState extends State<DocsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(stream: FirebaseFirestore.instance
                    .collection('media').doc(widget.uid).collection('docs')
                    
                    // .where('uid',isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return const Center(child: Text("No data found"));
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                          
                      FileModel _fileModel =
                                      FileModel.fromJson(snapshot.data.docs[index]);
                    
                      // return Image.network(_fileModel.fileUrl);
                      return GestureDetector(
                        onTap: (){
                          launch(_fileModel.fileUrl);
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/images/doc_icon.png',height: 90,),
                            Text(_fileModel.fileName,style: const TextStyle(overflow: TextOverflow.ellipsis),)
                          ],
                        ),
                      );
                    },
                  ),
                );
              }}),
      ],
    );
        
              
  }}
  