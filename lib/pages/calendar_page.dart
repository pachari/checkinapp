// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print, duplicate_ignore, use_build_context_synchronously
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/componants/responsive.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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

// final _auth = FirebaseAuth.instance.currentUser;
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

bool _searchBoolean = false;
List<int> _searchIndexList = [];

List<String> _ListUser = [];
String? _selectValuid = "";
String? _selectValname = "";
String? _selectValrole = "";
String? checkselectValuid = "";

DateTime _selectDate = DateTime.now();
bool _searchBooleanmonth = false;

void loaddata() async {
  if (controller.userlistModels.isEmpty) {
    await AppService().readUserListModel();
    for (var i = 0; i < controller.userlistModels.length; i++) {
      _ListUser.add(controller.userlistModels[i].name.toString().toLowerCase());
    }
  }
}

void setdataEvent(DateTime date) async {
  if (controller.calendaralleventModels.isNotEmpty &&
      _selectValuid == checkselectValuid) {
    var checkmonth = DateFormat('yyyyMM').format(date);
    _searchBooleanmonth = false;
    for (var i = controller.calendaralleventModels.last.datamonth.length - 1;
        i >= 0;
        i--) {
      if (controller.calendaralleventModels.last.datamonth[i] == checkmonth) {
        _searchBooleanmonth = true;
      }
    }
    // int a = AppService().daysBetween(DateTime.now(), date);
    // if (_selectValuid != _auth!.uid && _selectValuid != checkselectValuid ) {

    // }
    if (_searchBooleanmonth == false) {
      //_checkdatemonth != a || _checkselectValuid != _selectValuid
      //&& _selectValuid != _auth!.uid
      // _checkdatemonth = a;
      controller.calendaralleventModels.clear();
      events.clear();
      checkselectValuid = _selectValuid;

      await AppService().readCalendarallEventModel2(_selectValuid!, date);
      buildContainerbodyHello();
    }
  } else {
    controller.calendaralleventModels.clear();
    events.clear();
    checkselectValuid = _selectValuid;
    await AppService().readCalendarallEventModel2(_selectValuid!, date);
    buildContainerbodyHello();
  }
}

class _CalendarAppState extends State<CalendarApp> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // loadDataallEvent(); //Before
    // loadDataallEvent2(); //After
    _selectValuid = controller.userModels.last.uid;
    _selectValname = controller.userModels.last.name;
    _selectValrole = controller.userModels.last.role;
    checkselectValuid = controller.userModels.last.uid;
    loaddata();
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < _ListUser.length; i++) {
            if (_ListUser[i].contains(s.toLowerCase())) {
              _searchIndexList.add(i);
            }
          }
        });
      },
      autofocus: true,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold
          // fontSize: 20,
          ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Color.fromARGB(153, 58, 56, 56),
          // fontSize: 20,
        ),
      ),
    );
  }

  Widget _searchListView() {
    return ListView.builder(
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          return Card(
              child: ListTile(
            title: Text(_ListUser[index]),
            onTap: () async {
              setState(() {
                _selectValuid = controller.userlistModels[index].uid;
                _selectValname = controller.userlistModels[index].name;
                _searchBoolean = false;
              });
              setdataEvent(_selectDate);
            },
          ));
        });
  }

  Widget _defaultListView() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: SafeArea(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: !_searchBoolean
              ? Text(
                  "ประวัติ $_selectValname",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 255, 255)),
                )
              : _searchTextField(),
          actions: _selectValrole != 'admin' || _selectValrole == ''
              ? [
                  // IconButton(
                  //     icon: const Icon(
                  //       Icons.clear,
                  //       color: kPrimaryColor,
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         _searchBoolean = false;
                  //       });
                  //     })
                ]
              : (!_searchBoolean
                  ? [
                      IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _searchBoolean = true;
                              _searchIndexList = [];
                            });
                          })
                    ]
                  : [
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchBoolean = false;
                            });
                          })
                    ]),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     _refreshIndicatorKey.currentState?.show();
        //   },
        //   icon: const Icon(Icons.refresh),
        //   label: const Text('refresh'),
        //   backgroundColor:kPrimaryColor
        // ),
        body: !_searchBoolean ? _defaultListView() : _searchListView());
  }
}

void _handleNewDate(date) async {
  //ignore: avoid_print
  print('Date selected: $date');
  setdataEvent(date);
  _selectDate = date;
}

Future loadDataallEvent2() async {
  // await Future.delayed(const Duration(milliseconds: 0));
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
  int colorsNo = 0;
  List<String> strArry = [];
  // find Result finishtodosid //move call to main.dart
  //วน loop ตามวัน
  if (controller.calendaralleventModels.isNotEmpty) {
    for (var i = 0;
        i < controller.calendaralleventModels.last.dataDate.length;
        i++) {
      myListString = [];
      colorsNo = 0;
      //วน loop รายการที่มีในวันนั้น
      for (var c = 0;
          c < controller.calendaralleventModels.last.finishtodosid.length;
          c++) {
        strArry =
            controller.calendaralleventModels.last.finishtodosid[c].split('-');
        if (controller.calendaralleventModels.last.dataDate[i] == strArry[0]) {
          //Read data finishtodo type boolean to set event calendar
          if (strArry[1].isNotEmpty && _selectValuid != null) {
            //find data finishtodo on firebase
            await AppService().readTodoResultModel(_selectValuid!, strArry[1],
                controller.calendaralleventModels.last.dataDate[i]);
            //loop read data finishtodo result true
            if (controller.todoresultModels.isNotEmpty) {
              for (var r = 0;
                  r < controller.todoresultModels.last.finishtodo.length;
                  r++) {
                if (controller.todoresultModels.last.finishtodo[r] == true) {
                  todoActiveIDs.add(controller.userModels.last.todo[r]);
                }
              }
              for (var v = 0; v < controller.factoryAllModels.length; v++) {
                if (controller.todoresultModels.last.checkinid ==
                    controller.factoryAllModels[v].id) {
                  titles =
                      '${controller.factoryAllModels[v].title} ${controller.factoryAllModels[v].subtitle}';
                  todolistid = controller.todoresultModels.last.checkinid;
                }
              }
              //ช้อมูลเวลาเข้า-ออก
              DateTime timestart =
                  (controller.todoresultModels.last.timestampIn).toDate();
              DateTime timeend =
                  (controller.todoresultModels.last.timestampOut)!.toDate();
              //ชุดข้อมูลตามวัน
              DateTime timeevent = DateTime.parse(
                  controller.calendaralleventModels.last.dataDate[i]);
              //set detail event calendar
              myListString.add(CleanCalendarEvent(titles,
                  startTime: DateTime(timestart.year, timestart.month,
                      timestart.day, timestart.hour, timestart.minute),
                  endTime: DateTime(timeend.year, timeend.month, timeend.day,
                      timeend.hour, timeend.minute),
                  description: '$todoActiveIDs',
                  todoid: todolistid,
                  image: controller.todoresultModels.last.image,
                  color: colors[colorsNo++],
                  todoresultid: controller.todoresultModels.last.todoresultid));
              //set event calendar
              events[DateTime(timeevent.year, timeevent.month, timeevent.day)] =
                  myListString;
              todoActiveIDs.clear();
            }
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
  }
}

class MobileCalendar extends StatefulWidget {
  const MobileCalendar({Key? key}) : super(key: key);

  @override
  State<MobileCalendar> createState() => _MobileCalendarState();
}

class _MobileCalendarState extends State<MobileCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: kBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: buildContainerbodyHello()),
      ),
    );
  }
}

Widget buildContainerbodyHello() {
  return FutureBuilder(
    future: loadDataallEvent2(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        color: kBackgroundColor,
        child: Calendar(
          startOnMonday: false,
          events: events,
          isExpandable: true,
          // onMonthChanged: (value) {
          //   setdataEvent(value);
          //   buildContainerbodyHello();
          // }, //(value) => setdataEvent(value),
          onDateSelected: (date) => _handleNewDate(date),
          eventDoneColor: Colors.green,
          selectedColor: kPrimaryColor.withOpacity(0.4),
          todayColor: Colors.red,
          eventColor: Colors.red,
          locale: 'th_TH',
          todayButtonText: ' ',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          weekDays: const ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'],
          dayOfWeekStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: kDefaultFont),
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
                  // String end2 = '';
                  // if (event.todostatus == 1 ) {
                  //   end2 = '00:00';
                  // } else {
                  //   end2 = end;
                  // }
                  return Generatelist(
                      event: event,
                      start: start,
                      end: end,
                      starttime: starttime,
                      endtime: endtime,
                      todoid: event.todoid,
                      imageid: event.image,
                      imagedate: event.startTime,
                      todoresultid: event.todoresultid);
                },
                itemCount: events.length,
              ),
            );
            // return const Text("!");
          },
        ),
      );
    },
  );
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
    required this.imageid,
    required this.imagedate,
    required this.todoresultid,
  });

  final CleanCalendarEvent event;
  final String start;
  final String end;
  final String starttime;
  final String endtime;
  final int todoid;
  final String imageid;
  final DateTime imagedate;
  final String todoresultid;

  @override
  State<Generatelist> createState() => _GeneratelistState();
}

class _GeneratelistState extends State<Generatelist> {
  String fileupload = '';
  String fileuploadname = '';
  String fileuploadRemark = '';

  loadFile() async {
    fileupload = '';
    fileuploadname = '';
    fileuploadRemark = '';
    if (widget.imageid.isNotEmpty && widget.todoresultid.isNotEmpty) {
      // controller.fileuploadModels.clear();
      await AppService().readFileUpload(_selectValuid!, '${widget.todoid}',
          widget.imagedate, widget.imageid, widget.todoresultid);

      for (var i = 0; i < controller.fileuploadModels.length; i++) {
        // if (controller.fileuploadModels[i].todoid == widget.imageid) {
        // loadDatafileupload();
        if (controller.fileuploadModels.isNotEmpty) {
          setState(() {
            fileupload = controller.fileuploadModels.last.image;
            fileuploadname = controller.fileuploadModels.last.name;
            fileuploadRemark = controller.fileuploadModels.last.remark;
          });
        }
        // }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // loadFile();
    // loadDatafileupload(); //ใช้กรณี อยากให้เป็นการเข้าเยี่ยมครั้งเดียว
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
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.start,
            style: const TextStyle(fontSize: kDefaultFont),
          ),
          Text(
            widget.end,
            style: const TextStyle(fontSize: kDefaultFont),
          )
        ],
      ),
      onTap: () async {
        await loadFile();
        showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.amber.shade50, //kTabsColor.withOpacity(0.4)
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
                        const Text('วันที่ เวลาเข้า-ออก ',
                            style: TextStyle(
                                fontSize: kDefaultFont,
                                fontWeight: FontWeight.bold)),
                        Text('(${widget.starttime}) - (${widget.endtime})',
                            style: const TextStyle(fontSize: kDefaultFont)),
                        const Divider(),
                        const Text('รายละเอียด ',
                            style: TextStyle(
                                fontSize: kDefaultFont,
                                fontWeight: FontWeight.bold)),
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
                          child: fileuploadRemark.isNotEmpty
                              ? Text(fileuploadRemark,
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
                          child: fileupload.isNotEmpty
                              ? Image.network(
                                  fileupload,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  // height: 250,
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
