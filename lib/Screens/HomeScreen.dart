import 'dart:convert';
import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:event_calender/Colors/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late CalendarController _controller;
  late Map<DateTime, List<dynamic>> _titleEvents;
  late Map<DateTime, List<dynamic>> _noteEvents;
  late List<dynamic> _selectedEvents;

  late TextEditingController _titleEventController;
  late TextEditingController _dateEventController;
  late TextEditingController _noteEventController;
  late TextEditingController _StartTimeEventController;
  late TextEditingController _endTimeEventController;

  DateTime _StartTime = DateTime.now();
  DateTime _endTime = DateTime.now();

  final GlobalKey<FormState> _addEvents = GlobalKey<FormState>();

  late SharedPreferences sharedPreference;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _titleEventController = TextEditingController();
    _dateEventController = TextEditingController();
    _noteEventController = TextEditingController();
    _StartTimeEventController = TextEditingController();
    _endTimeEventController = TextEditingController();

    _titleEvents = {};
    _noteEvents = {};
    _selectedEvents = [];
    prefsData();
    prefsNoteData();
  }

  prefsData() async {
    sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      _titleEvents = Map<DateTime, List<dynamic>>.from(decodeMap(
          json.decode(sharedPreference.getString("event_title") ?? "{}")));
      //  json.decode(sharedPreference.getString(" event_note") ?? "{}")))
    });
  }

  prefsNoteData() async {
    sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      _noteEvents = Map<DateTime, List<dynamic>>.from(decodeMap(
          // json.decode(sharedPreference.getString("event_title") ?? "{}")));
          json.decode(sharedPreference.getString(" event_note") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgoundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  side: BorderSide(color: Colors.black26),
                ),
                margin: const EdgeInsets.all(8.0),
                elevation: 1.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.asset('images/Logo.PNG'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Event Calender",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Hi, welcome to xiteb Event Calender",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: secondaryColor,
                            height: 1,
                            width: 200,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(color: Colors.black26),
              ),
              margin: const EdgeInsets.all(8.0),
              elevation: 5.0,
              child: TableCalendar(
                locale: 'en_US',
                headerVisible: true,
                events: _titleEvents,
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                    weekendStyle: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                    canEventMarkersOverflow: true,
                    todayColor: Color.fromARGB(255, 0, 255, 26),
                    selectedColor: Colors.blue,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 205, 38, 38))),
                headerStyle: HeaderStyle(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 243, 247, 245),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  titleTextStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 255, 21),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  formatButtonShowsNext: true,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: (date, events, holidays) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 67, 195, 71),
                          borderRadius: BorderRadius.circular(100.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                calendarController: _controller,
              ),
            ),
            ..._selectedEvents.map((event) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      log(sharedPreference.getString('event_note'));
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width / 10,
                              height: MediaQuery.of(context).size.height / 15,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(10),
                                      right: Radius.circular(0)))),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              event,
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(color: Colors.black, width: 2),
          ),
          backgroundColor: Color.fromARGB(255, 67, 195, 71),
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                isScrollControlled: false,
                context: context,
                builder: (buider) {
                  log(_controller.selectedDay.toString());

                  return _showBottomSheet();
                });
          }

          // _showAddDialog,
          ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: primaryColor,
        items: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.menu, size: 25),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.home, size: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.more_horiz_sharp, size: 25),
          ),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }

// ------------  Add Event Section ---------------------
  Widget _showBottomSheet() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
                color: primaryColor,
              ),
              height: 50,
              width: 600,
              // color: Colors.blue,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "",
                    ),
                    Text(
                      "Add new events",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Container(
                child: Form(
                  key: _addEvents,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.black45,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  _controller.selectedDay.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: TextFormField(
                          controller: _titleEventController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Birth Day",
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Colors.black26),
                              labelText: "Title",
                              labelStyle: TextStyle(
                                  fontSize: 13, color: secondaryColor),
                              icon: Icon(Icons.edit)),
                          // maxLength: 10,

                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 5),
                        child: TextFormField(
                          controller: _noteEventController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "sample note",
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Colors.black26),
                              labelText: "Note",
                              labelStyle: TextStyle(
                                  fontSize: 13, color: secondaryColor),
                              icon: Icon(Icons.edit)),
                          // maxLength: 10,

                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(5, 1, 5, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 5),
                                child: Text("Strt time"),
                              ),
                              Container(height: 100, child: startTime()),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(5, 1, 5, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 5),
                                child: Text("End time"),
                              ),
                              Container(height: 100, child: startTime()),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            FlatButton(
              color: primaryColor,
              onPressed: () {
                if (_titleEventController.text.isEmpty) return;
                setState(() {
                  if (_titleEvents[_controller.selectedDay] != null) {
                    _titleEvents[_controller.selectedDay]
                        ?.add(_titleEventController.text);

                    _noteEvents[_controller.selectedDay]
                        ?.add(_noteEventController.text);
                  } else {
                    _titleEvents[_controller.selectedDay] = [
                      _titleEventController.text
                    ];

                    _noteEvents[_controller.selectedDay] = [
                      _noteEventController.text
                    ];
                  }
                  sharedPreference.setString(
                      "event_title", json.encode(encodeMap(_titleEvents)));
                  sharedPreference.setString(
                      "event_note", json.encode(encodeMap(_noteEvents)));
                  _titleEventController.clear();
                  _noteEventController.clear();
                  Navigator.pop(context);
                });
              },
              child: Text(
                "Save",
                style: TextStyle(
                    color: secondaryColor, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget startTime() {
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
      highlightedTextStyle: TextStyle(fontSize: 18, color: Colors.black),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          _StartTime = time;
          _StartTimeEventController.text = _StartTime.toString();
          log(_StartTime.toString());
        });
      },
    );
  }

  Widget endTime() {
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
      highlightedTextStyle: TextStyle(fontSize: 18, color: Colors.black),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          _endTime = time;
          _endTimeEventController.text = _endTime.toString();
          log(_endTime.toString());
        });
      },
    );
  }
}
