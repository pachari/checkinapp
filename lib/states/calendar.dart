// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print, duplicate_ignore, use_build_context_synchronously

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/componants/responsive.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
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

// document id
List<String> docLists = [];
List<String> todoActiveIDs = [];
List<String> checklistsdocIDs = [];
List<CleanCalendarEvent> myListString = [];
Map<DateTime, List<CleanCalendarEvent>> events = {};
AppController controller = Get.put(AppController());
String imageUrl = '';
String Name = '';
String Remark = '';

// // loadData on selectdate
// Future loadData(selectdate) async {
//   myListString = [];
//   await AppService().CheckTodoResultModel(0, selectdate);
// }

class _CalendarAppState extends State<CalendarApp> {
  @override
  void initState() {
    super.initState();
    // loadDataallEvent(); //Before
    // loadDataallEvent2(); //After
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "History",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SafeArea(
        child: Responsive(
          mobile: const MobileCalendar(),
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
  //ignore: avoid_print
  print('Date selected: $date');
}

Future loadDataallEvent2() async {
  // events.clear();
  myListString.clear();
  final colors = [
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.indigo,
    Colors.grey,
    Colors.pinkAccent,
    Colors.brown
  ];
  String titles = '';
  int todolistid = 0;
  // find Result finishtodosid //move call to main.dart
  // String uid = 'S97KxIE9C7YHwUnlnB5rQaXHHrd2';
  // await AppService().readCalendarallEventModel2(uid);
  for (var i = 0;
      i < controller.calendaralleventModels.last.dataDate.length;
      i++) {
    //Read data finishtodo type boolean to set event calendar
    await AppService().CheckTodoResultModel(
        0, controller.calendaralleventModels.last.dataDate[i]);
    myListString = [];
    for (var z = 0;
        z < controller.checktodoresultModels.last.resultcheckinid.length;
        z++) {
      if (controller.checktodoresultModels.last.resultcheckinid.isNotEmpty) {
        await AppService().readTodoResultModel(
            controller.checktodoresultModels.last.resultcheckinid[z],
            controller.calendaralleventModels.last.dataDate[i]);
        for (var r = 0;
            r < controller.todoresultModels.last.finishtodo.length;
            r++) {
          if (controller.todoresultModels.last.finishtodo[r] == true) {
            todoActiveIDs.add(controller.userModels.last.todo[r]);
          }
        }
        for (var v = 0; v < controller.factoryAllModels.length; v++) {
          if (controller.todoresultModels.last.checkinid == controller.factoryAllModels[v].id) {
            titles = '${controller.factoryAllModels[v].title} ${controller.factoryAllModels[v].subtitle}';
            todolistid = controller.todoresultModels.last.checkinid;
          }
        }
        //ช้อมูลเวลาเข้า-ออก
        DateTime timestart = (controller.todoresultModels.last.timestampIn).toDate();
        DateTime timeend =  (controller.todoresultModels.last.timestampOut)!.toDate();
        //ชุดข้อมูลตามวัน
        DateTime timeevent =  DateTime.parse(controller.calendaralleventModels.last.dataDate[i]);
        //set detail event calendar
        myListString.add(CleanCalendarEvent(
          titles,
          startTime: DateTime(timestart.year, timestart.month, timestart.day,timestart.hour, timestart.minute),
          endTime: DateTime(timeend.year, timeend.month, timeend.day,timeend.hour, timeend.minute),
          description: '$todoActiveIDs',
          todoid: todolistid,
          // image: controller.fileuploadModels.last.name,
          // remark: controller.fileuploadModels.last.remark,
          color: colors[z],
        ));
        //set event calendar
        events[DateTime(timeevent.year, timeevent.month, timeevent.day)] =
            myListString;

        todoActiveIDs.clear();
      } else {
        AppSnackBar(
                title: 'Load Data Failure',
                massage: 'Please Check Contect Admin')
            .errorSnackBar();
      }
    }
    controller.todoresultModels.clear();
  }
}

class MobileCalendar extends StatelessWidget {
  const MobileCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContainerbodyHello(),
    );
  }
}

Widget buildContainerbodyHello() {
  return InkWell(
      child: FutureBuilder(
    future: loadDataallEvent2(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Calendar(
          startOnMonday: false,
          events: events,
          isExpandable: true,
          onDateSelected: (date) => _handleNewDate(date),
          eventDoneColor: Colors.green,
          selectedColor: kPrimaryColor.withOpacity(0.4),
          todayColor: Colors.red,
          eventColor: Colors.red,
          locale: 'en_US',
          todayButtonText: ' ',
          isExpanded: false,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          dayOfWeekStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: kDefaultFont),
          eventListBuilder:
              (BuildContext context, List<CleanCalendarEvent> events) {
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0.0),
                itemBuilder: (BuildContext context, int index) {
                  final CleanCalendarEvent event = events[index];
                  final String start =
                      DateFormat('HH:mm').format(event.startTime).toString();
                  final String end =
                      DateFormat('HH:mm').format(event.endTime).toString();
                  final String starttime = DateFormat('d/M/y HH:mm')
                      .format(event.startTime)
                      .toString();
                  final String endtime = DateFormat('d/M/y HH:mm')
                      .format(event.endTime)
                      .toString();
                  final String imagedate =
                      DateFormat('yyyyMMdd').format(event.startTime).toString();

                  return Generatelist(
                    event: event,
                    start: start,
                    end: end,
                    starttime: starttime,
                    endtime: endtime,
                    todoid: event.todoid,
                    imagedate: imagedate,
                  );
                },
                itemCount: events.length,
              ),
            );
            // return const Text("!");
          },
        ),
      );
    },
  ));
}

class Generatelist extends StatefulWidget {
  const Generatelist({
    super.key,
    required this.event,
    required this.start,
    required this.end,
    required this.starttime,
    required this.endtime,
    required this.todoid,
    required this.imagedate,
  });

  final CleanCalendarEvent event;
  final String start;
  final String end;
  final String starttime;
  final String endtime;
  final int todoid;
  final String imagedate;

  @override
  State<Generatelist> createState() => _GeneratelistState();
}

class _GeneratelistState extends State<Generatelist> {
  // void loadDatafileupload() async {
  //   await AppService().readFileUpload('${widget.event.todoid}');
  //   if (controller.fileuploadModels.isNotEmpty) {
  //     imageUrl = controller.fileuploadModels.last.image;
  //     Name = controller.fileuploadModels.last.name;
  //     Remark = controller.fileuploadModels.last.remark;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // loadDatafileupload();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 5.0, right: 0.0, top: 3.0, bottom: 3.0),
      leading: Container(
        width: 15.0,
        color: widget.event.color,
      ),
      dense: true,
      title: Text(
        widget.event.summary,
        style: const TextStyle(fontSize: kDefaultFont),
      ),
      // subtitle: event.description.isNotEmpty
      //     ? Text(event.description)
      //     : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.start,
            style: const TextStyle(fontSize: kDefaultFont),
          ),
          Text(widget.end,
           style: const TextStyle(fontSize: kDefaultFont),)
        ],
      ),
      onTap: () async {
        await AppService()
            .readFileUpload('${widget.event.todoid}', widget.imagedate);
        showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.amber.shade50,//kTabsColor.withOpacity(0.4)
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.0,
                // color: kTabsColor.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('จุดเช็คอิน ',
                            style: TextStyle(
                                fontSize: kDefaultFont,
                                fontWeight: FontWeight.bold)),
                        Text(widget.event.summary,
                            style: const TextStyle(fontSize: kDefaultFont)),
                        const Divider(),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        const Text('วันที่ เวลาเข้า-ออก ',
                            style: TextStyle(
                                fontSize: kDefaultFont,
                                fontWeight: FontWeight.bold)),
                        Text('(${widget.starttime}) - (${widget.endtime})',
                            style: const TextStyle(fontSize: kDefaultFont)),
                        const Divider(),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        const Text('รายละเอียด ',
                            style: TextStyle(
                                fontSize: kDefaultFont,
                                fontWeight: FontWeight.bold)),
                        // const SizedBox(
                        //   height: 5,
                        // ),

                        Text(
                            widget.event.description
                                .replaceAll('[', '')
                                .replaceAll(']', ''),
                            style: const TextStyle(
                              fontSize: kDefaultFont,
                            )),
                        const Divider(),
                        const Text('หมายเหตุ ',
                            style: TextStyle(
                                fontSize: kDefaultFont,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          child: controller.fileuploadModels.isNotEmpty
                              ? Text(controller.fileuploadModels.last.name,
                                  style:
                                      const TextStyle(fontSize: kDefaultFont))
                              : const Text(
                                  "",
                                  style: TextStyle(fontSize: 14),
                                ),
                        ),
                        SizedBox(
                          child: controller.fileuploadModels.isNotEmpty
                              ? Text(controller.fileuploadModels.last.remark,
                                  style:
                                      const TextStyle(fontSize: kDefaultFont))
                              : const Text(
                                  "",
                                  style: TextStyle(fontSize: 14),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: controller.fileuploadModels.isNotEmpty
                              ? Image.network(
                                  controller.fileuploadModels.last.image,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                )
                              // ? IconButton(
                              //     icon: Image.network(
                              //       controller.fileuploadModels.last.image,
                              //       fit: BoxFit.cover,
                              //       // width: 50, //MediaQuery.of(context).size.width,
                              //       // height: 50,
                              //     ),
                              //     iconSize: 200,
                              //     onPressed: () {},
                              //   )
                              : const Text(
                                  " ", //No Image
                                  style: TextStyle(fontSize: 14),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
