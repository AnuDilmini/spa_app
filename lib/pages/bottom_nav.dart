import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:violet_app/pages/home.dart';
import 'package:violet_app/pages/payment.dart';
import 'package:violet_app/pages/profile.dart';
import 'package:violet_app/pages/select_time_date.dart';
import 'package:violet_app/pages/service_find.dart';
import 'package:violet_app/pages/setting.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/palette.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';

import 'change_language.dart';
import 'change_password.dart';
import 'info_service.dart';
import 'location.dart';
import 'order_complete.dart';
import 'orders.dart';

class BottomNav extends StatefulWidget {
  int index;
  int subIndex;
  BottomNav({Key key, this.index,this.subIndex}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int _currentIndex = 0, subIndex , page;
  double height, width;
  String lanCode = "en";

  final List<Widget> _children = [
    ServiceFindPage(), //0
    Orders(),
    Profile(),
    InfoService(),
    Payment(),
    OrderComplete(),
    UpdateProfile(),
    Setting(),
    ChangeLang(),
    SelectTimeDate(),
    ChangePassword(),
    LocationPage(),// 11
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    subIndex = widget.subIndex;

    // print("_currentIndex $_currentIndex, subIndex $subIndex ");
    if(_currentIndex == 0){
        if(subIndex == 1){
          page = 3;
        }else if(subIndex == 2){
          page = 4;
        } else if(subIndex == 3) {
          page = 5;
        }else if(subIndex == 4){
          page = 9;
        }else if(subIndex == 5){
          page = 11;
        }else{
            page = _currentIndex;
        }
    }
    else if(_currentIndex == 1 ){
      page = _currentIndex;
    }else if(_currentIndex == 2 ){
        if(subIndex ==1){
          page = 6;
        }else if(subIndex == 2) {
          page = 7;
        }else if(subIndex == 3){
          page = 8;
        }else if(subIndex == 4){
          page = 10;
        }else{
          page = _currentIndex;
        }
    }else{
       page = _currentIndex;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;

    lanCode = context.locale.languageCode;

    return Scaffold(
      body: SizedBox.expand(
        child: _children[page],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Palette.pinkBox,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image(
              image:AssetImage('assets/white_art.png'),
              height:(height/896) * 30,
              width: (height/896) * 30,
            ),
            title: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(LocaleKeys.violet ,
                style: TextStyle(
                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                    color: Palette.whiteText,
                    fontSize: (height/896) * 15,
                ),
              ).tr(),
            ),
            // label: 'Violate',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: (height/896) *25,
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(LocaleKeys.orders,
                style: TextStyle(
                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                    color: Palette.whiteText,
                    fontSize: (height/896) *15,
                ),
              ).tr(),
            ),
            // label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: (height/896) *25,
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(LocaleKeys.profile,
                style: TextStyle(
                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                    color: Palette.whiteText,
                    fontSize: (height/896) *15,
                ),
              ).tr(),
            ),
            // label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        unselectedFontSize:  (height/896) *18,
        selectedFontSize: (height/896) * 18,
          selectedItemColor: Palette.blurColor,
        onTap: (index){

         setState(() {
           _currentIndex = index;
           page = index;
         });
        },
      ),
    );
  }
}