import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/get_companyDetails_bloc.dart';
import 'package:flutter_app/bloc/get_companyServic_bloce.dart';
import 'package:flutter_app/model/companyService.dart';
import 'package:flutter_app/model/companyService_response.dart';
import 'package:flutter_app/network/shared.dart';
import 'package:flutter_app/style/local.keys.dart';
import 'package:flutter_app/style/palette.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'bottom_nav.dart';
import 'home.dart';

class InfoService extends StatefulWidget {

  InfoService({Key key}) : super(key: key);

  @override
  _InfoService createState() => _InfoService();
}

class _InfoService extends State<InfoService> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  ScrollController controller = ScrollController();
  bool isInfo = false;
  String companyId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isApiCompleted = false;
  var convertData;
  List<dynamic> serviceList = new List<dynamic>();
  String lngCode = "en";
  List<CompanyServices> selectedService = new List();


  @override
  void initState() {
    super.initState();

    checkDataSet();


  }

  checkDataSet() async {
    lngCode = await SharedPreferencesHelper.getLanguage();
    companyId = await SharedPreferencesHelper.getCompanyId();

    final companyDetailsData = Provider.of<CompanyDetailsDataProvider>(context, listen: false);
    companyDetailsData..getCompanyDetails(lngCode, companyId);
    companyServiceBloc..getCompanyService(lngCode, companyId);

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

    final companyDetailsData = Provider.of<CompanyDetailsDataProvider>(context);

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      key: _scaffoldKey,
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
              top: (height/602) * 40,
              left:  (width/414) * 16 ,
              child:GestureDetector(
                child: Center(
                  child: Container(
                    width: (width/414) * 16,
                    height: (width/414) * 16,
                    child:
                    Image.asset('assets/back.png',
                      // fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child:  BottomNav(index: 0, subIndex: 0),
                      ));
                },
              ),
            ),
            Positioned(
              top: (height/896) * 114,
              left: (width/414) * 12,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Palette.lightPink,
                    ),
                    height: (height/896) * 37,
                    width: (width/414) * 50,
                    child: Image.asset("assets/cart.png"),
                  ),
                ),
                onTap: (){
                  slideSheet();
                },
              ),
            ),
            Positioned(
              top: (height/896) * 109,
              left: (width/414) * 50,
              child: selectedService.isEmpty ? Container() : Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Palette.pinkBox,
                    ),
                    height: (width/414) * 20,
                    width: (width/414) * 20,
                    child: Text("${selectedService.length}",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ),
            ),
            Positioned(
              top: (height/896) * 105,
              left: (width/414) *100,
              right: (width/414) *100,
              child:  GestureDetector(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(247, 127, 151, 0.18),
                    ),
                    height: (height/896) * 215,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        // Image.asset("assets/cart.png",
                        // height: (height/896) * 124,
                        // width: (width/414) * 75,),
                        Text("FOUR\n SPA",
                        style: TextStyle(
                          fontSize: 28,
                          color: Color.fromRGBO(247, 127, 151, 1),
                        ),),
                      ]
                    ),
                  ),
                ),
                onTap: (){
                },
              ),
            ),
            Positioned(
              top: (height/896) * 326,
              left: (width/414) *226,
              child:  GestureDetector(
                child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border:  Border(
                      bottom: BorderSide(width:2, color: isInfo ? Palette.pinkBox : Colors.transparent),
                    ),
                  ),
                  child: Text(LocaleKeys.info,
                    style: TextStyle(
                      fontSize: 22,
                      color: Palette.pinkBox,
                    ),
                  ).tr(),
                ),
              ),
                onTap: (){
                  if(!isInfo) {
                    setState(() {
                      isInfo = true;
                    });
                  }
                },
              ),
            ),
            Positioned(
              top: (height/896) * 326,
              left: (width/414) * 112,
              child:  GestureDetector(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2, color:isInfo ? Colors.transparent: Palette.pinkBox ),
                      ),
                    ),
                    child: Text(LocaleKeys.service,
                      style: TextStyle(
                        fontSize: 22,
                        color: Palette.pinkBox,
                          ),
                    ).tr(),
                  ),
                ),
                onTap: (){
                  if(isInfo) {
                    setState(() {
                      isInfo = false;
                    });
                  }
                },
              ),
            ),
            Positioned(
              top: (height/896) * 378,
              left: (width/414) * 12,
              right: (width/414) * 12,
              child:
             Container(
                    padding: EdgeInsets.only(top: (height/896) * 20, right: (height/896) * 10, left: (width/414) * 10),
                    height: (height/896) * 415,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                       color: Color.fromRGBO(214, 202, 209, 0.31),
                    ),
                    child:  isInfo?
                    Container(
                      child: companyDetailsData.loading
                          ? Container(
                        child: _buildLoadingWidget(),
                      ) : Column(
                        children: [
                          Row(
                          children: [
                            Container(
                              width:  (width/414) * 250,
                              alignment: Alignment.centerLeft,
                              child:Text("${companyDetailsData.companyDetails.name}",
                              style: TextStyle(
                                color: Palette.pinkBox,
                                fontSize: 18
                                  ),
                                ),
                             ),

                            Container(
                              alignment: Alignment.centerRight,
                              // width: (width/208) * 12,
                              child:
                              Text("${companyDetailsData.companyDetails.rating}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color:  Palette.pinkText,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Audrey-Normal"
                                ),
                              ),
                            ),
                            Container(
                                    alignment: Alignment.centerRight,
                                    child:  RatingBar.builder(
                                      initialRating: double.parse(companyDetailsData.companyDetails.rating),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: width / 35,
                                      unratedColor: Palette.starColor,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  ),
                           ]
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child:Text(LocaleKeys.address,
                                    style: TextStyle(
                                        color: Palette.pinkBox,
                                        fontSize: 17
                                    ),
                                  ).tr(),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  // width: (width/208) * 12,
                                  child:
                                  Text(companyDetailsData.companyDetails.name,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:  Palette.balckColor,
                                        // fontFamily: "Audrey-Normal"
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                              children: [
                                Container(
                                  // alignment: Alignment.centerLeft,
                                  child:Text(LocaleKeys.phone,
                                    style: TextStyle(
                                        color: Palette.pinkBox,
                                        fontSize: 17
                                    ),
                                  ).tr(),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  // width: (width/208) * 12,
                                  child:
                                  Text(companyDetailsData.companyDetails.phone,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color:  Palette.balckColor,
                                      // fontFamily: "Audrey-Normal"
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Row(
                              children: [
                                Container(
                                  // alignment: Alignment.centerLeft,
                                  child:Text(LocaleKeys.hours,
                                    style: TextStyle(
                                        color: Palette.pinkBox,
                                        fontSize: 17
                                    ),
                                  ).tr(),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  // width: (width/208) * 12,
                                  child:
                                  Text("",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color:  Palette.balckColor,
                                      // fontFamily: "Audrey-Normal"
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ],
                      )
                    ) :

                    StreamBuilder<CompanyServiceResponse>(
                        stream: companyServiceBloc.subject.stream,
                        builder: (context, AsyncSnapshot<CompanyServiceResponse> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.error != null &&
                                snapshot.data.error.length > 0) {
                              return _buildErrorWidget(snapshot.data.error);
                            }
                            return _buildServiceWidget(snapshot.data);
                          } else if (snapshot.hasError) {
                            return _buildErrorWidget(snapshot.error);
                          } else {
                            return _buildLoadingWidget();
                          }
                        }
                    ),
                  )
                ),

          ]
      )
    );
  }

  void slideSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color:  Color.fromRGBO(113, 110, 110, 0.62),
            child:  Container(
                height: (height/816) * 400 + (height/816) * 20 ,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                  color:  Color.fromRGBO(233, 226, 227, 1),
                ),
                child: Stack(
                    children: [
                      Container(
                        child: Column(
                       children: [
                         Container(
                        margin: EdgeInsets.only(left: (width/414) * 30, right: (width/414) * 30, top: (height/816) * 45, bottom: (height/816) * 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all( Radius.circular(20)),
                          color:  Color.fromRGBO(248, 246, 246, 1),
                        ),
                         alignment: Alignment.topLeft,
                           height: (height/816) * 250 + (height/816) * 20,
                        width: width,
                           child: selectedService.isEmpty ?  Container(
                              width: MediaQuery.of(context).size.width,
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          Column(
                          children: <Widget>[
                          Text(
                          "No Selected Services",
                          style: TextStyle(color: Palette.pinkBox),
                          )
                          ],
                          )
                          ],
                          ),
                          ): ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: selectedService.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = selectedService[index].id;
                                    return Dismissible(
                                      direction: DismissDirection.startToEnd,
                                        key: Key(item),
                                        child:  Container(
                            height: (height/896) * 57,
                            width: width - (width/414) * 60,
                            padding: EdgeInsets.only(bottom: (height/896) * 6),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: (height/896) * 4,
                                  left: (width/414) * 1,
                                  child: Container(
                                      height: (height/896) * 49,
                                      width:(width/414) * 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        shape: BoxShape.rectangle,
                                      ),//serviceList[index]["image"]
                                      child:  selectedService[index].image != null ? CachedNetworkImage(
                                        imageUrl: selectedService[index].image,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ):
                                      Image.asset("assets/background.png")
                                  ),
                                ),
                                Positioned(
                                    top: (height/896) * 10,
                                    left: (width/414) * 75,
                                    width: (width/414) * 230,
                                    child: RichText(
                                      text: TextSpan(
                                        text: '${selectedService[index].name}\n',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Palette.pinkBox),
                                        children: <TextSpan>[
                                          TextSpan(text: '${selectedService[index].duration_min} min - ${selectedService[index].price} SR',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Palette.labelColor),),
                                        ],
                                      ),
                                    )
                                ),
                                Positioned(
                                  top: (height/896) * 20,
                                  left: (width/414) *  320,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Palette.pinkBox,
                                      ),
                                      height: (height/896) * 26,
                                      width: (height/896) * 26,
                                      child: Center(
                                          child: Icon(Icons.close,
                                            color: Palette.boxWhite,
                                            size: 23,)
                                      ),
                                    ),
                                    onTap: (){

                                      selectedService.removeAt(index);


                                      setState(() {
                                      });

                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                                        onDismissed: (direction) {
                                        // Remove the item from the data source.
                                          setState(() {
                                            selectedService.removeAt(index);
                                          });

                                        // Then show a snackbar.
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$item dismissed")));
                                      },
                                      background: Container(color: Palette.pinkBox),
                                );

                                }
                            ),
                        ),
                         Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.all( Radius.circular(20)),
                             color:  Color.fromRGBO(248, 246, 246, 1),
                           ),
                           alignment: Alignment.center,
                           height: (height/816) * 43,
                           width: (width/414) * 187,
                           child: Text(LocaleKeys.checkout,
                           style: TextStyle(
                             fontSize: 23,
                             color: Palette.pinkBox

                           ),).tr()
                         ),
                      ]
                        )
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 5,
                            width: (width/414) * 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all( Radius.circular(20)),
                              color:  Palette.pinkBox,
                            ),
                          ),
                        ),),

                    ]
                ),
              ),
          );
        });
  }

  Widget _buildServiceWidget(CompanyServiceResponse data) {
    List<CompanyServices> companyServices = data.companyServices;

    print("companyServices **${companyServices.length}");
    if (companyServices ==  null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Services",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    }
    else{
      return  Container(
        width : width,
        height:(height/2),
        child:  ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: companyServices.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  child:  Container(
                    height: (height/896) * 57,
                    width: width,
                    margin: EdgeInsets.only(bottom: (height/896) * 6),
                    child: Stack(
                      children: [
                        Positioned(
                          top: (height/896) * 4,
                          left: (width/414) * 1,
                          child: Container(
                              height: (height/896) * 49,
                              width:(width/414) * 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                shape: BoxShape.rectangle,
                              ),//serviceList[index]["image"]
                              child:  companyServices[index].image != null ? CachedNetworkImage(
                                imageUrl: companyServices[index].image,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ):
                              Image.asset("assets/background.png")
                          ),
                        ),
                        Positioned(
                            top: (height/896) * 10,
                            left: (width/414) * 75,
                            width: (width/414) * 230,
                            child: RichText(
                              text: TextSpan(
                                text: '${companyServices[index].name}\n',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Palette.pinkBox),
                                children: <TextSpan>[
                                  TextSpan(text: '${companyServices[index].duration_min} min - ${companyServices[index].price} SR',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Palette.labelColor),),
                                ],
                              ),
                            )
                        ),
                        Positioned(
                          top: (height/896) * 20,
                          left: (width/414) *  340,
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Palette.pinkBox,
                              ),
                              height: (height/896) * 26,
                              width: (height/896) * 26,
                              child: Center(
                                  child: Icon(selectedService.contains(companyServices[index]) ?  Icons.check : Icons.add,
                                    color: Palette.boxWhite,
                                    size: 23,)
                              ),
                            ),
                            onTap: (){
                              if(selectedService.contains(companyServices[index])){
                                selectedService.remove(companyServices[index]);
                              }else{
                                selectedService.add(companyServices[index]);
                              }
                              setState(() {

                              });

                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap:(){

                    if(selectedService.contains(companyServices[index])){
                      selectedService.remove(companyServices[index]);
                    }else{
                      selectedService.add(companyServices[index]);
                    }

                    setState(() {

                    });

                  }
              );
            }
        ),
      );
    }
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.0,
              width: 25.0,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Palette.pinkBox),
                strokeWidth: 4.0,
              ),
            )
          ],
        ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));
  }

  listItem(int index){
    return Container(
      height: (height/896) * 57,
      width: width,
      margin: EdgeInsets.only(bottom: (height/896) * 6),
      child: Stack(
        children: [
          Positioned(
          top: (height/896) * 4,
          left: (width/414) * 1,
          child: Container(
              height: (height/896) * 49,
              width:(width/414) * 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
              ),
                child:  serviceList[index]["image"] != null ? CachedNetworkImage(
                imageUrl: serviceList[index]["image"],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
            ):
                    Image.asset("assets/ipay.png")
          ),
          ),
          Positioned(
          top: (height/896) * 10,
          left: (width/414) * 75,
          width: (width/414) * 230,
          child: RichText(
            text: TextSpan(
              text: '${serviceList[index]["name"]}\n',
              style: TextStyle(
                  fontSize: 18,
              color: Palette.pinkBox),
              children: <TextSpan>[
                TextSpan(text: '${serviceList[index]["duration_min"]} min - ${serviceList[index]["price"]} SR',
                    style: TextStyle(
                        fontSize: 14,
                        color: Palette.labelColor),),
              ],
            ),
           )
          ),
         Positioned(
        top: (height/896) * 20,
        left: (width/414) *  340,
        child: GestureDetector(
          child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
            color: Palette.pinkBox,
          ),
          height: (height/896) * 26,
          width: (height/896) * 26,
          child: Center(
              child: Icon(Icons.add,
              color: Palette.boxWhite,
              size: 23,)
          ),
        ),
          onTap: (){
            selectedService.add(serviceList[index]);
            // Navigator.push(
            //     context,
            //     PageTransition(
            //       type: PageTransitionType.fade,
            //       child:  BottomNav(index: 0, subIndex: 4),
            //     ));
          },
        ),
        )
        ],
      ),
    );
      

  }

  // Future<String> getCompanyDetails() async {
  //
  //   companyId = await SharedPreferencesHelper.getCompanyId();
  //   print("companyId $companyId");
  //   if(companyId != "null") {
  //     String url = Repository.companyDetails + "$companyId";
  //     bool networkResults = await NetworkCheck.checkNetwork();
  //
  //     if (networkResults) {
  //       final response = await http.get(
  //         Uri.encodeFull(url),
  //         headers: {
  //           "Accept": "application/json",
  //           // "Accept-Language": "${context.locale}",
  //         },
  //
  //       );
  //
  //       int responseCode = response.statusCode;
  //       print("response code $responseCode");
  //
  //       if (responseCode == 200) {
  //         print("response code");
  //         convertData = json.decode(response.body);
  //         serviceList = convertData['data']['services'];
  //
  //         print("convertData ${convertData["data"]}");
  //         print("serviceList ${serviceList.length}");
  //         setState(() {
  //           isApiCompleted = true;
  //         });
  //       } else if (responseCode == 404) {
  //         showSnackbar(context, "Data Not Found !");
  //       } else if (responseCode == 500) {
  //         showSnackbar(context, "server Error");
  //       } else {
  //         setState(() {
  //           showSnackbar(context, "Error while fetching data");
  //         });
  //       }
  //       return "sucess";
  //     } else {
  //       // print("print ---> No Internet !!");
  //       showSnackbar(context, "No Internet!");
  //     }
  //   }else{
  //
  //   }
  //   return "success";
  // }

  showSnackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
