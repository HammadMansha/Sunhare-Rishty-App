import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Screens/ContactsViewedScreen.dart';
import 'package:matrimonial_app/Screens/PremiumPlanScreen.dart';

import '../main.dart';
import 'SubcriptionMemberHistory.dart';

class MySubscriptionsScreen extends StatefulWidget {
  @override
  _MySubscriptionsScreenState createState() => _MySubscriptionsScreenState();
}

class _MySubscriptionsScreenState extends State<MySubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorCompanion,
          title: Text(
            'My Subscriptions',
            style: GoogleFonts.lato(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContactsViewedScreen(),
                      ),
                    );
                  },
                  leading: Icon(
                    MdiIcons.account,
                  ),
                  title: Text(
                    'My Contacts',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubscriptionMemberHistory(),
                      ),
                    );
                  },
                  leading: Icon(
                    MdiIcons.calendar,
                  ),
                  title: Text(
                    'Subscription History',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                ListTile(
                  onTap: () {
                    // TODO: Tap event remaining
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PremiuimPlanScreen()));
                  },
                  leading: Icon(MdiIcons.arrowUp),
                  title: Text(
                    'Upgrade Plan',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
