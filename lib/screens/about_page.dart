import 'package:better_portal/screens/mfa_page.dart';
import 'package:flutter/material.dart';
import 'package:ical/serializer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend.dart';
import 'dart:convert';
import 'dart:html' as html;

class about_page extends StatefulWidget {
  const about_page({Key? key}) : super(key: key);

  @override
  State<about_page> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<about_page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdownValue = "Select";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('About')),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Icon(Icons.all_inclusive_outlined),
                ),
              ]),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'About',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Author: Yousif Al-Patti\nVersion: 1.1',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    child: new Text("Learn more", style: TextStyle(color: Colors.blue),),
                    onTap: () => launchUrl(Uri.parse("https://yousifpatti.github.io/profile/#/")),
                  ),
                  height: 100,
                ),
                Container(
                  height: 25,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Back'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            )));
  }
}
