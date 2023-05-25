import 'package:checkinapp/states/home.dart';
import 'package:checkinapp/states/states_calendar.dart';
import 'package:checkinapp/states/states_checkinmap.dart';
import 'package:checkinapp/states/states_setting.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:checkinapp/componants/constants.dart';

class WidgetBarItem extends StatefulWidget {
  final int currentPage;
  const WidgetBarItem({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  @override
  State<WidgetBarItem> createState() => _WidgetBarItemState();
}

class _WidgetBarItemState extends State<WidgetBarItem> {
  int _selectedIndex = 0;
  final List<Widget> _pageWidget = <Widget>[
    const HomePage(),
    const CheckInMap(),
    const CalendarApp(),
    const SettingApp(),
  ];

  final List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.house),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.locationArrow),
      label: 'Map',
    ),
    const BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.clockRotateLeft),
      label: 'History',
    ),
    const BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.gear),
      label: 'Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.currentPage == 9999) {
    //   _selectedIndex = 1;
    //   // widget.currentPage = 0;
    // }
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kselectedItemColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
