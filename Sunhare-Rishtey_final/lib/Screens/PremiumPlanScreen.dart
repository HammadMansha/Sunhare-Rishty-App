import 'dart:ffi';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimonial_app/Providers/ContactsProvider.dart';
import 'package:matrimonial_app/Screens/banner_ads_view.dart';
import 'package:matrimonial_app/Screens/intertitial_ads_view.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/NoGlowBehaviour.dart';
import 'package:matrimonial_app/customs/custom_widgets.dart';
import 'package:matrimonial_app/models/Membership.dart';
import 'package:uuid/uuid.dart';
import '../models/DiscountGroup.dart';
import '/Providers/getUserInfo.dart';
import '/models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '/main.dart';
import 'HomeScreen.dart';

class PremiuimPlanScreen extends StatefulWidget {
  @override
  _PremiuimPlanScreenState createState() => _PremiuimPlanScreenState();
}

class _PremiuimPlanScreenState extends State<PremiuimPlanScreen> {
  int choosenPlan = 0;
  double opacityLevel = 0.0;
  List<Membership> memberships = [];
  List<DiscountGroup> discountGroup = [];
  List<DiscountGroup> discountGroup2 = [];
  var listener;
  double oldUserDiscPercen = 0.0;
  double myDiscount = 0.0;
  DateTime myDiscountExpDate = DateTime.now();

  getDiscountGroup() {
    FirebaseDatabase.instance
        .reference()
        .child('Discount Group')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final mapped = event.snapshot.value as Map;
        discountGroup.clear();
        discountGroup2.clear();
        mapped.forEach((key, value) {
            discountGroup.add(DiscountGroup(
                id: key,
                name: value['name'],
                discount_percentage: double.parse(value['discount_percentage'].toString()),
                expire_date: DateTime.parse(value['expire_date']),
                user_ac_old_date: DateTime.parse(value['user_ac_old_date']),
                start_date: DateTime.parse(value['start_date']),
                user_ac_old_days: double.parse(value['user_ac_old_days'].toString())
            ));
        });

      }

      discountGroup.sort((DiscountGroup a,DiscountGroup b)  => (b.user_ac_old_days as num).compareTo(a.user_ac_old_days as num));
      DateTime myJoinedDate = DateTime.parse(user.dateOfCreated.toString());

      for(int i = 0 ; i < discountGroup.length ; i++){
        if(discountGroup[i].user_ac_old_date!.isAfter(myJoinedDate)){
          if(discountGroup[i].expire_date!.isAfter(DateTime.now())){
            discountGroup2.add(discountGroup[i]);
          }
        }
      }

      if(discountGroup2.isNotEmpty){
        discountGroup2.sort((DiscountGroup a,DiscountGroup b)  => a.user_ac_old_date!.compareTo(b.user_ac_old_date!));
        debugPrint("discountGroup2 ==> ${discountGroup2[0].discount_percentage}");
        oldUserDiscPercen = discountGroup2[0].discount_percentage!;
      }
      getMyDiscount();
    });
  }

  Future getMyDiscount() async{

    var listenerData = FirebaseDatabase.instance
        .reference()
        .child('Discount User Wise')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {

      if (event.snapshot.value != null) {
        final mapped = event.snapshot.value as Map;
        mapped.forEach((key, value) {
          if(key == "discount_percentage"){
            myDiscount = double.parse(value);
          }
          if(key == "expire_date"){
            myDiscountExpDate = DateTime.parse(value);
          }
        });

        if(myDiscountExpDate.isBefore(DateTime.now())){
          myDiscount = 0.0;
        }
      }
      if(myDiscount > oldUserDiscPercen){
        oldUserDiscPercen = myDiscount;
      }else{
        oldUserDiscPercen = oldUserDiscPercen;
      }
      getMemberships();
    });


  }

  Future<void> getMemberships() async {
    listener = FirebaseDatabase.instance
        .reference()
        .child('PremiumPackage')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final mapped = event.snapshot.value as Map;
        memberships.clear();
        mapped.forEach((key, value) {
          bool isHide = value["isHide"];
          if (!isHide) {
            memberships.add(Membership(
                id: key,
                contacts: int.parse(value['contacts'].toString()),
                name: value['name'],
                discount: double.tryParse(value['discount'].toString()) ?? 0,
                discountValidTill:
                    DateTime.tryParse(value['months'].toString()) ??
                        DateTime.now(),
                months: int.parse(value['timeDuration'].toString()),
                price: double.parse(value['price'].toString()),
                isHide: value['isHide']));
          }
        });
        setState(() {
          memberships
              .sort((Membership a, Membership b) => a.price!.compareTo(b.price ?? 0));
          choosenPlan = (memberships.length / 2).floor();
          _carouselController.jumpToPage(choosenPlan);
          _carouselController.onReady.then((value) {
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                opacityLevel = 1.0;
              });
            });
          });
        });
      }
    });
  }

  Razorpay _razorpay = Razorpay();
  double payment = 100;
  String bannerURL = '';

  List<String> contacts = [];

  UserInformation user = UserInformation();
  CarouselController _carouselController = CarouselController();
  @override
  void initState() {
    _carouselController = CarouselController();
    getOfferBanner();
    user = Provider.of<CurrUserInfo>(context, listen: false).currentUser;

    getDiscountGroup();



    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    contacts = Provider.of<ContactProvider>(context, listen: false).contacts;


    super.initState();

  }

  Future<int> addHistory(int remainingDays) async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(user.id ?? "")
        .once();
    Map tempData = data.snapshot.value as Map;

    if (tempData != null && tempData.isNotEmpty) {
      await FirebaseDatabase.instance
          .reference()
          .child('ActiveMembership')
          .child(user.id ?? "")
          .child('history')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .update({
        'planName': tempData['packageName'],
        'contacts': tempData['contacts'],
        'validTill': tempData['ValidTill'],
        'price': tempData['amount'],
        'startTime': tempData['DateOfPerchase'],
        'packageId': tempData['packageId'],
      });
    } else {
      return 0;
    }
    int returnVal = 0;
    if (remainingDays <= 0) {
      returnVal += contacts.length;
    } else {
      returnVal += int.parse(tempData['contacts'].toString() ?? "0");
    }
    // Return contacts to add with new plan
    return returnVal;
  }

  void tempSuccessApiCall() {
    int remainingDays = user.premiumModel != null
        ? ((user.premiumModel!.validTill ?? DateTime.now())
                    .difference(
                        user.premiumModel!.dateOfPerchase ?? DateTime.now())
                    .inHours /
                24)
            .round()
        : 0;

    if (remainingDays <= 0) remainingDays = 0;

    var tempCalc = memberships[choosenPlan].discount != null &&
        DateTime.now().compareTo(memberships[choosenPlan].discountValidTill ?? DateTime.now()) <
            0
        ? ((memberships[choosenPlan].price ?? 0) -
        (memberships[choosenPlan].price ?? 0) *
            (memberships[choosenPlan].discount ?? 0) / 100)
        : (memberships[choosenPlan].price ?? 0) * 100;
    tempCalc = (((tempCalc) - (oldUserDiscPercen) * (tempCalc) /100));


    addHistory(remainingDays).then((value) => {
          FirebaseDatabase.instance
              .reference()
              .child('ActiveMembership')
              .child(user.id ?? "")
              .update({
            // 'amount': memberships[choosenPlan].discount != null &&
            //         DateTime.now().compareTo(memberships[choosenPlan].discountValidTill ?? DateTime.now()) < 0
            //     ? memberships[choosenPlan].price ?? 0 * (1 - (memberships[choosenPlan].discount ?? 0) / 100) *
            //         100
            //     : (memberships[choosenPlan].price ?? 0) * 100,
            'amount': tempCalc,
            'DateOfPerchase': DateTime.now().toIso8601String(),
            'ValidTill': DateTime.now()
                .add(Duration(
                    days: 30 * (memberships[choosenPlan].months ?? 0) + remainingDays))
                .toIso8601String(),
            'email': user.email,
            'imageUrl': user.imageUrl,
            'name': user.name,
            'packageId': memberships[choosenPlan].id,
            'packageName': memberships[choosenPlan].name,
            'phone': user.phone,
            'srId': user.srId,
            'status': 'Current',
            'contacts': (memberships[choosenPlan].contacts ?? 0) + value
          }).then((value) {
            sendPushNotificationToAdmin("User Subscribed",
                "${user.name} bought subscription for ${memberships[choosenPlan].name}",
                target: Constants.ADMIN_GOT_SUBSCRIPTION,
                userId: FirebaseAuth.instance.currentUser!.uid);
            planWithContactMethod();
            showSuccessAlert();
          })
        });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    int remainingDays = user.premiumModel != null
        ? ((user.premiumModel!.validTill ?? DateTime.now())
        .difference(
        user.premiumModel!.dateOfPerchase ?? DateTime.now())
        .inHours /
        24)
        .round()
        : 0;

    if (remainingDays <= 0) remainingDays = 0;

    var tempCalc = memberships[choosenPlan].discount != null &&
        DateTime.now().compareTo(memberships[choosenPlan].discountValidTill ?? DateTime.now()) <
            0
        ? ((memberships[choosenPlan].price ?? 0) -
        (memberships[choosenPlan].price ?? 0) *
            (memberships[choosenPlan].discount ?? 0) / 100)
        : (memberships[choosenPlan].price ?? 0) * 100;
    tempCalc = (((tempCalc) - (oldUserDiscPercen) * (tempCalc) /100));

    addHistory(remainingDays).then((value) => {
      FirebaseDatabase.instance
          .reference()
          .child('ActiveMembership')
          .child(user.id ?? "")
          .update({
        // 'amount': memberships[choosenPlan].discount != null &&
        //     DateTime.now().compareTo(memberships[choosenPlan].discountValidTill ?? DateTime.now()) < 0
        //     ? memberships[choosenPlan].price ?? 0 * (1 - (memberships[choosenPlan].discount ?? 0) / 100) *
        //     100
        //     : (memberships[choosenPlan].price ?? 0) * 100,
        'amount': tempCalc,
        'DateOfPerchase': DateTime.now().toIso8601String(),
        'ValidTill': DateTime.now()
            .add(Duration(
            days: 30 * (memberships[choosenPlan].months ?? 0) + remainingDays))
            .toIso8601String(),
        'email': user.email,
        'imageUrl': user.imageUrl,
        'name': user.name,
        'packageId': memberships[choosenPlan].id,
        'packageName': memberships[choosenPlan].name,
        'phone': user.phone,
        'srId': user.srId,
        'status': 'Current',
        'contacts': (memberships[choosenPlan].contacts ?? 0) + value
      }).then((value) {
        sendPushNotificationToAdmin("User Subscribed",
            "${user.name} bought subscription for ${memberships[choosenPlan].name}",
            target: Constants.ADMIN_GOT_SUBSCRIPTION,
            userId: FirebaseAuth.instance.currentUser!.uid);
        planWithContactMethod();
        showSuccessAlert();
      })
    });
  }

  planWithContactMethod() async{
    print("Test data");
    DateTime now = DateTime.now();
    DateTime future = DateTime.now().add(Duration(days: 30 * (memberships[choosenPlan].months?.toInt() ?? 1)));
    print("${now.toIso8601String()}");
    print("${future.toIso8601String()}");
    var uuid = Uuid();
    // print("${uuid.v1()}");
    final checkData = await FirebaseDatabase.instance
        .reference()
        .child('PlanWithContactView').child(FirebaseAuth.instance.currentUser!.uid)
        .orderByChild("activePlan").equalTo(true).once();

    if(checkData.snapshot.value != null ) {
      Map fdata = checkData.snapshot.value as Map;
      print("checkData====>>>${fdata}");

      if(fdata != null && fdata.isNotEmpty) {
        fdata.forEach((key, value) {
          FirebaseDatabase.instance.reference()
              .child('PlanWithContactView').child(FirebaseAuth.instance.currentUser!.uid).
          child(key).update({"activePlan":false});
        });
      }
    }

    await FirebaseDatabase.instance
        .reference()
        .child('PlanWithContactView')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("${memberships[choosenPlan].name}_${uuid.v1()}").
       update({"activePlan": true,"plan_name": memberships[choosenPlan].name,
      "start_date": now.toIso8601String(),"end_date": future.toIso8601String(),
      "contact_view":[],"total_contact": memberships[choosenPlan].contacts});
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'An error occured : ${response.message}');
    // tempSuccessApiCall();
  }

  showSuccessAlert() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                content: Container(
                  width: MediaQuery.of(context).size.width * .6,
                  height: MediaQuery.of(context).size.height * .26,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .3,
                        child: Image.asset(
                          'assets/success.gif',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        'Whoo hoo',
                        style: GoogleFonts.workSans(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'You are now our premium member',
                        style: GoogleFonts.workSans(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                actions: [
                  MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen(isRedirectingFromLogin: false)));
                      },
                      child: Text('OK'))
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              );
            }));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}
  @override
  void dispose() {
    _razorpay.clear();
    listener.cancel();
    super.dispose();
  }

//rzp_live_jskiitqsc263u8

  getOptions() {

    var tempCalc = memberships[choosenPlan].discount != null &&
        DateTime.now().compareTo(memberships[choosenPlan].discountValidTill ?? DateTime.now()) <
            0
        ? ((memberships[choosenPlan].price ?? 0) -
        (memberships[choosenPlan].price ?? 0) *
            (memberships[choosenPlan].discount ?? 0) / 100)
        : (memberships[choosenPlan].price ?? 0);



    tempCalc = (((tempCalc) - (oldUserDiscPercen) * (tempCalc) /100));


    var options = {
      'key': 'rzp_live_j9e3PmqtSyYn7A',
      'amount': tempCalc * 100,
      'name': user.name,
      'description': 'You are paying to Sunhare Rishtey',
      'prefill': {'contact': user.phone, 'email': user.email}
    };
    return options;
  }

  getOfferBanner() async {
    final ref = FirebaseStorage.instance.ref().child('offerBanner.png');
    bannerURL = await ref.getDownloadURL();
    setState(() {});
  }

  openPayment() {
    _razorpay.open(getOptions());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorCompanion,
        title: Text(
          "Plans",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: (height < 850.0)
              ? EdgeInsets.only(bottom: 0)
              : EdgeInsets.only(bottom: 72),
          child: Stack(
            children: [
              Container(
                height: height * 0.4,
                color: theme.colorCompanion,
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 0),
                    constraints: BoxConstraints(minHeight: 260),
                    color: theme.colorCompanion,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        bannerURL != ''
                            ? CachedNetworkImage(imageUrl: bannerURL)
                            : Positioned(
                                top: 100,
                                child: SpinKitThreeBounce(color: Colors.white)),
                        Container(
                          height: 18,
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          alignment: Alignment.center,
                          child: ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                itemCount: memberships.length,
                                itemBuilder: (context, index) {
                                  return indicator(
                                      selected: choosenPlan == index,
                                      inActiveColor: theme.colorCompanion);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: height * 0.25,
                        color: theme.colorCompanion,
                      ),
                      AnimatedOpacity(
                        opacity: opacityLevel,
                        duration: const Duration(milliseconds: 500),
                        child: CarouselSlider(
                          carouselController: _carouselController,
                          // customScale: 0.96,
                          options: CarouselOptions(
                              height: height * 0.66,
                              viewportFraction: 0.82,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              initialPage: choosenPlan,
                              onPageChanged: (index, reason) {
                                choosenPlan = index;
                                setState(() {});
                              }),
                          items: memberships.map((item) {
                            bool isDiscounted = (DateTime.now().compareTo(item.discountValidTill ?? DateTime.now()) <=
                                0);
                            return Builder(
                              builder: (BuildContext context) {

                                var discountedPrice0 = ((item.price!) - (item.discount!) * (item.price!) / 100);
                                var oldUserDiscountedPriceFinal = (((discountedPrice0) - (oldUserDiscPercen) * (discountedPrice0) /100));
                                var disc = ((oldUserDiscountedPriceFinal*100)/item.price!);
                                var finalDesc = 100-disc;
                                return Column(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: theme.colorBackground,
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                234, 234, 234, 1)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        title: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 30),
                                                    Text(
                                                      "${item.name}",
                                                      style: theme.text20bold,
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .verified_user_sharp),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'Can view Mobile number.',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * .01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .verified_user_sharp),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'Can view Email.',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * .01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .verified_user_sharp),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'You will get ${item.contacts} contacts.',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * .01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .verified_user_sharp),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'Can send message to Anyone.',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * .01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .verified_user_sharp),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'Can see whole profile.',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * .01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .verified_user_sharp),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'Validity : ${item.months} Months',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 30),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "₹${item.price}"
                                                              .replaceAll(
                                                                  ".0", ""),
                                                          style: theme.text16bold!.copyWith(
                                                              fontSize: 20,
                                                              color: isDiscounted
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black,
                                                              decoration: isDiscounted
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : TextDecoration
                                                                      .none),
                                                        ),
                                                        SizedBox(width: 6),
                                                        isDiscounted
                                                            ? Column(
                                                                children: [
                                                                  Text(
                                                                    '₹${oldUserDiscountedPriceFinal}'
                                                                        .replaceAll(".0", ""),
                                                                style: GoogleFonts
                                                                        .workSans(
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                    SizedBox(height: 16),
                                                    OutlinedButton(
                                                      style: OutlinedButton.styleFrom(
                                                        backgroundColor: theme.colorPrimary,
                                                        shape:RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                        )
                                                      ),
                                                      /*color: theme.colorPrimary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),*/
                                                      onPressed: () async{
                                                        memberships[choosenPlan].discount != null &&
                                                            DateTime.now().compareTo(memberships[choosenPlan].discountValidTill ?? DateTime.now()) <
                                                                0
                                                            ? debugPrint("11111 ${((memberships[choosenPlan].price ?? 0) -
                                                            (memberships[choosenPlan].price ?? 0) *
                                                                (memberships[choosenPlan].discount ?? 0) / 100) * 100}")
                                                            : debugPrint("222222 ${(memberships[choosenPlan].price ?? 0) * 100}");
                                                         openPayment();


                                                        // print("${memberships[choosenPlan].name}");
                                                        // DateTime now = DateTime.now();
                                                        // DateTime future = DateTime.now().add(Duration(days: 30 * (memberships[choosenPlan].months?.toInt() ?? 1)));
                                                        // print("${now.toIso8601String()}");
                                                        // print("${future.toIso8601String()}");
                                                        // var uuid = Uuid();
                                                        // // print("${uuid.v1()}");
                                                        // final checkData = await FirebaseDatabase.instance
                                                        //     .reference()
                                                        //     .child('PlanWithContactView').child(FirebaseAuth.instance.currentUser!.uid)
                                                        //     .orderByChild("activePlan").equalTo(true).once();
                                                        // Map fdata = checkData.value as Map;
                                                        // print("checkData====>>>${fdata}");
                                                        //
                                                        // if(fdata != null && fdata.isNotEmpty) {
                                                        //   fdata.forEach((key, value) {
                                                        //     FirebaseDatabase.instance.reference()
                                                        //         .child('PlanWithContactView').child(FirebaseAuth.instance.currentUser!.uid).
                                                        //     child(key).update({"activePlan":false});
                                                        //   });
                                                        // }
                                                        //
                                                        // await FirebaseDatabase.instance
                                                        //     .reference()
                                                        //     .child('PlanWithContactView')
                                                        //     .child(FirebaseAuth.instance.currentUser!.uid)
                                                        //     .child("${memberships[choosenPlan].name}_${uuid.v1()}").
                                                        //      update({"activePlan": true,"plan_name": memberships[choosenPlan].name,
                                                        //   "start_date": now.toIso8601String(),"end_date": future.toIso8601String(),
                                                        //   "contact_view":[],"total_contact": memberships[choosenPlan].contacts});
                                                      },
                                                      child: Container(
                                                        width: width * .5,
                                                        height: 50,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          'Continue',
                                                          style: GoogleFonts
                                                              .workSans(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 14),
                                                    // isDiscounted
                                                    //     ? Text(
                                                    //         'Only Till - ${item.discountValidTill!.day}/${item.discountValidTill!.month}/${item.discountValidTill!.year}',
                                                    //         style: GoogleFonts
                                                    //             .workSans(
                                                    //                 color: Colors
                                                    //                     .grey,
                                                    //                 fontWeight:
                                                    //                     FontWeight
                                                    //                         .w600),
                                                    //       )
                                                    //     : Container(),
                                                    // SizedBox(height: 24),
                                                  ]),
                                            ),
                                            isDiscounted
                                                ? Positioned(
                                                    left: -94,
                                                    top: -16,
                                                    child: Transform.rotate(
                                                      angle: -math.pi / 4,
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 24,
                                                                  right: 6),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 60,
                                                          width: 200,
                                                          child: Text(
                                                            // '${item.discount!.toInt()}% OFF',
                                                            '${finalDesc.toStringAsFixed(1)}% OFF',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    8,
                                                                    204,
                                                                    98,
                                                                    1),
                                                          ),
                                                      ),
                                                    ))
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
