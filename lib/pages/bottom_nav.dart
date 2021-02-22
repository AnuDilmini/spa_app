import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/style/palette.dart';

class BottomNav extends StatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(color: Colors.white,),
            Container(color: Colors.white,),
            Container(color: Colors.white,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Palette.pinkBox,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image(
              image:AssetImage('assets/artboard.png'),
              height: 30,
              width: 30,
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Violate',
                style: TextStyle(
                    color: Palette.whiteText,
                    fontSize: 15,
                    fontFamily: "Poppins-Medium"
                ),
              ),
            ),
            // label: 'Violate',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image:AssetImage('assets/orders.png'),
              height: 30,
              width: 30,
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Oraders',
                style: TextStyle(
                    color: Palette.whiteText,
                    fontSize: 15,
                    fontFamily: "Poppins-Medium"
                ),
              ),
            ),
            // label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image:AssetImage('assets/profile.png'),
              height: 30,
              width: 30,
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Profile',
                style: TextStyle(
                    color: Palette.whiteText,
                    fontSize: 15,
                    fontFamily: "Poppins-Medium"
                ),
              ),
            ),
            // label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        unselectedFontSize: 18,
        selectedFontSize: 18,
        // selectedLabelStyle: TextStyle(fontFamily: "Audrey-Normal"),
        // unselectedLabelStyle: TextStyle(fontFamily: "Audrey-Normal"),
        onTap: (index){
          setState(() => _currentIndex = index,
          );
        },
      ),
    );
  }
}