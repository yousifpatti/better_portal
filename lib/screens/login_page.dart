import 'package:better_portal/screens/mfa_page.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../backend.dart';
import 'about_page.dart';
import 'package:hive/hive.dart';

class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<login_page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPressed = false;
  List<String> userInfo = [];

  // @override
  // void initState() {
  //   super.initState();
  //   getDataHive().then((value) => {
  //     setState(() {
  //     userInfo = value;
  //     }),
  //     });
  //   print(userInfo);
  //
  // }

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
                      'Sign in with R3 details',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onSubmitted: (value) => {FocusManager.instance.primaryFocus?.unfocus()},
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    onSubmitted: (value) => {FocusManager.instance.primaryFocus?.unfocus()},
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
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
                            )
                          : const Text('Login'),
                      onPressed: () {
                        // print(nameController.text);
                        // print(passwordController.text);
                        setState(() {
                          isPressed = true;
                        });
                        login(nameController.text, passwordController.text)
                            .then((value) => {
                                  setState(() {
                                    isPressed = false;
                                  }),
                                  if (value == true)
                                    {
                                      storeDataHive(nameController.text,
                                          passwordController.text),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => mfa_page(
                                                    username:
                                                        nameController.text,
                                                    password:
                                                        passwordController.text,
                                                  )))
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Something went wrong")))
                                    }
                                });
                      },
                    )),
                Row(
                  children: <Widget>[
                    const Text('Not affiliated with Bunnings'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Container(
                  height: 50,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: isPressed
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 25,
                            )
                          : const Text('Use Known Details'),
                      onPressed: () {
                        // print(nameController.text);
                        // print(passwordController.text);
                        setState(() {
                          isPressed = true;
                        });
                        getDataHive().then((storedDataPossibly) => {
                              if (storedDataPossibly.isEmpty)
                                {
                                  setState(() {
                                    isPressed = false;
                                  }),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("No Known Details")))
                                }
                              else
                                {
                                  login(storedDataPossibly[0],
                                          storedDataPossibly[1])
                                      .then((value) => {
                                            setState(() {
                                              isPressed = false;
                                            }),
                                            if (value == true)
                                              {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            mfa_page(
                                                              username:
                                                                  storedDataPossibly[
                                                                      0],
                                                              password:
                                                                  storedDataPossibly[
                                                                      1],
                                                            )))
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Something went wrong")))
                                              }
                                          })
                                }
                            });
                      },
                    )),
              ],
            )));
  }
}
