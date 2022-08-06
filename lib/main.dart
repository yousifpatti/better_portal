import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import './screens/custom_agenda_page.dart';
import 'backend.dart';
import './screens/mfa_page.dart';
import './screens/login_page.dart';


void main() => runApp(AgendaViewCustomization());

class AgendaViewCustomization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M3 Portal',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => login_page(),
        // '/details': (context) => CustomAgenda(),
        // '/mfa': (context) => mfa_page(),
      },
    );
  }
}
