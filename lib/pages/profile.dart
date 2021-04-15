
// import 'package:share/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/notifiers/dark_theme_provider.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'bottom_nav.dart';

class Profile extends StatefulWidget {

  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;
  bool _switchValue  =false;
  String lanCode = "en";


  @override
  void initState() {
    super.initState();
    getTheme();

  }

  getTheme() async{
    bool getTheme =await SharedPreferencesHelper.getTheme();

    setState(() {
     if(getTheme){
        _switchValue = true;
      }else{
        _switchValue = false;
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<DarkThemeProvider>(context);

    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;

    lanCode = context.locale.languageCode;

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      body: Stack(
          children: [
            Container(
              height: height,
              width: width,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      image: new AssetImage("assets/curve_back.png"),
                      fit:  BoxFit. fill
                    )
                )
            ),
            Positioned(
              top: (height/896) * 695,
              left: (width/414) * 305,
              child: Container(
                child: Image.asset("assets/curve.png",
                    fit:  BoxFit. fill),
              ),
            ),
            Positioned(
              top: (height/896) * 2,
              width: width,
                child:Center(
                  child: Container(
                    height: (height/896) * 61,
                    child: Image.asset("assets/pink_art.png",
                        ),
                 ),
                ),
            ),
            Positioned(
              top: (height/896) * 147,
              width: width,
              child:Center(
                child: Container(
                  height: (height/896) * 75,
                  width: (height/896) * 75,
                  child: Image.asset("assets/profile_edit3.png",
                      fit:  BoxFit. fill),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 243,
              width: width,
              child:Center(
                child: Container(
                  height: (height/896) * 75,
                  child: Text("Atheer",
                  style: TextStyle(
                    fontSize:  (height/896) *28,
                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                    color: Palette.pinkBox,
                  ),)
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 345,
              left: (width/414) * 45,
              right: (width/414) * 45,
              child: GestureDetector(
                child: Center(
                child: Container(
                    height: (height/896) * 79,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Card(
                      color: Palette.buttonWhite,
                      shadowColor: Palette.balckColor,
                      elevation: 3,
                      child:  Row(
                            children: [
                              Container(
                                height: (height/896) * 25,
                                width: (width/414) *25,
                                margin: EdgeInsets.only(left: (width/414) * 20, right: (width/414) * 10 ),
                                child: Icon(Icons.phone,
                                    color: Palette.pinkBox,
                                  size:  (height/896) * 25,
                                ),
                              ),
                              Text(LocaleKeys.contact_us,
                              style: TextStyle(
                                fontSize:  (height/896) *18,
                                fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                color: Palette.pinkBox,
                              ),).tr(),
                            ],
                          ),
                    ),
                ),
              ),
                onTap: () {
                  launch(_emailLaunchUri.toString());
                },
              ),
            ),
            Positioned(
              top: (height/896) * 437,
              left: (width/414) * 45,
              right: (width/414) * 45,
              child:GestureDetector(
                child: Center(
                child: Container(
                  height: (height/896) * 79,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Card(
                    color: Palette.buttonWhite,
                    shadowColor: Palette.balckColor,
                    elevation: 3,
                    child:  Row(
                      children: [
                        Container(
                          height: (height/896) * 25,
                          width: (width/414) *25,
                          margin: EdgeInsets.only(left: (width/414) * 20, right: (width/414) * 10 ),
                          child:  Icon(Icons.settings,
                              color: Palette.pinkBox,
                            size:  (height/896) * 25,
                          ),
                        ),
                        Text(LocaleKeys.Settings,
                          style: TextStyle(
                            fontSize:  (height/896) *18,
                            fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            color: Palette.pinkBox,
                          ),).tr(),
                      ],
                    ),
                  ),
                ),
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child:  BottomNav(index: 2, subIndex: 2),
                      ));
                },
              ),
            ),
            Positioned(
              top: (height/896) * 529,
              left: (width/414) * 45,
              right: (width/414) * 45,
              child: GestureDetector(
                child: Center(
                child: Container(
                  height: (height/896) * 79,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Card(
                    color: Palette.buttonWhite,
                    shadowColor: Palette.balckColor,
                    elevation: 3,
                    child:  Row(
                      children: [
                        Container(
                          height: (height/896) * 25,
                          width: (width/414) *25,
                          margin: EdgeInsets.only(left: (width/414) * 20, right: (width/414) * 10 ),
                          child: Icon(Icons.share_outlined,
                              color: Palette.pinkBox,
                            size:  (height/896) * 25,
                          ),
                        ),
                        Text(LocaleKeys.share_app,
                          style: TextStyle(
                            fontSize:  (height/896) *18,
                            fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            color: Palette.pinkBox,
                          ),).tr(),
                      ],
                    ),
                  ),
                ),
              ),
                onTap: () async {

                  Share.share('Check out our spa app', subject: 'Look what I made!');

                },
              ),
            ),
            // Positioned(
            //   top: (height/602) * 45,
            //   left:  (width/414) * 16 ,
            //   right:  (width/414) * 16 ,
            //   child:GestureDetector(
            //     child: Container(
            //         alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,
            //         width: width,
            //         child:
            //         Icon(Icons.arrow_back_ios,
            //         color: Palette.whiteText,
            //         size: 25,)
            //     ),
            //     onTap: (){
            //       // Navigator.push(
            //       //     context,
            //       //     PageTransition(
            //       //       type: PageTransitionType.fade,
            //       //       child: Orders(),
            //       //     ));
            //     },
            //   ),
            // ),
            Positioned(
              top: (height/602) * 80,
              left: (width/414) * 350,
              right: (width/414) * 50,
              child:GestureDetector(
                child: Center(
                  child: Container(
                    alignment: Alignment.centerRight,
                    // width: (width/414) * 100,
                    height: (width/414) * 16,
                    child:  CupertinoSwitch(
                      value: _switchValue,
                      activeColor: Palette.pinkBox,
                      trackColor: Palette.whiteText,
                      onChanged: (value)  async{
                        await SharedPreferencesHelper.setTheme(value);
                        setState(() {
                          _switchValue = value;
                          if(_switchValue) {
                            themeChange.darkTheme = true;
                          }else{
                            themeChange.darkTheme = false;
                          }
                        });
                      },
                    ),
                  ),
                ),

              ),
            ),
            Positioned(
          top: (height/896) * 701,
          left: (width/414) * 55,
          right: (width/414) * 55,
          child: GestureDetector(
            child: Center(
            child: Container(
              height: (height/896) * 50,
              width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              child:
              Card(
                color: Palette.pinkBox,
                shadowColor: Palette.balckColor,
                elevation: 4,
                child:   Center(
              child: Text(LocaleKeys.edit_profile,
              style: TextStyle(
                fontSize:  (height/896) *20,
                fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                color: Palette.whiteText,
              ),).tr(),
            ),
              ),
          ),
          ),
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child:  BottomNav(index: 2, subIndex: 1),
                  ));
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => BottomNav(index: 2, subIndex: 1,)),
              // );
            },
          ),
          ),
          ]
      ),
    );
  }

   Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'violetapp@gmail.com',
      queryParameters: {
        'subject': 'Contact Us!'
      }
  );
}