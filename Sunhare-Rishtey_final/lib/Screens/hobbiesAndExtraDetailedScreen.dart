import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../main.dart';

class HobiesAndExtraDetailScreen extends StatefulWidget {
  final bool hobbies;
  final List? hobbiesList;
  final List? intrestsList;
  final List? favMusicList;
  final List? sportsFitnessList;
  final List? favCousineList;
  final List? dressStyleList;
  final bool intrests;
  final bool favMusic;
  final bool sportsFitness;
  final bool favCousine;
  final bool dressStyle;

  HobiesAndExtraDetailScreen(
      {this.dressStyle = false,
      this.favCousine = false,
      this.favMusic = false,
      this.hobbies = false,
      this.intrests = false,
      this.sportsFitness = false,
      this.dressStyleList,
      this.favCousineList,
      this.favMusicList,
      this.hobbiesList,
      this.intrestsList,
      this.sportsFitnessList});

  @override
  _HobiesAndExtraDetailScreenState createState() => _HobiesAndExtraDetailScreenState();
}

class _HobiesAndExtraDetailScreenState extends State<HobiesAndExtraDetailScreen> {
  List<String> hobbies = [
    "Acting",
    "Animal breeding",
    "Art / Handicraft",
    "Astrology / Palmistry / Numerology",
    "Astronomy",
    "Bird watching",
    "Collectibles",
    "Cooking",
    "Dancing",
    "DIY(do it yourself) projects",
    "Film-making",
    "Fishing",
    "Gardening / Landscaping",
    "Graphology",
    "Ham radio",
    "Home / Interior decoration",
    "Hunting",
    "Model building",
    "Painting / Drawing",
    "Photography",
    "Playing musical instruments",
    "Singing",
    "Solving Crosswords, Puzzles"
  ];
  List<String> intrests = [
    "Alternativehealing",
    "Bikes / Cars",
    "Blogging",
    "Clubbing",
    "Driving",
    "Eating out",
    "Health & Fitness",
    "Hiking / Camping",
    "Learning new languages",
    "Listening to music",
    "Mehendi Designing",
    "Movies",
    "Museums / Galleries / Exhibitions",
    "Nature",
    "Net surfing",
    "Pets",
    "Politics",
    "Reading / Book clubs",
    "Religion",
    "Shopping",
    "Sports - Indoor",
    "Sports - Outdoor",
    "Stitching",
    "Technology",
    "Theatre",
    "Travel / Sightseeing",
    "Trekking / Adventure sports",
    "Video / Computer games",
    "Volunteering / Social Service",
    "Watching television",
    "Wine tasting",
    "Writing",
    "Yoga / Meditation",
  ];
  List<String> favMusic = [
    "Acid Rock / Hard Rock",
    "Alternative Music",
    "Bhajans / Devotional",
    "Bhangra",
    "Blues",
    "Christian / Gospel / Blue Grass",
    "Classical - Carnatic",
    "Classical - Hindustani",
    "Classical - Opera",
    "Classical - Western",
    "Country Music",
    "Disco",
    "Folk",
    "Ghazals",
    "Heavy Metal",
    "Hip-Hop",
    "House Music",
    "Indipop",
    "Instrumental - Indian",
    "Instrumental - Western",
    "Jazz",
    "Latest film songs",
    "Latin Music",
    "New Age Music",
    "Old film songs",
    "Pop",
    "Qawalis",
    "R&B / Soul",
    "Rap",
    "Reggae",
    "Remixes",
    "Soft Rock",
    "Sufi music",
    "Techno / Trance",
    "Western Country Music",
    "World Music",
    "Enjoy most forms of music",
  ];
  List<String> sportsFitnes = [
    "Aerobics",
    "Athletics",
    "Badminton",
    "Baseball",
    "Basketball",
    "Billiards / Snooker / Pool",
    "Bowling",
    "Boxing / Wrestling",
    "Card games",
    "Carrom",
    "Chess",
    "Cricket",
    "Cycling",
    "Football / Soccer",
    "Golf",
    "Gym workouts / Weight training",
    "Hockey",
    "Horseback Riding",
    "Jogging / Walking / Running",
    "Martial Arts",
    "Motor Racing",
    "Polo",
    "Rugby",
    "Sailing / Boating / Rowing",
    "Scrabble",
    "Scuba Diving",
    "Shooting",
    "Skating / Snowboarding / Skiing",
    "Squash",
    "Swimming / Water sports",
    "Table-tennis",
    "Tennis",
    "Trekking / Adventure sports",
    "Volleyball",
    "Weight training",
    "Winter / Rink sports",
    "Yoga / Meditation",
  ];
  List<String> favCousine = [
    "American",
    "Arabic",
    "Bengali",
    "Chinese",
    "Continental",
    "Fast food",
    "Gujarati",
    "Italian",
    "Japanese",
    "Konkan",
    "Lebanese",
    "Mexican",
    "Moghlai",
    "North Indian",
    "Persian",
    "Punjabi",
    "Rajasthani",
    "Seafood",
    "Sindhi",
    "Soul Food",
    "South Indian",
    "Spanish",
    "Thai",
  ];
  List<String> dressStyle = [
    "Business casual - semi-formal office wear",
    "Casual - usually in jeans and T-shirts",
    "Classic Indian - typically Indian formal wear",
    "Classic Western - typically western formal wear",
    "Designer - only leading brands will do",
    "Trendy - in line with the latest fashion",
  ];

  List selectedHobbies = [];
  List selectedIntrested = [];
  List selectedMustic = [];
  List selectedSports = [];
  List selectedFavCousine = [];
  List selectedDressStyle = [];

  @override
  void initState() {
    selectedHobbies = widget.hobbiesList ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .03,
            ),
            widget.hobbies
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorGrey,
                      ),
                      color: theme.colorBackground,
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: MultiSelectDialogField(
                      initialValue: selectedHobbies,
                      selectedItemsTextStyle: GoogleFonts.workSans(color: Colors.white),
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      items: hobbies.map((e) => MultiSelectItem(e, e)).toList(),
                      title: Text("Select Hobbies"),
                      selectedColor: Colors.red,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        border: Border.all(
                          color: theme.colorGrey,
                        ),
                      ),
                      buttonIcon: Icon(
                        Icons.school,
                        color: theme.colorCompanion,
                      ),
                      buttonText: Text(
                        "Choose Hobbies",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onConfirm: (results) {
                        selectedHobbies = results;
                        FirebaseDatabase.instance
                            .reference()
                            .child('HobiesAndMore')
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .update({"Hobbies": selectedHobbies}).then((value) {
                          Fluttertoast.showToast(msg: 'Save successfully');
                        });
                      },
                    ),
                  )
                : widget.intrests
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorGrey,
                          ),
                          color: theme.colorBackground,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: MultiSelectDialogField(
                          initialValue: selectedIntrested,
                          selectedItemsTextStyle: GoogleFonts.workSans(color: Colors.white),
                          listType: MultiSelectListType.CHIP,
                          searchable: true,
                          items: intrests.map((e) => MultiSelectItem(e, e)).toList(),
                          title: Text("Select Intrests"),
                          selectedColor: Colors.red,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            border: Border.all(
                              color: theme.colorGrey,
                            ),
                          ),
                          buttonIcon: Icon(
                            Icons.school,
                            color: theme.colorCompanion,
                          ),
                          buttonText: Text(
                            "Choose Intrests",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onConfirm: (results) {
                            selectedIntrested = results;
                            FirebaseDatabase.instance
                                .reference()
                                .child('HobiesAndMore')
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .update({"Intrests": selectedIntrested}).then((value) {
                              Fluttertoast.showToast(msg: 'Save successfully');
                            });
                          },
                        ),
                      )
                    : widget.favMusic
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            width: width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorGrey,
                              ),
                              color: theme.colorBackground,
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                            child: MultiSelectDialogField(
                              initialValue: selectedMustic,
                              selectedItemsTextStyle: GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: favMusic.map((e) => MultiSelectItem(e, e)).toList(),
                              title: Text("Select Music"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.school,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Choose Music",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedMustic = results;
                                FirebaseDatabase.instance
                                    .reference()
                                    .child('HobiesAndMore')
                                    .child(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"music": selectedMustic}).then((value) {
                                  Fluttertoast.showToast(msg: 'Save successfully');
                                });
                              },
                            ),
                          )
                        : widget.sportsFitness
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                width: width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.colorGrey,
                                  ),
                                  color: theme.colorBackground,
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                child: MultiSelectDialogField(
                                  initialValue: selectedSports,
                                  selectedItemsTextStyle: GoogleFonts.workSans(color: Colors.white),
                                  listType: MultiSelectListType.CHIP,
                                  searchable: true,
                                  items: sportsFitnes.map((e) => MultiSelectItem(e, e)).toList(),
                                  title: Text("Select Fitness"),
                                  selectedColor: Colors.red,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    border: Border.all(
                                      color: theme.colorGrey,
                                    ),
                                  ),
                                  buttonIcon: Icon(
                                    Icons.school,
                                    color: theme.colorCompanion,
                                  ),
                                  buttonText: Text(
                                    "Choose Fitness",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedSports = results;
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('HobiesAndMore')
                                        .child(FirebaseAuth.instance.currentUser!.uid)
                                        .update({"Fitness": selectedSports}).then((value) {
                                      Fluttertoast.showToast(msg: 'Save successfully');
                                    });
                                  },
                                ),
                              )
                            : widget.favCousine
                                ? Container(
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                    width: width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.colorGrey,
                                      ),
                                      color: theme.colorBackground,
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ),
                                    ),
                                    child: MultiSelectDialogField(
                                      initialValue: selectedMustic,
                                      selectedItemsTextStyle: GoogleFonts.workSans(color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: favCousine.map((e) => MultiSelectItem(e, e)).toList(),
                                      title: Text("Select Cousine"),
                                      selectedColor: Colors.red,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                        border: Border.all(
                                          color: theme.colorGrey,
                                        ),
                                      ),
                                      buttonIcon: Icon(
                                        Icons.school,
                                        color: theme.colorCompanion,
                                      ),
                                      buttonText: Text(
                                        "Choose Cousine",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedFavCousine = results;
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('HobiesAndMore')
                                            .child(FirebaseAuth.instance.currentUser!.uid)
                                            .update({"Cousine": selectedFavCousine}).then((value) {
                                          Fluttertoast.showToast(msg: 'Save successfully');
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                    width: width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.colorGrey,
                                      ),
                                      color: theme.colorBackground,
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ),
                                    ),
                                    child: MultiSelectDialogField(
                                      initialValue: selectedDressStyle,
                                      selectedItemsTextStyle: GoogleFonts.workSans(color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: dressStyle.map((e) => MultiSelectItem(e, e)).toList(),
                                      title: Text("Select Dress Style"),
                                      selectedColor: Colors.red,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                        border: Border.all(
                                          color: theme.colorGrey,
                                        ),
                                      ),
                                      buttonIcon: Icon(
                                        Icons.school,
                                        color: theme.colorCompanion,
                                      ),
                                      buttonText: Text(
                                        "Choose Dress Style",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedDressStyle = results;
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('HobiesAndMore')
                                            .child(FirebaseAuth.instance.currentUser!.uid)
                                            .update({"dressStyle": selectedDressStyle}).then((value) {
                                          Fluttertoast.showToast(msg: 'Save successfully');
                                        });
                                      },
                                    ),
                                  )
          ],
        ),
      ),
    );
  }
}
