// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print, duplicate_ignore

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/componants/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';

class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
// document id
List<String> docLists = [];
List<String> todoActiveIDs = [];
List<String> checklistsdocIDs = [];
List<CleanCalendarEvent> myListString = [];
Map<DateTime, List<CleanCalendarEvent>> events = {};
AppController controller = Get.put(AppController());
// final _auth = FirebaseAuth.instance.currentUser;

// get checklistsIDs
Future loadData(DateTime selectdate) async {
  events = {};
  myListString = [];
  await AppService()
      .CheckTodoResultModel(0, DateFormat('yyyyMMdd').format(selectdate));
  if (controller.checktodoresultModels.last.result != 0) {
    for (var i = 0;
        i < controller.checktodoresultModels.last.resultcheckinid.length;
        i++) {
      await AppService().readTodoResultModel(
          controller.checktodoresultModels.last.resultcheckinid[i],
          DateFormat('yyyyMMdd').format(selectdate));
      DateTime timestart =
          (controller.todoresultModels[i].timestampIn).toDate();
      DateTime timeend = (controller.todoresultModels[i].timestampOut)!.toDate();

      myListString.add(CleanCalendarEvent(
          '${controller.factoryModels[i].title} ${controller.factoryModels[i].subtitle}',
          startTime: DateTime(timestart.year, timestart.month, timestart.day,
              timestart.hour, timestart.microsecond),
          endTime: DateTime(timeend.year, timeend.month, timeend.day,
              timeend.hour, timeend.microsecond),
          description: '$docLists',
          color: kPrimaryColor));

      //create list event waiting to insert
      events[DateTime(timestart.year, timestart.month, timestart.day)] =
          myListString;

      
    }
    buildContainerbodyHello();
  }
}

class _CalendarAppState extends State<CalendarApp> {
  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    // loadData(DateTime(
    //     DateTime.now().year, DateTime.now().month, DateTime.now().day));
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: kPrimaryColor,
      //   title: const Text(
      //     "History",
      //     style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         fontSize: 18,
      //         color: Color.fromARGB(255, 255, 255, 255)),
      //   ),
      // ),
      body: SafeArea(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/main_top.png",
                      width: 120,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset("assets/images/login_bottom.png",
                        width: 120),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child:
                        Image.asset("assets/images/main_bottom.png", width: 50),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _handleNewDate(date) {
  loadData(date);
  //ignore: avoid_print
  print('Date selected: $date');
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContainerbodyHello(),
    );
  }
}

Widget buildContainerbodyHello() {
  return InkWell(
    child: Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Calendar(
        startOnMonday: true,
        events: events,
        isExpandable: true,
        onDateSelected: (date) => loadData(date),
        eventDoneColor: Colors.green,
        selectedColor: kTabsColor,
        todayColor: Colors.red,
        eventColor: Colors.red,
        locale: 'en_US',
        todayButtonText: ' ',
        isExpanded: false,
        expandableDateFormat: 'EEEE, dd. MMMM yyyy',
        dayOfWeekStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14),
        eventListBuilder: (BuildContext context, List<CleanCalendarEvent> events) {
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int index) {
                final CleanCalendarEvent event = events[index];
                final String start =
                    DateFormat('HH:mm').format(event.startTime).toString();
                final String end =
                    DateFormat('HH:mm').format(event.endTime).toString();
                return ListTile(
                  contentPadding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 2.0, bottom: 2.0),
                  leading: Container(
                    width: 10.0,
                    color: event.color,
                  ),
                  title: Text(event.summary),
                  // subtitle: event.description.isNotEmpty
                  //     ? Text(event.description)
                  //     : null,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(start), Text(end)],
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 300,
                          color: kTabsColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 250,
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(event.summary,
                                                style: const TextStyle(
                                                    fontSize: kDefaultFont,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        const Divider(),
                                        const Text('รายละเอียด: ',
                                            style: TextStyle(
                                                fontSize: kDefaultFont,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          children: [
                                            Text(event.description,
                                                style: const TextStyle(
                                                  fontSize: kDefaultFont,
                                                )), //kDefaultFont
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              itemCount: events.length,
            ),
          );
          // return const Text("!");
        },
      ),
    ),
  );
}
