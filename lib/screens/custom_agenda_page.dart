import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CustomAgenda extends StatefulWidget {
  final Map js;

  const CustomAgenda({Key? key, required this.js}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ScheduleExample();
}

class ScheduleExample extends State<CustomAgenda> {
  List<Appointment> _appointmentDetails = <Appointment>[];

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
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
                title: const Text('Export to Calendar'),
                onTap: () {

                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  // Take me to the about page or whatever
                },
              ),
            ]),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: getCalendarDataSource(),
                onTap: calendarTapped,
                showWeekNumber: true,
                showDatePickerButton: true,
                showNavigationArrow: true,
                firstDayOfWeek: 1,
                allowedViews: [CalendarView.month, CalendarView.week],
              ),
            ),
            Expanded(
                child: Container(
                    color: Colors.black12,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(2),
                      itemCount: _appointmentDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            height: 60,
                            color: _appointmentDetails[index].color,
                            child: ListTile(
                              leading: Column(
                                children: <Widget>[
                                  Text(
                                    _appointmentDetails[index].isAllDay
                                        ? 'Shift'
                                        : '${DateFormat('hh:mm a').format(_appointmentDetails[index].startTime)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.7),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                  child: Icon(
                                Icons.people,
                                size: 30,
                                color: Colors.white,
                              )),
                              title: Container(
                                  child: Text(
                                      '${_appointmentDetails[index].subject}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.white))),
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 5,
                      ),
                    )))
          ],
        ),
      ),
    ));
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _appointmentDetails =
            calendarTapDetails.appointments!.cast<Appointment>();
      });
    }
  }

  int getMonthNumber(String mName) {
    Map month = {
      'Janauary': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12
    };
    return month[mName];
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    // Map<String, Map<String, String>> js = getData();

        widget.js.forEach((key, v1) {
          // for each month
          var date = key.split(' ');
          var month = date[0];
          var year = date[1];
          v1.toList().forEach((item) {
            var key2 = item['day'];
            var v2 = item['status'];
            if (!v2.contains('NOT ROSTERED')) {
              appointments.add(Appointment(
                  startTime: DateTime.utc(int.parse(year), getMonthNumber(month), key2),
                  endTime: DateTime.utc(int.parse(year), getMonthNumber(month), key2),
                  subject: v2,
                  color: Colors.lightGreen,
                  isAllDay: true));
            }
          });
        });


    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
