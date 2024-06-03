import 'package:divyang_sir_app/pages/addMediaPage.dart';
import 'package:divyang_sir_app/pages/docsPage.dart';
import 'package:divyang_sir_app/pages/imagePage.dart';
import 'package:divyang_sir_app/pages/otherFilePage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopNavigationBar extends StatefulWidget {
  final uid;
  final firstName;
  final lastName;
  final email;
  //   final documentType;
  // final fileUrl;

  const TopNavigationBar({
    super.key,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    // required this.documentType,
    // required this.fileUrl,
  });

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 0, 7, 36),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 0, 7, 36),
              bottom: const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.image),
                ),
                Tab(
                  icon: Icon(Icons.file_copy),
                ),
                Tab(
                  icon: Icon(Icons.file_present_rounded),
                ),
                Tab(
                  icon: Icon(Icons.add),
                )
              ]),
              title: Text('${widget.firstName} ${widget.lastName}'),
            ),
            body: TabBarView(children: [
              ImagePage(uid: widget.uid,firstName: widget.firstName,lastName:widget.lastName),
              DocsPage(uid: widget.uid),
              OtherFilePage(uid: widget.uid),
             AddMediaPage(uid:widget.uid)
            ])));
  }
}
