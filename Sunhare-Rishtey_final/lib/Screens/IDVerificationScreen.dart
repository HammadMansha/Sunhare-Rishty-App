import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:matrimonial_app/Screens/ProfileVerificationScreen.dart';
import 'package:matrimonial_app/models/GovIdModel.dart';

class IDVerificationScreen extends StatelessWidget {
  final String userName,image;

  const IDVerificationScreen({Key? key, required this.userName, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * .44,
          width: MediaQuery.of(context).size.width * .88,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Center(
                      child: Text('Waiting',
                          style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    decoration: BoxDecoration(
                        color: HexColor('fa9033'),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    width: MediaQuery.of(context).size.width * .88,
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('ID Verification is required.',
                          style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Please verify ID of ',
                              style: GoogleFonts.workSans(
                                  color: HexColor('293662'),
                                  fontWeight: FontWeight.w600)),
                          Text(userName,
                              style: GoogleFonts.workSans(
                                  color: HexColor('293662'),
                                  fontWeight: FontWeight.w700))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: 100,width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(image),fit: BoxFit.fill)
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pinkAccent),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileVerificationScreen(GovIdModel(), isForced: true),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
