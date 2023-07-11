import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import '../main.dart';

var width;

// ignore: must_be_immutable
class ShareUserScreen extends StatefulWidget {
  final UserInformation user;

  ShareUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ShareUserScreenState createState() => _ShareUserScreenState();
}

class _ShareUserScreenState extends State<ShareUserScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  bool isLoading = false;
  bool forceShow = false;
  @override
  Widget build(BuildContext context) {
    var visibility = widget.user.visibility ?? 'All Member';
    bool blurr = (visibility == 'All Member' ||
                (visibility == 'Premium Members only' &&
                    (widget.user.isPremium ?? false))) &&
            !forceShow ||
        !forceShow;

    width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Share User"),
          backgroundColor: Color.fromRGBO(255, 21, 87, 0),
        ),
        backgroundColor: Colors.black,
        body: isLoading
            ? SpinKitThreeBounce(
                color: theme.colorPrimary,
              )
            : Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: ShareScreenContainer(user: widget.user, blurr: blurr),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FloatingActionButton(
                        child: Icon(MdiIcons.share),
                        backgroundColor: Color.fromRGBO(255, 21, 87, 1),
                        onPressed: () async {
                          setState(() {
                            this.isLoading = true;
                          });
                          final image = await screenshotController
                              .captureFromWidget(ShareScreenContainer(
                                  user: widget.user, blurr: blurr));
                          saveAndShare(image);
                        },
                      ),
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OutlinedButton(
                        // color: theme.colorPrimary,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: theme.colorPrimary,
                          shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                             ),
                        ),
                        child: Text(
                          blurr ? "Show Image" : "Hide Image",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          setState(() {
                            this.forceShow = !this.forceShow;
                          });
                        },
                      ),
                    ))
              ]));
  }

  Future saveAndShare(Uint8List image) async {
    final directory = (await getExternalStorageDirectory())!.path;
    File imgFile = new File('$directory/share.png');
    print(imgFile.path);
    imgFile.writeAsBytes(image);
    setState(() {
      this.isLoading = false;
    });
    await Share.shareFiles(['$directory/share.png'],
        text:
            'Find the best match for you . https://play.google.com/store/apps/details?id=com.sunhare.rishtey',
        subject: 'Sunhare Rhistey.. click on the link to download');
  }
}

class ShareScreenContainer extends StatelessWidget {
  final UserInformation user;
  final bool blurr;

  ShareScreenContainer({Key? key, required this.user, required this.blurr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.black,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image(image: AssetImage("assets/shareBG.jpg")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.64 - 8,
                      margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("● Profile id: " + user.srId!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            SizedBox(
                              width: 230,
                              child: Text(
                                "● Name: " + user.name!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            SizedBox(
                              width: 230,
                              child: Text(
                                "● Occupation: " + user.workingAs!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            Text("● Income: " + user.annualIncome!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            Text(
                                "● Employed In: " +
                                    user.employedIn!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            Text(
                                "● Education: " +
                                    user.highestQualification!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            SizedBox(
                              width: 230,
                              child: Text(
                                "● College: " +
                                    user.collegeAttended!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            Text(
                                "● Birth Date: " +
                                    user.dateOfBirth!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            Text("● Height: " + user.height!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            Text("● Manglik: " + user.manglik!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            SizedBox(
                              width: 230,
                              child: Text(
                                "● Marital Status: " +
                                    user.maritalStatus!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            Text(
                                "● City of birth: " +
                                    user.cityOfBirth!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            Text("● Current city: " + user.city!.toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            SizedBox(
                              width: 230,
                              child: Text(
                                "● Contact details:\n     DOWNLOAD SUNHARE Rishtey App.",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            )
                          ]),
                    ),
                    Container(
                      width: width * 0.36 - 12,
                      margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black,
                            ),
                          ]),
                      // BackdropFilter(
                      //     filter: ImageFilter.blur(
                      //         sigmaX: 20, sigmaY: 20),
                      //     child: Container()),
                      child: ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                              sigmaX: blurr ? 10 : 0, sigmaY: blurr ? 10 : 0),
                          child: Image.network(
                            user.imageUrl ?? "",
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 60, 0),
                  child: Image(
                      image: AssetImage("assets/share_waterMark.png"),
                      height: 350,
                      width: 350,
                      fit: BoxFit.cover),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
