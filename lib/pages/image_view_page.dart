import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ImageViewPage extends StatefulWidget {
  final fileUrl;
  final fileName;
  final fileType;
  final fileSize;
  final documentType;
  final date;
  final firstName;
  final lastName;
  const ImageViewPage(
      {super.key,
      this.fileUrl,
      this.fileName,
      this.fileType,
      this.fileSize,
      this.documentType,
      
      this.date, this.firstName, this.lastName});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.firstName} ${widget.lastName}'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    onTap: () async {
                       Navigator.pop(context);
                      final url = Uri.parse(widget.fileUrl);
                      final response = await http.get(url);
                      final bytes = response.bodyBytes;
                      final temp = await getTemporaryDirectory();
                      final path = '${temp.path}/${widget.fileName}';
                      print(path);
                      File(path).writeAsBytes(bytes);
                      await Share.shareFiles([path],
                          text: '${widget.fileName}');
                    },
                    leading: const Icon(Icons.share),
                    title: const Text('Share'),
                  )),
                  PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    onTap: () async {
                     Navigator.pop(context);
                       showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding:  const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Center(child: Text(widget.documentType,style: const TextStyle(color: Colors.white,fontSize: 17),)),
                     const SizedBox(height: 15),
                     Text('File size : ${(widget.fileSize! / (1024 * 1024)).toStringAsFixed(2)} MB'),
                    
                    Text('Date : ${DateFormat.yMMMd()
                    .format(widget.date.toDate())}'),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          );
                    },
                    leading: const Icon(Icons.remove_red_eye),
                    title: const Text('View details'),
                  )),
            ],
            icon: const Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          widget.fileUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

//  Text(
                // DateFormat.yMMMd()
                //     .format(widget.snap['datePublished'].toDate()),

// //                     
//               ),



  // launch(file.url);