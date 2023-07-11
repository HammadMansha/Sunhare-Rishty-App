import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '/main.dart';

class ContactFiltersScreen extends StatefulWidget {
  @override
  _ContactFiltersScreenState createState() => _ContactFiltersScreenState();
}

class _ContactFiltersScreenState extends State<ContactFiltersScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          height: height * .071,
          alignment: Alignment.center,
          color: theme.colorCompanion,
          child: Text(
            'SAVE',
            style: GoogleFonts.openSans(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text(
            'Contact Filters',
            style: GoogleFonts.lato(),
          ),
          backgroundColor: theme.colorCompanion,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                height: height * .075,
                color: Colors.black12,
                alignment: Alignment.center,
                child: Text(
                  'Requests from members who do not meet the following criteria will be filtered out.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(fontSize: 16),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width,
                child: Text(
                  'Age :',
                  style: GoogleFonts.ptSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      'Min',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: width * .05,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      height: height * .05,
                      width: width * .2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                        cursorColor: theme.colorCompanion,
                        decoration: InputDecoration(
                          hintText: '00 yrs',
                          hintStyle: GoogleFonts.ptSans(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorCompanion,
                            ),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * .15,
                    ),
                    Text(
                      'Max',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: width * .05,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      height: height * .05,
                      width: width * .2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                        cursorColor: theme.colorCompanion,
                        decoration: InputDecoration(
                          hintText: '00 yrs',
                          hintStyle: GoogleFonts.ptSans(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorCompanion,
                            ),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width,
                child: Text(
                  'Height :',
                  style: GoogleFonts.ptSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      'Min',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: width * .05,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      height: height * .05,
                      width: width * .2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                        cursorColor: theme.colorCompanion,
                        decoration: InputDecoration(
                          hintText: '0\'0"',
                          hintStyle: GoogleFonts.ptSans(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorCompanion,
                            ),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * .15,
                    ),
                    Text(
                      'Max',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: width * .05,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      height: height * .05,
                      width: width * .2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                        cursorColor: theme.colorCompanion,
                        decoration: InputDecoration(
                          hintText: '0\'0"',
                          hintStyle: GoogleFonts.ptSans(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorCompanion,
                            ),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width,
                child: Text(
                  'Marital Status',
                  style: GoogleFonts.ptSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Never Married',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        MdiIcons.chevronRight,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 27,
                  thickness: 1.3,
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width,
                child: Text(
                  'Religion',
                  style: GoogleFonts.ptSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Default',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        MdiIcons.chevronRight,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 27,
                  thickness: 1.3,
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width,
                child: Text(
                  'Community',
                  style: GoogleFonts.ptSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Default',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        MdiIcons.chevronRight,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 27,
                  thickness: 1.3,
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width,
                child: Text(
                  'Mother Tongue',
                  style: GoogleFonts.ptSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Default',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        MdiIcons.chevronRight,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 27,
                  thickness: 1.3,
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: width,
                child: Text(
                  'Community',
                  style: GoogleFonts.ptSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Default',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        MdiIcons.chevronRight,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 27,
                  thickness: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
