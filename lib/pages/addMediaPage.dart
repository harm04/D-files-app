//

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divyang_sir_app/pages/imagePage.dart';
import 'package:divyang_sir_app/utils/snackbar';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMediaPage extends StatefulWidget {
  final uid;
  const AddMediaPage({super.key, this.uid});

  @override
  State<AddMediaPage> createState() => _AddMediaPageState();
}

class _AddMediaPageState extends State<AddMediaPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController documentTypecontroller = TextEditingController();
  _AddMediaPageState() {
    selectedName = fileName[0];
  }

  PlatformFile? _selectedFile;
  String? _fileName;
  String? _fileType;
  String? _fileDate;
  int? _fileSize;
  bool isLoading = false;

  Future<void> pickFile() async {
    setState(() {
      isLoading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.any);

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _fileName = _selectedFile!.name;
          DateTime now = DateTime.now();
          _fileDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
          _fileType = _selectedFile!.extension ?? 'unknown';
          _fileSize = _selectedFile!.size;
          isLoading = false;
        });
      } else {
        showSnackbar('File picking canceled', context);
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackbar('Error picking file: $err', context);
    }
  }

  Future<String> uploadFile(String documentTypecontroller) async {
    String res = 'some error occurred';
    setState(() {
      isLoading = true;
    });
    if (_selectedFile == null) {
      setState(() {
        isLoading = false;
      });
      showSnackbar('No file selected', context);
    }

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('media/${widget.uid}/$_fileName');

      UploadTask uploadTask = ref.putFile(
        File(_selectedFile!.path!),
        SettableMetadata(
          contentType: _fileType,
        ),
      );

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      print('File uploaded successfully');
      print('File Name: $_fileName');
      print('File Type: $_fileType');
      print('File Size: $_fileSize bytes');
      print('Upload Date: $_fileDate');
      print('Download URL: $downloadURL');

      final docData = {
        'fileName': _fileName,
        'fileType': _fileType,
        'fileSize': _fileSize,
        'date': _fileDate,
        'fileUrl': downloadURL,
        'documentType': documentTypecontroller,
      };

      final userDoc = _firestore.collection("media").doc(widget.uid);

      if (_fileType == 'pdf' || _fileType == 'doc' || _fileType == 'docx') {
        await userDoc.collection('docs').doc(_fileName).set(docData);
      } else if (_fileType == 'jpg' ||
          _fileType == 'jpeg' ||
          _fileType == 'svg' ||
          _fileType == 'png') {
        await userDoc.collection('images').doc(_fileName).set(docData);
      } else {
        await userDoc.collection('others').doc(_fileName).set(docData);
      }
      setState(() {
        isLoading = false;
        res = 'success';
      });
      res = 'success';
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      res = err.toString();
    }
    return res;
  }

  final fileName = [
    "Select file name",
    "Aadhar card",
    "Voter id",
    "Driving license",
    "Passport",
    "Pan card",
    "Rashan card",
    "Other"
  ];
  String? selectedName = "";

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                selectedName == "Other"
                    ? TextFormField(
                        controller: documentTypecontroller,
                        decoration: const InputDecoration(
                            hintText: "Enter the type of document",
                            border: OutlineInputBorder()),
                      )
                    : DropdownButtonFormField(
                        decoration: const InputDecoration(
                            labelText: "File name",
                            border: OutlineInputBorder()),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                        ),
                        dropdownColor: const Color.fromARGB(255, 38, 44, 49),
                        value: selectedName,
                        items: fileName
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedName = val as String;
                            selectedName == "Other"
                                ? documentTypecontroller.text = ""
                                : documentTypecontroller.text = val;
                          });
                        },
                      ),
                const SizedBox(
                  height: 20,
                ),
                _selectedFile == null
                    ? const SizedBox()
                    : _fileType == "png" ||
                            _fileType == "jpg" ||
                            _fileType == "jpeg"
                        ? Column(
                            children: [
                              Image.file(File(_selectedFile!.path!),
                                  height: 200, width: 200),
                              Text(_fileName.toString()),
                              Text(
                                  'Size : ${(_fileSize! / (1024 * 1024)).toStringAsFixed(2)} MB')
                            ],
                          )
                        : const Icon(Icons.insert_drive_file, size: 100),
                GestureDetector(
                  onTap: () {
                    if (documentTypecontroller.text == "" ||
                        documentTypecontroller.text == "Select file name") {
                      showSnackbar('Please enter document type', context);
                    } else {
                      pickFile();
                    }
                  },
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_copy),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Select file",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _selectedFile != null
                    ? GestureDetector(
                        onTap: () async {
                          String res =
                              await uploadFile(documentTypecontroller.text);

                          if (res == 'success') {
                            setState(() {
                              isLoading = false;
                            });

                            showSnackbar('File uploaded successfully', context);
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            showSnackbar(res, context);
                          }
                        },
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: const Card(
                            color: Colors.blue,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Upload file",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          );
  }
}
