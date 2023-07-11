import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Screens/ViewProfileScreen.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/models/primiumModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Providers/allUser.dart';
import '../Providers/ContactsProvider.dart';
import '/Providers/getUserInfo.dart';
import '/models/UserModel.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import 'SocialMediaChatRoom.dart';

class ContactsViewedScreen extends StatefulWidget {
  @override
  _ContactsViewedScreenState createState() => _ContactsViewedScreenState();
}

class _ContactsViewedScreenState extends State<ContactsViewedScreen> {
  List<String> contacts = [];
  List<UserInformation> viewedUsers = [];
  UserInformation currUser = UserInformation();
  List<String> packagename = [];
  Map planWithContactData = {};
  List<PremiumNewModel> premiumNewModelList =[];

  @override
  void initState() {
    getDataPlanWithContactView();
    currUser = Provider.of<CurrUserInfo>(context, listen: false).currentUser;

    contacts = Provider.of<ContactProvider>(context, listen: false).contacts;

    print("contacts is===>>>iuhyhujgb hjbhj>${contacts}");

    Provider.of<AllUser>(context, listen: false).allUsers.forEach((element) {
      if (contacts.contains(element.id)) {
        viewedUsers.add(element);
      }
    });
    super.initState();
  }

  getDataPlanWithContactView() async{
    final getUserData = await FirebaseDatabase.instance
        .reference()
        .child('PlanWithContactView')
        .child(FirebaseAuth.instance.currentUser!.uid).once();

    if(getUserData.snapshot.value != null) {

      planWithContactData = getUserData.snapshot.value as Map;

      planWithContactData.forEach((key, value) {

        PremiumNewModel premiumNewModel = PremiumNewModel();
        premiumNewModel.planName = value['plan_name'] ?? "";
        premiumNewModel.endDate = value['end_date'] ?? "";
        premiumNewModel.startDate = value['start_date'] ?? "";
        premiumNewModel.totalContact = value['total_contact'] ?? 0;
        premiumNewModel.activeStatus = value['activePlan'] ?? false;

        List<Object?> tempData = value['contact_view'] ?? [];
        print(tempData.runtimeType);

        premiumNewModel.contactViewed = [];
        tempData.forEach((element) {
          premiumNewModel.contactViewed?.add(element.toString() ?? "");
        });

        premiumNewModel.userInfoData = [];
        List<UserInformation> viewedUsersNew = [];

        if(premiumNewModel.contactViewed != null && premiumNewModel.contactViewed!.isNotEmpty) {
          Provider.of<AllUser>(context, listen: false).allUsers.forEach((element) {
            if ((premiumNewModel.contactViewed??[]).contains(element.id)) {
              viewedUsersNew.add(element);
            }
          });
          premiumNewModel.userInfoData?.clear();
          for(var i=0; i<viewedUsersNew.length; i++){
            print("viewedUsersNew--->>>${viewedUsersNew[i].name}");
          }
          premiumNewModel.userInfoData?.addAll(viewedUsersNew);
        }
        premiumNewModelList.add(premiumNewModel);
      });
      int oo = 0;
      premiumNewModelList.forEach((element) {
        if(element.activeStatus ?? false){
          PremiumNewModel tempData = element;
          premiumNewModelList.removeAt(oo);
          premiumNewModelList.insert(0, tempData);
        }
        oo++;
      });
      setState(() {});
      print("data length===>>${planWithContactData.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorCompanion,
          title: Text(
            'Contacts',
            style: GoogleFonts.karla(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: premiumNewModelList.isEmpty
            ? Container (
                height: height - 100,
                alignment: Alignment.center,
                child: Text("No contacts viewed."),
              )
            : ListView.builder(
              itemCount: premiumNewModelList.length,
              shrinkWrap: true,
              itemBuilder: (context,index) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          SizedBox(width: width * .05),
                          Text(
                            premiumNewModelList[index].planName ?? "",
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          premiumNewModelList[index].activeStatus ?? false ? Container (
                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  HexColor('20bf55'),
                                  HexColor('01baef'),
                                ],
                              ),
                            ),
                            child: Text(
                              'Active',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 18),
                            child: Text(
                              // 'Start Date : ${premiumNewModelList[index].startDate ?? ""}',
                              'Start Date : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(premiumNewModelList[index].startDate ?? ""))}',
                              // 'Start Date : ${currUser.premiumModel!.dateOfPerchase!.day}/${currUser.premiumModel!.dateOfPerchase!.month}/${currUser.premiumModel!.dateOfPerchase!.year}',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              '|',
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text (
                              // 'Expiry :${premiumNewModelList[index].endDate}',
                              'Expiry : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(premiumNewModelList[index].endDate ?? ""))}',
                              // 'Expiry :${currUser.premiumModel!.validTill!.day}/${currUser.premiumModel!.validTill!.month}/${currUser.premiumModel!.validTill!.year}',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1.4,
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          'Contacts Viewed By You ('
                              '${premiumNewModelList[index].contactViewed?.length ?? 0}/${premiumNewModelList[index].totalContact})',
                          style: GoogleFonts.openSans(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: height * .01),
                      Container (
                        width: width,
                        // height: height * .7,
                        margin: EdgeInsets.only(bottom: 30),
                        child: ListView.builder (
                          itemCount: premiumNewModelList[index].userInfoData?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index1) {
                            return InkWell (
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewProfileScreen(
                                        premiumNewModelList[index].userInfoData, index1, true)));
                              },
                              child: Card(
                                elevation: 10,
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 6,
                                ),
                                child: Padding(
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
                                            width: width * .1,
                                            height: height * .08,
                                            child: Image.network(
                                                premiumNewModelList[index].userInfoData![index1].imageUrl ?? "",
                                                scale: 8),
                                          ),
                                          SizedBox(
                                            width: width * .05,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: height * .005,
                                              ),
                                              Container(
                                                width: width * .65,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      premiumNewModelList[index].userInfoData![index1].name ?? "",
                                                      style: GoogleFonts.openSans(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Phone ',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    premiumNewModelList[index].userInfoData![index1].phone ?? "",
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * .002,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Email: ',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    premiumNewModelList[index].userInfoData![index1].email ?? "",
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 13,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        height: height * .08,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SocialMediaChat(
                                                        uid:
                                                        premiumNewModelList[index].userInfoData![index1].id ?? "",
                                                        data: premiumNewModelList[index].userInfoData![index1],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: width * .2,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        MdiIcons.chat,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text('Chat')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  launchWhatsApp(
                                                      premiumNewModelList[index].userInfoData![index1].phone ?? "",
                                                      currUser);
                                                },
                                                child: Container(
                                                  width: width * .2,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        MdiIcons.whatsapp,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text('WhatsApp')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(),
                                              InkWell(
                                                onTap: () {
                                                  launch(
                                                      "tel://${premiumNewModelList[index].userInfoData![index1].phone}");
                                                },
                                                child: Container(
                                                  width: width * .2,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        MdiIcons.phone,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text('Phone')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
              }
            ),
        // body: SingleChildScrollView(
        //   physics: NeverScrollableScrollPhysics(),
        //   child: currUser.premiumModel!.packageName == null ||
        //           contacts.length == 0
        //       ? Container(
        //           height: height - 100,
        //           alignment: Alignment.center,
        //           child: Text("No contacts viewed."),
        //         )
        //       : Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             SizedBox(
        //               height: height * .01,
        //             ),
        //             Row(
        //               children: [
        //                 SizedBox(
        //                   width: width * .05,
        //                 ),
        //                 Text(
        //                   currUser.premiumModel!.packageName ?? "",
        //                   style: GoogleFonts.openSans(
        //                     fontSize: 18,
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //                 ),
        //                 Container(
        //                   padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        //                   margin: EdgeInsets.symmetric(horizontal: 5),
        //                   decoration: BoxDecoration(
        //                     // border: Border.all(),
        //                     borderRadius: BorderRadius.circular(10),
        //                     gradient: LinearGradient(
        //                       begin: Alignment.centerLeft,
        //                       end: Alignment.centerRight,
        //                       colors: [
        //                         HexColor('20bf55'),
        //                         HexColor('01baef'),
        //                       ],
        //                     ),
        //                   ),
        //                   child: Text(
        //                     'Active',
        //                     style: GoogleFonts.lato(
        //                       color: Colors.white,
        //                       fontSize: 13,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(
        //               height: height * .02,
        //             ),
        //             Row(
        //               children: [
        //                 Container(
        //                   margin: EdgeInsets.only(left: 18),
        //                   child: Text(
        //                     'Start Date : ${currUser.premiumModel!.dateOfPerchase!.day}/${currUser.premiumModel!.dateOfPerchase!.month}/${currUser.premiumModel!.dateOfPerchase!.year}',
        //                     style: GoogleFonts.openSans(
        //                       fontSize: 14,
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   margin: EdgeInsets.only(left: 5),
        //                   child: Text(
        //                     '|',
        //                     style: GoogleFonts.openSans(
        //                       fontSize: 15,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   margin: EdgeInsets.only(left: 5),
        //                   child: Text(
        //                     'Expiry :${currUser.premiumModel!.validTill!.day}/${currUser.premiumModel!.validTill!.month}/${currUser.premiumModel!.validTill!.year}',
        //                     style: GoogleFonts.openSans(
        //                       fontSize: 14,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             Divider(
        //               thickness: 1.4,
        //             ),
        //             SizedBox(
        //               height: height * .02,
        //             ),
        //             Container(
        //               margin: EdgeInsets.only(left: 15),
        //               child: Text(
        //                 'Contacts Viewed By You (${contacts.length}/${currUser.premiumModel!.contact})',
        //                 style: GoogleFonts.openSans(
        //                   fontSize: 17,
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               height: height * .01,
        //             ),
        //             Container(
        //               width: width,
        //               height: height * .7,
        //               child: ListView.builder(
        //                 itemCount: viewedUsers.length,
        //                 itemBuilder: (context, index) {
        //                   return InkWell(
        //                     onTap: () {
        //                       Navigator.of(context).push(MaterialPageRoute(
        //                           builder: (context) => ViewProfileScreen(
        //                               viewedUsers, index, true)));
        //                     },
        //                     child: Card(
        //                       elevation: 10,
        //                       color: Colors.white,
        //                       margin: EdgeInsets.symmetric(
        //                         horizontal: 7,
        //                         vertical: 6,
        //                       ),
        //                       child: Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                           vertical: 8,
        //                         ),
        //                         child: Column(
        //                           children: [
        //                             Row(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 SizedBox(
        //                                   width: width * .03,
        //                                 ),
        //                                 Container(
        //                                   width: width * .1,
        //                                   height: height * .08,
        //                                   child: Image.network(
        //                                       viewedUsers[index].imageUrl ?? "",
        //                                       scale: 8),
        //                                 ),
        //                                 SizedBox(
        //                                   width: width * .05,
        //                                 ),
        //                                 Column(
        //                                   mainAxisAlignment:
        //                                       MainAxisAlignment.center,
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: [
        //                                     SizedBox(
        //                                       height: height * .005,
        //                                     ),
        //                                     Container(
        //                                       width: width * .65,
        //                                       child: Row(
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment
        //                                                 .spaceBetween,
        //                                         children: [
        //                                           Text(
        //                                             viewedUsers[index].name ?? "",
        //                                             style: GoogleFonts.openSans(
        //                                               fontSize: 16,
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                             ),
        //                                           ),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         Text(
        //                                           'Phone ',
        //                                           style: GoogleFonts.openSans(
        //                                             fontSize: 13,
        //                                           ),
        //                                         ),
        //                                         Text(
        //                                           viewedUsers[index].phone ?? "",
        //                                           style: GoogleFonts.openSans(
        //                                             fontSize: 13,
        //                                           ),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                     SizedBox(
        //                                       height: height * .002,
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         Text(
        //                                           'Email: ',
        //                                           style: GoogleFonts.openSans(
        //                                             fontSize: 13,
        //                                           ),
        //                                         ),
        //                                         Text(
        //                                           viewedUsers[index].email ?? "",
        //                                           style: GoogleFonts.openSans(
        //                                             fontSize: 13,
        //                                           ),
        //                                         )
        //                                       ],
        //                                     )
        //                                   ],
        //                                 ),
        //                               ],
        //                             ),
        //                             Container(
        //                               decoration: BoxDecoration(
        //                                 borderRadius: BorderRadius.only(
        //                                   bottomLeft: Radius.circular(10),
        //                                   bottomRight: Radius.circular(10),
        //                                 ),
        //                               ),
        //                               height: height * .08,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.all(5),
        //                                 child: Row(
        //                                   mainAxisAlignment:
        //                                       MainAxisAlignment.spaceEvenly,
        //                                   children: [
        //                                     InkWell(
        //                                       onTap: () {
        //                                         Navigator.of(context).push(
        //                                           MaterialPageRoute(
        //                                             builder: (context) =>
        //                                                 SocialMediaChat(
        //                                               uid:
        //                                                   viewedUsers[index].id ?? "",
        //                                               data: viewedUsers[index],
        //                                             ),
        //                                           ),
        //                                         );
        //                                       },
        //                                       child: Container(
        //                                         width: width * .2,
        //                                         child: Column(
        //                                           children: [
        //                                             Icon(
        //                                               MdiIcons.chat,
        //                                               color: Colors.red,
        //                                             ),
        //                                             SizedBox(
        //                                               height: 4,
        //                                             ),
        //                                             Text('Chat')
        //                                           ],
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     InkWell(
        //                                       onTap: () {
        //                                         launchWhatsApp(
        //                                             viewedUsers[index].phone ?? "",
        //                                             currUser);
        //                                       },
        //                                       child: Container(
        //                                         width: width * .2,
        //                                         child: Column(
        //                                           children: [
        //                                             Icon(
        //                                               MdiIcons.whatsapp,
        //                                               color: Colors.red,
        //                                             ),
        //                                             SizedBox(
        //                                               height: 4,
        //                                             ),
        //                                             Text('WhatsApp')
        //                                           ],
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     SizedBox(),
        //                                     InkWell(
        //                                       onTap: () {
        //                                         launch(
        //                                             "tel://${viewedUsers[index].phone}");
        //                                       },
        //                                       child: Container(
        //                                         width: width * .2,
        //                                         child: Column(
        //                                           children: [
        //                                             Icon(
        //                                               MdiIcons.phone,
        //                                               color: Colors.red,
        //                                             ),
        //                                             SizedBox(
        //                                               height: 4,
        //                                             ),
        //                                             Text('Phone')
        //                                           ],
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        // ),
      ),
    );
  }
}
