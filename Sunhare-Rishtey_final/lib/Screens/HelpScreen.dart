import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  contactAdminWhatsapp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+919634395495',
      text: "Hey! I'm inquiring about SUNHARE Rishtey",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
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
            "Help & Support",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .025,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                    // vertical: 10,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.tealAccent[100],
                    border: Border.all(
                      width: 1.5,
                      color: Colors.teal,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    onTap: () {
                      contactAdminWhatsapp();
                    },
                    child: Text(
                      'Whatsapp Number : +91-9634395495',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Container(
                width: width,
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  // vertical: 10,
                ),
                child: Text(
                  'Commonly Asked Questions !',
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * .015,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  // vertical: 20,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                width: width,
                height: height * .7,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: width,
                          child: Text(
                            'Q. What to do if I need help?',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: width,
                          child: Text(
                            'A. Click on Above whatsapp number.',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Divider(
                          height: 22,
                          thickness: 1,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
