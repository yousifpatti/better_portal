import 'package:better_portal/screens/mfa_page.dart';
import 'package:flutter/material.dart';
import 'package:ical/serializer.dart';
import '../backend.dart';
import 'dart:convert';
import 'dart:html' as html;

import 'about_page.dart';

class export_page extends StatefulWidget {
  final Map<String, ICalendar> calendars;
  const export_page({Key? key, required this.calendars}) : super(key: key);

  @override
  State<export_page> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<export_page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdownValue = "Select";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Export to ICal')),
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
                ListTile(
                  title: const Text('About'),
                  onTap: () {
                    // Take me to the about page or whatever
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => about_page()));
                  },
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
                      'Export',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Choose a month',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton<String>(
                      value: dropdownValue == "Select"
                          ? widget.calendars.keys.first
                          : dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: widget.calendars.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                Container(
                  height: 25,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Add to Calendar'),
                      onPressed: () {
                        if (dropdownValue == "Select") {
                          dropdownValue = widget.calendars.keys.first;
                        }
                        final content = base64Encode(utf8.encode(
                            widget.calendars[dropdownValue]!.serialize()));
                        final anchor = html.AnchorElement(
                            href:
                                "data:application/octet-stream;charset=utf-16le;base64,$content")
                          ..setAttribute("download", "roster.ics")
                          ..click();
                      },
                    )),
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
