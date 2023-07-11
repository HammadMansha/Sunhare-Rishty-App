import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:matrimonial_app/models/Membership.dart';
import 'package:provider/provider.dart';

class SubscriptionMemberHistory extends StatefulWidget {
  SubscriptionMemberHistory({Key? key}) : super(key: key);

  @override
  _SubscriptionMemberHistoryState createState() =>
      _SubscriptionMemberHistoryState();
}

class _SubscriptionMemberHistoryState extends State<SubscriptionMemberHistory> {
  UserInformation currUser = UserInformation();
  List<Membership> memberships = [];
  Membership activeMembership = Membership();

  @override
  void initState() {
    super.initState();
    currUser = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    getData();
  }

  bool noMembership = false;
  bool isLoading = true;
  void getData() {
    FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(currUser.id ?? "")
        .once()
        .then((value) {

          Map tempMapData = value.snapshot.value as Map;

      if (tempMapData != null) {
        activeMembership = Membership(
            startTime: DateTime.parse(tempMapData['DateOfPerchase']),
            id: tempMapData['packageId'],
            name: tempMapData['packageName'],
            price: tempMapData["amount"] ?? 0.0,
            discountValidTill: DateTime.parse(tempMapData['ValidTill']));

        if (tempMapData["history"] != null) {
          var data = tempMapData["history"] as Map;
          data.forEach((key, value) {
            memberships.add(Membership(
                price: value["price"] ?? 0.0,
                name: value['planName'],
                discountValidTill: DateTime.parse(
                    value['validTill'] ?? '2021-07-16 15:33:44.343'),
                startTime: DateTime.parse(
                    value['startTime'] ?? '2021-07-16 15:33:44.343'),
                contacts: value['contacts'],
                id: key /* value['packageId'] */));
          });
        }
      } else {
        noMembership = true;
      }
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: theme.colorPrimary,
            title: Text(
              'Subscription History',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w600,
              ),
            )),
        body: isLoading
            ? SpinKitThreeBounce(
                color: theme.colorPrimary,
              )
            : noMembership
                ? Container(
                    height: height - 100,
                    alignment: Alignment.center,
                    child: Text("No membership found."),
                  )
                : Stack(children: [
                    SubscriptionHistoryHeader(
                        width: width,
                        height: height,
                        currUser: currUser,
                        activeMembership: activeMembership),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, height * .19 + 16, 0, 0),
                      child: ListView.builder(
                          itemCount: memberships.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 4),
                              child:
                                  HistoryItem(membership: memberships[index]),
                            );
                          }),
                    ),
                  ]));
  }
}

class SubscriptionHistoryHeader extends StatelessWidget {
  const SubscriptionHistoryHeader(
      {Key? key,
      required this.width,
      required this.height,
      required this.currUser,
      required this.activeMembership})
      : super(key: key);

  final double width;
  final double height;
  final UserInformation currUser;
  final Membership activeMembership;

  String setDateInYYYYMMDD(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return activeMembership != null
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * .03,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: height * .024,
                      ),
                      height: height * .19,
                      width: width * .23,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          currUser.imageUrl ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * .05,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currUser.name ?? "",
                          maxLines: 2,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("ID : " + (currUser.srId ?? ""),
                            style: GoogleFonts.openSans(fontSize: 13)),
                        Text('Mobile : ' + (currUser.phone ?? ""),
                            style: GoogleFonts.openSans(fontSize: 13)),
                        Text('Plan Name : ' + (activeMembership.name ?? ""),
                            style: GoogleFonts.openSans(fontSize: 13)),
                        Text('Price : ' +
                            (activeMembership.price == 0
                                ? "Given by Admin"
                                : (((activeMembership.price ?? 0)).ceil()).toString()),style: GoogleFonts.openSans(fontSize: 13)),
                        Text(
                            'Starting Date : ' +
                                setDateInYYYYMMDD(activeMembership.startTime??DateTime.now()),
                            style: GoogleFonts.openSans(fontSize: 13)),
                        Text(
                            'Valid Till : ' +
                                setDateInYYYYMMDD(activeMembership.discountValidTill ?? DateTime.now()),
                            style: GoogleFonts.openSans(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * .01,
                ),
              ],
            ),
          )
        : Container();
  }
}

class HistoryItem extends StatelessWidget {
  final Membership membership;
  const HistoryItem({Key? key, required this.membership}) : super(key: key);

  String setDateInYYYYMMDD(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Text('Plan Name : ' + (membership.name ?? "")),
              Text('Price : ' +
                  (membership.price == 0
                      ? "Given by Admin"
                      : (((membership.price ?? 0)).ceil()).toString())),
              Text(
                  'Starting Date : ' + setDateInYYYYMMDD(membership.startTime ?? DateTime.now())),
              Text('Valid Till : ' +
                  setDateInYYYYMMDD(membership.discountValidTill ?? DateTime.now())),
            ])),
      ),
    );
  }
}
