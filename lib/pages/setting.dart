
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/notifiers/dark_theme_provider.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'app_language.dart';
import 'bottom_nav.dart';

class Setting extends StatefulWidget {

  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var appLanguage = Provider.of<AppLanguage>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;


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
              top: (height/896) * 260,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child: GestureDetector(
                child: Center(
                child: Container(
                  height: (height/896) * 79,
                  // width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child:  Row(
                      children: [
                        Container(
                        width: (width/4) * 3,
                        alignment: Alignment.centerLeft,
                        child: Text(LocaleKeys.change_language,
                              style: TextStyle(
                                fontSize: (height/896) *18,
                                color: Palette.pinkBox,
                              ),).tr(),
                        ),
                        Container(
                          width: width - ((width/4) * 3 + (width/414) * 50) ,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.navigate_next_outlined,
                          color: Palette.pinkBox,),
                        ),
                      ],
                    ),
                ),
              ),
                onTap: () {
                  // print("Anuuuuu*********");
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: BottomNav(index: 2, subIndex: 3),
                      ));
                }
              ),
            ),
            Positioned(
              top: (height/896) * 320,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child: GestureDetector(
                child: Center(
                child: Container(
                  height: (height/896) * 79,
                  // width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child:  Row(
                    children: [
                      Container(
                        width: (width/4) * 3,
                        alignment: Alignment.centerLeft,
                        child: Text(LocaleKeys.change_pass,
                          style: TextStyle(
                            fontSize: (height/896) *18,
                            color: Palette.pinkBox,
                          ),).tr(),
                      ),
                      Container(
                        width: width - ((width/4) * 3 + (width/414) * 50) ,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.navigate_next_outlined,
                          color: Palette.pinkBox,),
                      ),
                    ],
                  ),
                ),
              ),
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: BottomNav(index: 2, subIndex: 4),
                      ));
                },
              ),
            ),
            Positioned(
              top: (height/896) * 380,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child:Center(
                child: Container(
                  height: (height/896) * 79,
                  // width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child:  Row(
                      children: [
                        Container(
                        width: (width/4) * 3,
                        alignment: Alignment.centerLeft,
                        child: Text(LocaleKeys.privacy_policy,
                              style: TextStyle(
                                fontSize: (height/896) *18,
                                color: Palette.pinkBox,
                              ),).tr(),
                        ),
                        Container(
                          width: width - ((width/4) * 3 + (width/414) * 50) ,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.navigate_next_outlined,
                          color: Palette.pinkBox,),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 440,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child:Center(
                child: Container(
                  height: (height/896) * 79,
                  // width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child:  Row(
                      children: [
                        Container(
                        width: (width/4) * 3,
                        alignment: Alignment.centerLeft,
                        child: Text(LocaleKeys.about,
                              style: TextStyle(
                                fontSize: (height/896) *18,
                                color: Palette.pinkBox,
                              ),).tr(),
                        ),
                        Container(
                          width: width - ((width/4) * 3 + (width/414) * 50) ,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.navigate_next_outlined,
                          color: Palette.pinkBox,),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 500,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child:Center(
                child: Container(
                  height: (height/896) * 79,
                  // width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child:  Row(
                      children: [
                        Container(
                        width: (width/4) * 3,
                        alignment: Alignment.centerLeft,
                          child: Text(LocaleKeys.terms_conditions,
                              style: TextStyle(
                                fontSize: (height/896) *18,
                                color: Palette.pinkBox,
                              ),).tr(),
                        ),
                        Container(
                          width: width - ((width/4) * 3 + (width/414) * 50) ,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.navigate_next_outlined,
                          color: Palette.pinkBox,),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 560,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child:Center(
                child: Container(
                  height: (height/896) * 79,
                  // width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child:  Row(
                      children: [
                        Container(
                        width: (width/4) * 3,
                        alignment: Alignment.centerLeft,
                        child: Text(LocaleKeys.join_us,
                              style: TextStyle(
                                fontSize: (height/896) *18,
                                color: Palette.pinkBox,
                              ),).tr(),
                        ),
                        Container(
                          width: width - ((width/4) * 3 + (width/414) * 50) ,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.navigate_next_outlined,
                          color: Palette.pinkBox,),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 620,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child:Center(
                child: Container(
                  height: (height/896) * 79,
                  // width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child:  Row(
                      children: [
                        Container(
                        width: (width/4) * 3,
                        alignment: Alignment.centerLeft,
                        child: Text(LocaleKeys.legal,
                              style: TextStyle(
                                fontSize: (height/896) *18,
                                color: Palette.pinkBox,
                              ),).tr(),
                        ),
                        Container(
                          width: width - ((width/4) * 3 + (width/414) * 50) ,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.navigate_next_outlined,
                          color: Palette.pinkBox,),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Positioned(
              top: (height/602) * 45,
              left:  (width/414) * 16 ,
              right:  (width/414) * 16 ,
              child: GestureDetector(
                child:  Container(
                    alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,
                    width: width,
                    child:
                    Icon(Icons.arrow_back_ios,
                    color: Palette.whiteText,
                    size: (height/896) *25,)
                  ),

                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: BottomNav(index: 2, subIndex: 0),
                      ));
                },
              ),
            ),
            // Positioned(
            //   top: (height/896) * 701,
            //   left: (width/414) * 55,
            //   right: (width/414) * 55,
            //   child: GestureDetector(
            //     child: Center(
            //       child: Container(
            //         height: (height/896) * 50,
            //         width: width,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(8)),
            //         ),
            //         child:
            //         Card(
            //           color: Palette.pinkBox,
            //           shadowColor: Palette.balckColor,
            //           elevation: 4,
            //           child:   Center(
            //             child: Text(LocaleKeys.edit_profile,
            //               style: TextStyle(
            //                 fontSize: 20,
            //                 color: Palette.whiteText,
            //               ),).tr(),
            //           ),
            //         ),
            //       ),
            //     ),
            //     onTap: (){
            //
            //
            //       Navigator.push(
            //           context,
            //           PageTransition(
            //             type: PageTransitionType.fade,
            //             child:  BottomNav(index: 2, subIndex: 1),
            //           ));
            //       // themeChange.darkTheme = false;
            //
            //       // Navigator.push(
            //       //     context,
            //       //     PageTransition(
            //       //       type: PageTransitionType.fade,
            //       //       child:  BottomNav(index: 2, subIndex: 1),
            //       //     ));
            //
            //     },
            //   ),
            // ),
          ]
      ),
    );
  }
}