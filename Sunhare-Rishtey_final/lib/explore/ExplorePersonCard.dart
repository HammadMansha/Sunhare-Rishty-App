import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/models/LoginScreen.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:matrimonial_app/models/advertisementModel.dart';
import 'package:provider/provider.dart';

class ExplorePersonCard extends StatefulWidget {
  final UserInformation user;
  final int index;
  final AdvertisementModel ad;

  ExplorePersonCard({required this.user, required this.index, required this.ad});

  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<ExplorePersonCard> {
  bool isFavourite = false;
  bool isRequestSent = false;
  bool isOnline = false;
  bool isVisible = true;
  bool isRequestAccepted = false;
  bool isPremium = false;

  navigateToLogin(context) {
    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginOtpScreen()));
  }

  String visibility = "";
  @override
  void initState() {
    visibility = widget.user.visibility ?? 'All Member';

    isVisible = visibility == 'All Member' ||
        (visibility == 'Premium Members only' && isPremium) ||
        (visibility == 'Connected Members' &&
            Provider.of<UserRequestProvider>(context, listen: false)
                .checkConnection(widget.user.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double adWidth = 0;
    double adHeight = 0;
    if (widget.ad.title != null) {
      adWidth = 0.92 * width;
      adHeight = adWidth * (5 / 8);
    }
    return Column(
      children: [
        widget.ad != null
            ? Container(
                height: adHeight,
                width: adWidth,
                decoration: BoxDecoration(
                  color: theme.colorBackground,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: NetworkImage(widget.ad.image ?? "")),
                ),
                child: Container())
            : SizedBox(),
        Padding(
          padding: EdgeInsets.only(
              top: height * .01,
              bottom: height * .01,
              left: width * .04,
              right: width * .04),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: InkWell(
                  onTap: () {
                    navigateToLogin(context);
                  },
                  child: isVisible
                      ? Container(
                          height: height * .63,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.user.imageUrl ?? ""),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                gradient: LinearGradient(
                                    colors: [Colors.black12, Colors.black54],
                                    begin: Alignment.center,
                                    stops: [0.4, 1],
                                    end: Alignment.bottomCenter)),
                            child: Stack(
                              children: [
                                widget.user.isPremium ?? false
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              color: theme.colorPrimary),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(MdiIcons.crown,
                                                    color: Colors.white),
                                                Text('Premium',
                                                    style: GoogleFonts.workSans(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ))
                                    : Container(),
                                Positioned(
                                  right: 25,
                                  top: height * .07,
                                  child: InkWell(
                                    onTap: () {
                                      navigateToLogin(context);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.black45,
                                        ),
                                        child: Icon(MdiIcons.dotsHorizontal,
                                            color: Colors.white, size: 23)),
                                  ),
                                ),
                                Positioned(
                                  right: 20,
                                  top: height * .13,
                                  child: InkWell(
                                    onTap: () {
                                      navigateToLogin(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: isFavourite
                                          ? Icon(MdiIcons.heart,
                                              color: Colors.red, size: 30)
                                          : Icon(MdiIcons.heartOutline,
                                              color: Colors.white, size: 30),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: width * .01,
                                  top: height * .51,
                                  child: Container(
                                    width: width * 0.2,
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: isOnline
                                        ? Row(
                                            children: [
                                              Icon(MdiIcons.circle,
                                                  size: 10,
                                                  color: Colors.green),
                                              Text('Online',
                                                  style: GoogleFonts.workSans(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          )
                                        : Container(),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  left: 20,
                                  bottom: 10,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          verificationPopup(
                                              widget.user.isGovIdVerified ?? false,
                                              widget.user.govVerifiedBy ?? ""
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                              widget.user.name!.toUpperCase() ??
                                                  "",
                                              style: GoogleFonts.ptSans(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text(
                                            widget.user.height ?? '',
                                            style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                          SizedBox(width: width * .03),
                                          Text(
                                              "${calculateAge(widget.user.dateOfBirth ?? "")} yrs",
                                              style: GoogleFonts.ptSans(
                                                  color: Colors.white,
                                                  fontSize: 14)),
                                          SizedBox(width: width * .03),
                                          Container(
                                            width: width * .24,
                                            child: Text(
                                              widget.user.city ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text(
                                            widget.user.highestQualification ??
                                                '',
                                            style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                          SizedBox(width: width * .03),
                                          Text(
                                            widget.user.workingAs ?? '',
                                            style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * .005),
                                      widget.user.employedIn != null &&
                                              widget.user.employedIn != ""
                                          ? Row(
                                              children: [
                                                Text(
                                                  widget.user.employedIn ?? "",
                                                  style: GoogleFonts.ptSans(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                )
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text(
                                            widget.user.maritalStatus ?? '',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          Text(
                                            widget.user.religion ?? '',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : visibility == 'Connected Members'
                          ? Container(
                              height: height * .63,
                              width: width * .92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.user.imageUrl ?? ""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 20, sigmaY: 20),
                                        child: Container()),
                                  ),
                                  Positioned(
                                    top: height * .25,
                                    child: Column(
                                      children: [
                                        Icon(MdiIcons.lock,
                                            color: Colors.white60, size: 50),
                                        SizedBox(height: height * .02),
                                        Text(
                                          'Images will be Visible\nAfter you Connect with Each Other',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        SizedBox(height: height * .02),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height * .63,
                                    width: width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.black12,
                                              Colors.black54
                                            ],
                                            begin: Alignment.center,
                                            stops: [0.4, 1],
                                            end: Alignment.bottomCenter),
                                      ),
                                      child: Stack(
                                        children: [
                                          widget.user.isPremium ?? false
                                              ? Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        color:
                                                            theme.colorPrimary),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(MdiIcons.crown,
                                                              color:
                                                                  Colors.white),
                                                          Text('Premium',
                                                              style: GoogleFonts
                                                                  .workSans(
                                                                      color: Colors
                                                                          .white)),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              : Container(),
                                          Positioned(
                                            right: 25,
                                            top: height * .08,
                                            child: InkWell(
                                              onTap: () {
                                                navigateToLogin(context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.black45,
                                                ),
                                                child: Icon(
                                                    MdiIcons.dotsHorizontal,
                                                    color: Colors.white,
                                                    size: 23),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: width * .01,
                                            top: height * .51,
                                            child: Container(
                                              width: width * 0.2,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: isOnline
                                                  ? Row(
                                                      children: [
                                                        Icon(MdiIcons.circle,
                                                            size: 10,
                                                            color:
                                                                Colors.green),
                                                        Text(
                                                          'Online',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      ],
                                                    )
                                                  : Container() /* Row(
                                                      children: [
                                                        Icon(MdiIcons.circle,
                                                            size: 10,
                                                            color: Colors.red),
                                                        Text('Offline',
                                                            style: GoogleFonts
                                                                .workSans(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                      ],
                                                    ) */
                                              ,
                                            ),
                                          ),
                                          Positioned(
                                            right: 13,
                                            top: height * .15,
                                            child: InkWell(
                                              onTap: () {
                                                navigateToLogin(context);
                                              },
                                              child: Container(
                                                width: width * 0.15,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                                child: isFavourite
                                                    ? Icon(
                                                        MdiIcons.heart,
                                                        color: Colors.red,
                                                        size: 30,
                                                      )
                                                    : Icon(
                                                        MdiIcons.heartOutline,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            left: 20,
                                            bottom: 10,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    verificationPopup (
                                                        widget.user.isGovIdVerified ?? false,
                                                        widget.user.govVerifiedBy ?? ""
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text (
                                                      widget.user.name!.toUpperCase() ?? "",
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height * .005),
                                                Row(
                                                  children: [
                                                    Text(
                                                      widget.user.height ?? '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                      "${calculateAge(widget.user.dateOfBirth ?? "")} yrs",
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                      widget.user.city ?? '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height * .005),
                                                Row(
                                                  children: [
                                                    Text(
                                                      widget.user
                                                              .highestQualification ??
                                                          '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                      widget.user.workingAs ??
                                                          '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height * .005),
                                                Row(
                                                  children: [
                                                    Text(
                                                        widget.user
                                                                .maritalStatus ??
                                                            '',
                                                        style:
                                                            GoogleFonts.ptSans(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14)),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                        widget.user.religion ??
                                                            '',
                                                        style:
                                                            GoogleFonts.ptSans(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: height * .63,
                              width: width * .92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.user.imageUrl ?? ""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 20, sigmaY: 20),
                                      child: Container(),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MdiIcons.lock,
                                        color: Colors.white60,
                                        size: 50,
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      Text(
                                        'To Unlock Photos',
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      isPremium
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                navigateToLogin(context);
                                              },
                                              child: Center(
                                                child: Container(
                                                  width: width * .45,
                                                  height: height * .053,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: theme.colorPrimary,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Go Premium Now',
                                                    style: GoogleFonts.ptSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme.colorPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 25,
                                    top: height * .07,
                                    child: InkWell(
                                      onTap: () {
                                        navigateToLogin(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          color: Colors.black45,
                                        ),
                                        child: Icon(
                                          MdiIcons.dotsHorizontal,
                                          color: Colors.white,
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    top: height * .13,
                                    child: InkWell(
                                      onTap: () {
                                        navigateToLogin(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        child: isFavourite
                                            ? Icon(
                                                MdiIcons.heart,
                                                color: Colors.red,
                                                size: 30,
                                              )
                                            : Icon(
                                                MdiIcons.heartOutline,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: width * .01,
                                    top: height * .51,
                                    child: Container(
                                      width: width * 0.2,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: isOnline
                                          ? Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.circle,
                                                  size: 10,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  'Online',
                                                  style: GoogleFonts.workSans(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container() /* Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.circle,
                                                  size: 10,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  'Offline',
                                                  style: GoogleFonts.workSans(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ) */
                                      ,
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    left: 20,
                                    bottom: 10,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            verificationPopup(
                                                widget.user.isGovIdVerified ?? false,
                                                widget.user.govVerifiedBy ?? ""),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.user.name!.toUpperCase() ??
                                                  "",
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * .005,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.user.height ?? '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),
                                            Text(
                                              "${calculateAge(widget.user.dateOfBirth ?? "")} yrs",
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),
                                            Text(
                                              widget.user.city ?? '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * .005,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.user
                                                      .highestQualification ??
                                                  '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),
                                            Text(
                                              widget.user.workingAs ?? '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * .005,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.user.maritalStatus ?? '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),
                                            Text(
                                              widget.user.religion ?? '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: theme.colorPrimary),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          navigateToLogin(context);
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
                          navigateToLogin(context);
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
                            navigateToLogin(context);
                          },
                          child: Container(
                              width: width * .2,
                              child: Column(children: [
                                Icon(MdiIcons.phone, color: Colors.red),
                                SizedBox(height: 4),
                                Text('Phone')
                              ]))),
                      InkWell(
                        onTap: () {
                          navigateToLogin(context);
                        },
                        child: Container(
                          width: width * .25,
                          child: Column(
                            children: [
                              Transform.rotate(
                                angle: 95,
                                child: Icon(
                                  isRequestSent
                                      ? MdiIcons.navigation
                                      : MdiIcons.navigationOutline,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              isRequestSent
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: width * 25,
                                      child: Text('Sent'),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      width: width * .25,
                                      child: Text('Send Request'),
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

PopupMenuButton verificationPopup(bool isGovIdVerified, String govVerifiedBy) {
  isGovIdVerified = isGovIdVerified ?? false;
  return PopupMenuButton(
      padding: EdgeInsets.only(left: 4, right: 10),
      iconSize: 34,
      color: Colors.black,
      offset: Offset(12, isGovIdVerified ? -60 : -44),
      icon: Image.asset(
        isGovIdVerified ? 'assets/govVerifycheck.png' : 'assets/verified.png',
        fit: BoxFit.contain,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            height: 30,
            child: Column(
              children: [
                isGovIdVerified && govVerifiedBy != null
                    ? Row(
                        children: [
                          Icon(
                            Icons.check_rounded,
                            color: Colors.green,
                            size: 22.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            govVerifiedBy + " verified",
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 22.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Mobile Number verified",
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ];
      });
}
