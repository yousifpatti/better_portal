import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../backend.dart';
import 'custom_agenda_page.dart';

class mfa_page extends StatefulWidget {
  final String username;
  final String password;

  const mfa_page({Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  State<mfa_page> createState() => _mfa_pageState();
}

class _mfa_pageState extends State<mfa_page> {
  TextEditingController codeController = TextEditingController();
  bool isPressed = false;

  // String get username => _username;
  // String get password => _password;
  // String get code => this._code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('M3 Portal')),
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
                      'M3 Portal',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Enter SMS code',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onSubmitted: (value) => {FocusManager.instance.primaryFocus?.unfocus()},
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    controller: codeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Code',
                    ),
                  ),
                ),
                Container(
                  height: 25,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: isPressed
                          ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 25,
                      ): const Text('Verify'),
                      onPressed: () {
                        setState(() {
                          isPressed = true;
                        });
                        try {
                          MFA(widget.username, widget.password,
                              codeController.text)
                              .then((value) {
                            setState(() {
                              isPressed = false;
                            });
                            if (value == {'error': 'error parsing'}) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content:
                                  Text("Something went wrong")));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomAgenda(
                                            js: value,
                                          )));
                            }
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              content:
                              Text("Something went wrong")));
                        }

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
