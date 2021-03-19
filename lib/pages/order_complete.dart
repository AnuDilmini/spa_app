import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/update_profile.dart';
import 'package:flutter_app/style/palette.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/style/local.keys.dart';

import 'home.dart';

class OrderComplete extends StatefulWidget {

  OrderComplete({Key key}) : super(key: key);

  @override
  _OrderComplete createState() => _OrderComplete();
}

class _OrderComplete extends State<OrderComplete> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isInfo = false;


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
            // Container(
            //     height: height,
            //     width: width,
            //     decoration: BoxDecoration(
            //         shape: BoxShape.rectangle,
            //         image: new DecorationImage(
            //             image: new AssetImage("assets/curve_back.png"),
            //             fit:  BoxFit. fill
            //         )
            //     )
            // ),
            Positioned(
              top: (height/896) * 0,
              left: (width/414) * 0,
              child:  Container(
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
            ),
            Positioned(
              top: (height/896) * 695,
              left: (width/414) * 315,
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
              top: (height/896) * 65,
              left: (width/414) * 16,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    height: (height/896) * 15,
                    width: (width/414) * 10,
                    child: Image.asset("assets/back.png"),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
            Positioned(
              top: (height/896) * 142,
              left: (width/414) * 20,
              right: (width/414) * 20,
              child:
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: (height/896) * 20, right: (height/896) * 10, left: (width/414) * 10),
                  height: (height/896) * 660,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromRGBO(168, 132, 153, 0.2),
                  ),
                  child:  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.your_order_is_completed,
                        style: TextStyle(
                          fontSize: 28,
                          color: Palette.pinkBox,
                        ),).tr(),
                        Container(
                          margin: EdgeInsets.only(top: (height/896) * 20, right: (height/896) * 15, left: (width/414) * 15),
                          height: (height/896) * 230,
                          width: width,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: (height/896) * 40, right: (height/896) * 20, left: (width/414) * 20),
                          height: (height/896) * 230,
                          width: width,
                          child:RichText(
                            text: TextSpan(
                              text: 'Order number:\n',
                              style: TextStyle(
                                  fontSize: 20,
                                  height: (height/896) * 1.5,
                                  color: Palette.textGrey),
                              children: <TextSpan>[
                                TextSpan(text: ' #2133\n',
                                  style: TextStyle(
                                      fontSize: 17,
                                      height: (height/896) *1.2,
                                      color: Palette.pinkBox),),
                                TextSpan(text: 'Date and Time\n',
                                  style: TextStyle(
                                      fontSize: 20,
                                      height: (height/896) *3,
                                      color: Palette.textGrey),),
                                TextSpan(text: ' 19 January, 1:12\n',
                                style: TextStyle(
                                    fontSize: 17,
                                    height: (height/896) *1,
                                    color: Palette.pinkBox),
                              ),
                                TextSpan(text: 'Order\n',
                                  style: TextStyle(
                                      fontSize: 20,
                                      height: (height/896) *3,
                                      color: Palette.textGrey),),
                                TextSpan(text: ' HAIR COLOR           100SAR\n',
                                  style: TextStyle(
                                      fontSize: 17,
                                      height: (height/896) *1.3,
                                      color: Palette.pinkBox),
                                ),
                                TextSpan(text: ' HAIR CUT                500SAR\n',
                                  style: TextStyle(
                                      fontSize: 17,
                                      height: (height/896) *1.3,
                                      color: Palette.pinkBox),
                                ),

                              ],
                            ),
                          )
                        ),
                      ],
                    )
                  )
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 0,
              left: (width/414) * 0,
              child:  Container(
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
            ),
            Positioned(
              top: (height/896) * 510,
              left: (width/414) * 230,
              child:  Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromRGBO(247, 127, 151, 0.18),
                  ),
                  height: (height/896) * 108,
                  width: (height/896) * 108,
                  child: Center(
                    child:
                        Image.asset("assets/cart.png",
                        ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 132,
              left: (width/414) * 378,
              child: GestureDetector(
                child: Container(
                  height: (height/896) * 20,
                  width: (height/896) * 20,
                  child: Center(
                    child:
                    Image.asset("assets/close.png",
                    ),
                  ),
                ),
                onTap: (){

                },
              ),
            ),
          ]
      ),
    );
  }


}
