// ignore_for_file: avoid_print, must_be_immutable
// import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/states/calendar_page.dart';
import 'package:checkinapp/states/home_page.dart';
import 'package:checkinapp/states/listcheckin_page.dart';
import 'package:checkinapp/states/setting_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WidgetBarItem extends StatefulWidget {
  final int currentPage;
  final String roleUser;
  const WidgetBarItem({
    Key? key,
    required this.currentPage,
    required this.roleUser,
  }) : super(key: key);

  @override
  State<WidgetBarItem> createState() => _WidgetBarItemState();
}

class _WidgetBarItemState extends State<WidgetBarItem> {
  
  AppController controller = Get.put(AppController());
  int _selectedIndex = 0;
  bool isAdmin = false;

  List<Widget> nonAdminWidgets(_WidgetBarItemState parent) {
    return <Widget>[
      const Home(), //const HomePage(),
      const Listcheckin(),//const CheckInMap(),
      const CalendarApp(),
    ];
  }

  List<Widget> adminWidgets(_WidgetBarItemState parent) {
    return <Widget>[
      const Home(), //const HomePage(),
      const Listcheckin(),
      // const CheckInMap(),
      const CalendarApp(),
      const SettingApp(),
    ];
  }

  List<BottomNavigationBarItem> nonAdminNavBars = const [
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.house),
      label: 'หน้าหลัก',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.listCheck),
      label: 'จุดเช็คอิน',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(FontAwesomeIcons.locationArrow),
    //   label: 'Map',
    // ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.clockRotateLeft),
      label: 'ประวัติ',
    ),
  ];

  List<BottomNavigationBarItem> adminNavBars = const [
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.house),
      label: 'หน้าหลัก',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.listCheck),
      label: 'จุดเช็คอิน',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(FontAwesomeIcons.locationArrow),
    //   label: 'Map',
    // ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.clockRotateLeft),
      label: 'ประวัติ',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.gear),
      label: 'ตั้งค่า',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(FontAwesomeIcons.gear),
    //   label: 'Home2',
    // ),
  ];

  void _onItemTapped(int index) {
    // if (widget.currentPage > 0) {
    //   setState(() {
    //     _selectedIndex = widget.currentPage;
    //   });
    // } else {
    setState(() {
      _selectedIndex = index;
    });
    // }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentPage;
    if (widget.roleUser == 'admin') {
      isAdmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Login Role ==> ${widget.roleUser}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: isAdmin
          ? adminWidgets(this)[_selectedIndex]
          : nonAdminWidgets(this)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white, //Colors.orangeAccent,
        selectedItemColor: kPrimaryColor, //Colors.white,
        unselectedItemColor: kselectedItemColor,
        onTap: _onItemTapped,
        items: isAdmin ? adminNavBars : nonAdminNavBars,
      ),
    );
  }
}
