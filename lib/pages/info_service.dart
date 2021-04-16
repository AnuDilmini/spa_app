import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/bloc/get_companyDetails_bloc.dart';
import 'package:violet_app/bloc/get_companyServic_bloce.dart';
import 'package:violet_app/model/companyService.dart';
import 'package:violet_app/model/companyService_response.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:violet_app/utils/network_check.dart';
import 'bottom_nav.dart';

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
  bool isApiCompleted = false, isNoInternet = false;
  var convertData;
  List<dynamic> serviceList = new List<dynamic>();
  String lngCode = "en";
  List<CompanyServices> selectedService = new List();
  double total = 0.0;
  double zoom = 1;


  @override
  void initState() {
    super.initState();

    checkDataSet();

  }

  checkDataSet() async {
    bool networkResults = await NetworkCheck.checkNetwork();
    lngCode = await SharedPreferencesHelper.getLanguage();
    companyId = await SharedPreferencesHelper.getCompanyId();

    if(lngCode == "en"){
      zoom = 1;
    }else if(lngCode == "ar"){
      zoom = 1.5;
    }

    if (networkResults) {
      setState(() {
        isNoInternet =false;
      });
      final companyDetailsData = Provider.of<CompanyDetailsDataProvider>(context, listen: false);
      companyDetailsData..getCompanyDetails(lngCode, companyId);
      companyServiceBloc..getCompanyService(lngCode, companyId);
    }else{
      setState(() {
        isNoInternet =true;
      });
    }
  }

  getData() async{
    String serviceListJson = await SharedPreferencesHelper.getSelectedService();

    if (serviceListJson != "") {
      selectedService = CompanyServices.decode(serviceListJson);
      // selectedServiceCount = selectedService.length;
      // totalPriceSum();
    }
    setState(() {

    });

  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    controller.dispose();
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
              left: (width/414) * 160,
              child: Container(
                  height: (height/896) * 55,
                  child: Image.asset("assets/pink_art.png",
                  ),

              ),
            ),
            Positioned(
              top: (height/602) * 40,
              left:  (width/414) * 16 ,
              right:  (width/414) * 16 ,
              child:GestureDetector(
                child: Container(
                      alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,

                    child:
                    Icon(Icons.arrow_back_ios,
                      size: (height/896) *25,
                      color: Palette.whiteText,
                    )
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
                    child: Icon(Icons.shopping_cart_outlined,
                      color: Palette.pinkBox,
                      size: (height/896) *25,
                    ),
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
                          fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                        color: Colors.white,
                        fontSize: (height/896) * 12 * zoom
                      ),
                    )
                  ),
            ),
            Positioned(
              top: (height/896) * 140,
              left: (width/414) *130,
              right: (width/414) *140,
              child: Container(
                width:  (height/896)* 85,
                height: (height/896) * 100,
                child: companyDetailsData.companyDetails.logo  != null ?
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(Repository.iconUrl+companyDetailsData.companyDetails.logo,
                    fit: BoxFit.fill,
                  errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                    // print('info_service::build: ImageNetwork error has occurred.');
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                    child:Image.asset("assets/background.png",
                      fit: BoxFit.fill,)
                    );
                  },)
                ): ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                child: new Image.asset("assets/background.png",
                  fit: BoxFit.fill,),
              ),
              ),
            ),
            Positioned(
              top:  lngCode == "en"? (height/896) * 310 : (height/896) * 285 ,
              right: (width/414) *125,
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
                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                      fontSize: (height/896) *27 * zoom,
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
              top:  lngCode == "en"? (height/896) * 310 : (height/896) * 285 ,
              left: (width/414) * 116,
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
                        fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                        fontSize: (height/896) *27 * zoom,
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
              top: (height/896) * 370,
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
                    child:  isInfo?(
                    isNoInternet ?
                    Center(
                        child: Container(
                          width: width,
                          alignment: Alignment.center,
                          child: Text("",
                            style: TextStyle(
                                fontSize:   (height/896) * 18 ,
                                color:  Palette.whiteText,
                                fontWeight: FontWeight.bold,
                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',

                            ),).tr(),
                        )
                    ): Container(
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
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                color: Palette.pinkBox,
                                fontSize: (height/896) *18
                                  ),
                                ),
                             ),

                            Container(
                              alignment: Alignment.centerRight,
                              // width: (width/208) * 12,
                              child:
                              Text("${companyDetailsData.companyDetails.rating}",
                                style: TextStyle(
                                    fontSize: (height/896) *18 ,
                                    color:  Palette.pinkText,
                                    fontWeight: FontWeight.w600,
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                ),
                              ),
                            ),
                            Container(
                                    alignment: Alignment.centerRight,
                                    child:  RatingBar.builder(
                                      ignoreGestures: true,
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

                                      },
                                    ),
                                  ),
                           ]
                          ),
                          SizedBox(
                            height: (height/896) *25,
                          ),
                          Row(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child:Text(LocaleKeys.address,
                                    style: TextStyle(
                                        color: Palette.pinkBox,
                                        fontSize: (height/896) *17 * zoom,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    ),
                                  ).tr(),
                                ),
                                SizedBox(
                                  width: (height/896) *12,
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  // width: (width/208) * 12,
                                  child:
                                  Text(companyDetailsData.companyDetails.name,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: (height/896) *18 ,
                                        color:  Palette.balckColor,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(
                            height:(height/896) * 25,
                          ),
                          Row(
                              children: [
                                Container(
                                  // alignment: Alignment.centerLeft,
                                  child:Text(LocaleKeys.phone,
                                    style: TextStyle(
                                        color: Palette.pinkBox,
                                        fontSize: (height/896) *17 * zoom,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    ),
                                  ).tr(),
                                ),
                                SizedBox(
                                  width: (height/896) * 12,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  // width: (width/208) * 12,
                                  child:
                                  Text(companyDetailsData.companyDetails.phone,
                                    style: TextStyle(
                                      fontSize: (height/896) *18 ,
                                      color:  Palette.balckColor,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(
                            height: (height/896) *35 ,
                          ),
                          Row(
                              children: [
                                Container(
                                  // alignment: Alignment.centerLeft,
                                  child:Text(LocaleKeys.hours,
                                    style: TextStyle(
                                        color: Palette.pinkBox,
                                        fontSize: (height/896) *17 * zoom,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    ),
                                  ).tr(),
                                ),
                                SizedBox(
                                  width: (height/896) *12,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  // width: (width/208) * 12,
                                  child:
                                  Text("",
                                    style: TextStyle(
                                      fontSize: (height/896) *18 ,
                                      color:  Palette.balckColor,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ],
                      )
                    )
                    ):
                    (isNoInternet ?
                    Center(
                        child: Container(
                          width: width,
                          alignment: Alignment.center,
                          child: Text("",
                            style: TextStyle(
                                fontSize:   (height/896) * 18 * zoom,
                                color:  Palette.whiteText,
                                fontWeight: FontWeight.bold,
                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',

                            ),).tr(),
                        )
                    ):
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
                    )
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
        backgroundColor: Colors.transparent,
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
                          style: TextStyle(color: Palette.pinkBox,
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                          )
                          ],
                          )
                          ],
                          ),
                          ):
                           Column(
                             children: [
                               Container(
                               height: (height/816) * 220,
                             child:
                              ListView.builder(
                                  padding: EdgeInsets.zero,
                             scrollDirection: Axis.vertical,
                             itemCount: selectedService.length,
                             itemBuilder: (BuildContext context, int index) {
                               final item = selectedService[index].id;
                               return Dismissible(
                                 direction: DismissDirection.startToEnd,
                                 key: Key(item),
                                 child:  Container(
                                   height: (height/896) * 65,
                                   width: width - (width/414) * 60,
                                   padding: EdgeInsets.only(bottom: (height/896) * 6),
                                   child: Row(
                                     children: [
                                     Container(
                                             height: (height/896) * 49,
                                             width:(width/414) * 60,
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(8),
                                               shape: BoxShape.rectangle,
                                             ),//serviceList[index]["image"]
                                             child:  selectedService[index].image != null ?
                                             Image.network(Repository.iconUrl+selectedService[index].image,
                                               errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                                 print('info_service::slideSheet: ImageNetwork error has occurred.');
                                                 return Image.asset("assets/background.png",
                                                   fit: BoxFit.fill,);
                                               },):
                                             Image.asset("assets/background.png")
                                         ),
                                     Container(
                                       width:  (width/208) *120,
                                       padding: EdgeInsets.only(left:  (width/208) * 5, top:  (height/449) * 5 , right: (height/449) * 5),
                                       child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(
                                                 "${selectedService[index].name}",
                                                 maxLines: 1,
                                                 overflow: TextOverflow.clip,
                                                 style: TextStyle(
                                                     fontSize: (height/896) *18 ,
                                                     color: Palette.pinkBox,
                                                   fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                                               ),
                                               Text(
                                                 "${selectedService[index].duration_min} min - ${selectedService[index].price} SR",
                                                 style: TextStyle(
                                                     fontSize: (height/896) *14 ,
                                                     color: Palette.labelColor,
                                                   fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                                               )
                                             ],
                                           ),
                                     ),
                                       GestureDetector(
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
                                                   size: (height/896) *23,)
                                             ),
                                           ),
                                         ),
                                     ],
                                   ),
                                 ),
                                 onDismissed: (direction) {
                                     total = total - double.parse(selectedService[index].price);
                                     selectedService.removeAt(index);
                                     setState(() {
                                     });
                                  },
                                 background: Container(color: Palette.pinkBox),
                               );

                             }
                           ),
                               ),
                               Container(
                                 height: (height/816) * 50,
                                 // color: Colors.red,
                                 child: Row(
                                   children:[
                                     Expanded(
                                       flex:1,
                                         child:
                                     Align(
                                       alignment: Alignment.centerLeft,
                                       child: Padding(
                                           padding:  EdgeInsets.only(left: (width/414) * 15),
                                           child: Text(LocaleKeys.total,
                                       style: TextStyle(
                                         color: Palette.pinkBox,
                                         fontSize:(height/896) * 20 * zoom,
                                         fontWeight: FontWeight.bold,
                                         fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                       ),).tr()
                                     )
                                     ),
                                     ),
                                   Expanded(
                                       flex:1,
                                       child:
                                     Align(
                                         alignment: Alignment.centerRight,
                                         child: Padding(
                                             padding:  EdgeInsets.only(right: (width/414) * 30 ),
                                             child: Text('${totalPriceSum()} SR',
                                               style: TextStyle(
                                                   color: Palette.pinkBox,
                                                   fontSize: (height/896) * 19,
                                                   fontWeight: FontWeight.w400,
                                                 fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                               ),)
                                         )
                                     ),
                                   ),
                                  ]
                                 )
                               )
                             ],
                           )
                            ),
                         selectedService.isNotEmpty ? GestureDetector(
                           child:
                         Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.all( Radius.circular(20)),
                             color:  Color.fromRGBO(248, 246, 246, 1),
                           ),
                           alignment: Alignment.center,
                           height: (height/816) * 43,
                           width: (width/414) * 187,
                           child: Center(
                               child: Text(LocaleKeys.checkout,
                           style: TextStyle(
                               fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                             fontSize: (height/896) * 23 * zoom,
                             fontWeight: FontWeight.w600,
                             color: Palette.pinkBox
                           ),).tr()
                           ),
                         ),
                           onTap: () async{
                             if(selectedService.isNotEmpty){
                               String serviceList = CompanyServices.encode(selectedService);
                               await SharedPreferencesHelper.setSelectedService(serviceList);
                               Navigator.push(
                                   context,
                                   PageTransition(
                                     type: PageTransitionType.fade,
                                     child:  BottomNav(index: 0, subIndex: 4),
                                   ));
                             }
                           },
                         ):
                         Container(),
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
                            height: (height/816) * 9,
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

  double totalPriceSum() {

     for(int i = 0; i < selectedService.length ; i++){
       total = total + double.parse(selectedService[i].price);

     }

     return total;
  }

  double minusPriceSum(double amount) {

    total = total - amount;
    setState(() {

    });
  }

  Widget _buildServiceWidget(CompanyServiceResponse data) {
    List<CompanyServices> companyServices = data.companyServices;


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
                  style: TextStyle(color: Colors.black45,
                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
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
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: companyServices.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  child:  Container(
                    height: (height/896) * 57,
                    width: width,
                    margin: EdgeInsets.only(bottom: (height/896) * 6),
                    child: Row(
                      children: [
                       Container(
                              height: (height/896) * 49,
                              width:(width/414) * 60,
                              child: companyServices[index].image != null ?
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child:Image.network(Repository.iconUrl+companyServices[index].image,
                                      fit: BoxFit.fill,
                                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                    // print('info_service::_buildServiceWidget: ImageNetwork error has occurred.');
                                  return ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                  child:Image.asset("assets/background.png",
                                    fit: BoxFit.fill,)
                                  );
                                },)
                              ):
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child:Image.asset("assets/background.png",
                                      fit: BoxFit.fill)
                              ),
                          ),
                        Container(
                          padding: EdgeInsets.only(left:  (width/208) * 10, top:  (height/449) * 5 , right: (height/449) * 10),
                          width:  (width/208) *135,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                  '${companyServices[index].name}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize:  (height/896) * 17 ,
                                      color: Palette.pinkBox,
                                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                                ),
                                Text(
                                  '${companyServices[index].duration_min} min  -  ${companyServices[index].price} SAR',
                                  style: TextStyle(
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      fontSize:  (height/896) * 12 ,
                                      color: Palette.labelColor),
                                ),
                              ]
                          ),
                       ),
                       GestureDetector(
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
                                    size: (height/896) *23,)
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
              height: (height/896) * 25.0,
              width:  (width/414) *25.0,
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

  showSnackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
