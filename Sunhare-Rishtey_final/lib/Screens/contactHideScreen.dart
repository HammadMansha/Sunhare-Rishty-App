import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:matrimonial_app/models/primiumModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/main.dart';

class ContactHideScreen extends StatefulWidget {
  @override
  _ContactHideScreenState createState() => _ContactHideScreenState();
}

class _ContactHideScreenState extends State<ContactHideScreen> {
  bool hide = false;
  String lastDate = "";
  UserInformation userinfo = UserInformation();
  int selectedIndex = 1;

  showAlertDialog(BuildContext context, bool val) async {
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () async{

          if (userinfo.isPremium == false) {
            Navigator.of(context).pop();
          }else{
            DateTime currentDate = DateTime.now();
            late  DateTime endDate;
            if(selectedIndex == 1){
              endDate = currentDate.add(const Duration(days: 7));
              await prefs.setInt('hidemobdaysnumber', 7);
            }else if(selectedIndex == 2){
              endDate = currentDate.add(const Duration(days: 14));
              await prefs.setInt('hidemobdaysnumber', 14);
            }else if(selectedIndex == 3){
              endDate = currentDate.add(const Duration(days: 30));
              await prefs.setInt('hidemobdaysnumber', 30);
            }

            DateFormat formatter = DateFormat('yyyy-MM-dd');

            PremiumModel getMembershipExpireDateData = await getExpireActivePlan();
            if(endDate.isBefore(getMembershipExpireDateData.validTill!) == false){
              endDate = getMembershipExpireDateData.validTill!;
            }
            String finalEndDate = formatter.format(endDate);
            FirebaseDatabase.instance
                .reference()
                .child('User Information')
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child('hideMobile')
                .update({'mobile': val, 'expireDate': finalEndDate});

            Navigator.of(context).pop();
          }

      },
    );

    if(val == false){
      await prefs.setInt('hidemobdaysnumber', 0);
      DateTime endDate = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String finalEndDate = formatter.format(endDate);

      FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('hideMobile')
          .update({'mobile': val, 'expireDate': finalEndDate});
      return;
    }


    if (userinfo.isPremium == false) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Please purchase membership to use this features."),
            actions: [
              okButton,
            ],
          );
        },
      );

    } else {

      showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            content: StatefulBuilder(
              builder: (context,StateSetter setState1) {
                return Container(
                  height: 130,
                  child: Column(
                    children: [
                      Text(
                        'Select Option for hide contact',
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 15,),
                      commonRadioChip('Hide for 1 Week', 1,selectedIndex,() {
                        selectedIndex = 1;
                        setState1(() {});
                      }),
                      commonRadioChip('Hide for 2 Week', 2,selectedIndex,() {
                        selectedIndex = 2;
                        setState1(() {});
                      }),
                      commonRadioChip('Hide for 1 Month', 3,selectedIndex,() {
                        selectedIndex = 3;
                        setState1(() {});
                      },)
                    ],
                  ),
                );
              }
            ),
            actions: [
              okButton,
            ],
          );
        },
      );

    }
  }

  contactHideScreen() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideMobile')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        hide = data['mobile'];
        lastDate = data['expireDate'];

        String tempTodayDate = DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
        DateTime tempDate = new DateFormat("dd-MM-yyyy hh:mm:ss").parse(tempTodayDate);
        DateTime firebaseDate = DateTime.parse("${lastDate} 00:00:00");

        var difference = firebaseDate.difference(tempDate).inDays;

        if(difference > 0){
          hide = true;
        }else{
          hide = false;
        }

        setState(() {});
      }
    });
  }

  Widget commonRadioChip(String title, int index,int tempSelectedIndex,Function ()onclick){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: InkWell(
        onTap: (){
          onclick();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            Container(
              height: 20,width: 20,decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2,color: Colors.red),
            ),
            child: Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tempSelectedIndex == index ? Colors.red : Colors.transparent
            ),),)
          ],
        ),
      ),
    );
  }


  Future<PremiumModel> getExpireActivePlan() async{
    final premi = await FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    Map tempData = premi.snapshot.value as Map;
    PremiumModel premiumValues;

    if (tempData != null && tempData.isNotEmpty) {
      DateTime validTill2 = DateTime.parse(
          "${tempData['ValidTill'].split('T')[0]} 00:00:00.000");
      validTill2 = validTill2.add(Duration(days: 1));

      premiumValues = PremiumModel(
          dateOfPerchase: DateTime.parse(tempData['DateOfPerchase']),
          validTill: DateTime.parse(tempData['ValidTill']),
          contact: tempData['contacts'],
          name: tempData['name'],
          packageName: tempData['packageName'],
          isActive: tempData['ValidTill'] != null
              ? (validTill2.compareTo(DateTime.now()) > 0)
              : false);
    } else {
      premiumValues = PremiumModel();
    }

    return premiumValues;
  }

  late SharedPreferences prefs;

  @override
  void initState() {
    userinfo = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    contactHideScreen();

    Future.delayed(Duration.zero, () async{
      prefs = await SharedPreferences.getInstance();
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorCompanion,
        title: Text(
          'Hide Mobile No.',
          style: GoogleFonts.lato(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .02,
          ),
          Card(
            elevation: 8,
            margin: EdgeInsets.symmetric(),
            child: Container(
              height: height * .06,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * .1,
                  ),
                  Icon(
                    Icons.calendar_today,
                  ),
                  SizedBox(
                    width: width * .1,
                  ),
                  Text(
                    'Contact ',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: width * .2,
                  ),
                  Switch(
                      value: hide,
                      onChanged: (val) {
                        showAlertDialog(context,val);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
