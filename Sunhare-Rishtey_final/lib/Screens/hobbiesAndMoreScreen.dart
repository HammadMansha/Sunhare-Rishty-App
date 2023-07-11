import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Screens/hobbiesAndExtraDetailedScreen.dart';

import '../main.dart';

class HobbiesAndMoreScreen extends StatefulWidget {
  final List? hobbies;
  final List? intrests;
  final List? favMusic;
  final List? cousine;
  final List? fitness;
  final List? dressStyle;
  HobbiesAndMoreScreen(
      {this.dressStyle,
      this.cousine,
      this.favMusic,
      this.hobbies,
      this.fitness,
      this.intrests});

  @override
  _HobbiesAndMoreScreenState createState() => _HobbiesAndMoreScreenState();
}

class _HobbiesAndMoreScreenState extends State<HobbiesAndMoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorCompanion,
        title: Text(
          'Hobbies and More',
          style: GoogleFonts.karla(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HobiesAndExtraDetailScreen(
                          hobbies: true,
                          hobbiesList: widget.hobbies,
                        )));
              },
              leading: Icon(
                MdiIcons.heart,
                color: Colors.grey,
                size: 20,
              ),
              title: Text(
                'Hobbies',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.grey,
                size: 20,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HobiesAndExtraDetailScreen(
                          intrests: true,
                          intrestsList: widget.intrests,
                        )));
              },
              leading: Icon(
                MdiIcons.accountCog,
                color: Colors.grey,
                size: 20,
              ),
              title: Text(
                'Intrests',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.grey,
                size: 20,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HobiesAndExtraDetailScreen(
                          favMusic: true,
                          favMusicList: widget.favMusic,
                        )));
              },
              leading: Icon(
                MdiIcons.music,
                color: Colors.grey,
                size: 20,
              ),
              title: Text(
                'Favourite Music',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.grey,
                size: 20,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HobiesAndExtraDetailScreen(
                          sportsFitness: true,
                          sportsFitnessList: widget.fitness,
                        )));
              },
              leading: Icon(
                MdiIcons.carSports,
                color: Colors.grey,
                size: 20,
              ),
              title: Text(
                'Sports/Fitness Activities',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.grey,
                size: 20,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HobiesAndExtraDetailScreen(
                          favCousine: true,
                          favCousineList: widget.cousine,
                        )));
              },
              leading: Icon(
                MdiIcons.food,
                color: Colors.grey,
                size: 20,
              ),
              title: Text(
                'Favourite Cuisine',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.grey,
                size: 20,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HobiesAndExtraDetailScreen(
                          dressStyle: true,
                          dressStyleList: widget.dressStyle,
                        )));
              },
              leading: Icon(
                MdiIcons.dresser,
                color: Colors.grey,
                size: 20,
              ),
              title: Text(
                'Preffered DressStyle',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
