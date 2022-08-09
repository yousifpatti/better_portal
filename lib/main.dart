import 'package:better_portal/screens/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ical/serializer.dart';
import './screens/custom_agenda_page.dart';
import 'backend.dart';
import './screens/mfa_page.dart';
import './screens/login_page.dart';
import './screens/export_page.dart';


void main() => runApp(AgendaViewCustomization());

class AgendaViewCustomization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M3 Portal',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => login_page() //about_page() //CustomAgenda(js: getData3()) ,
        // '/details': (context) => CustomAgenda(),
        // '/mfa': (context) => mfa_page(),
      },
    );
  }
}
