import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '/main.dart';
import 'Info4.dart';

class Info3 extends StatefulWidget {
  final String qualification;
  Info3(this.qualification);
  @override
  _Info3State createState() => _Info3State();
}

class _Info3State extends State<Info3> {
  File? image = null;

  String visibility = 'All Member';
  setIntro() {
    intro =
        'Glad you choose my profile and here\'s a quick introduction. Regarding my education, I have pursued ${widget.qualification}. Clarity, simplicity and effective communication are among the key qualities I believe in. I seek a compatible life partner, someone who is understanding and has good values. Thank you for showing interest in my profile.';
  }

  bool isImagesUploaded = false;

  Future<void> picker() async {
    // ignore: unused_local_variable
    File document;
    var val2;
    // ignore: unused_local_variable
    var _imagesetting = false;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Choose Image"),
        content: Text("Please choose a Image for your profile"),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera"),
            onPressed: () async {
              ImageUtils.pickImage(ImageSource.camera).then((value) {
                setState(() {
                  image = value;
                });
                print("value1===>>${image!.path.runtimeType}");
                print("value1===>>${image!.path}");
                if(image!.path.isNotEmpty || image!.path != ""){
                  print("path not empty");
                  uploadButton();
                }
              });

              Navigator.of(ctx).pop(true);
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.image),
            label: Text("Gallery"),
            onPressed: () async {
              ImageUtils.pickImage(ImageSource.gallery).then((value) {
                setState(() {
                  image = value;
                });
                print("value2===>>${image!.path.runtimeType}");
                print("value2===>>${image!.path}");
                if(image!.path.isNotEmpty || image!.path != ""){
                  print("path not empty");
                  uploadButton();
                }
              });
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
    setState(() {
      if (val2 == null) {
        return;
      } else {
        image = val2;
      }
    });
  }

  Future<void> uploadButton() async {
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser;
    if (image != null && image!.path != "" && image!.path.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Uploading');
      /*final ref = FirebaseStorage.instance
          .ref()
          .child("CustomerDP")
          .child("${FirebaseAuth.instance.currentUser!.uid}")
          .child("CustomerDP" + ".jpg");
      await ref.putFile(image!);

      final vals = await ref.getDownloadURL();*/
      //.update({'imageURL': vals, "visibility": visibility}).then((value) {


      String imagePath = await ImageUtils.uploadProfileImage(image!);

      print("uid,,,,,,,,,,,,,,${FirebaseAuth.instance.currentUser!.uid}");
      print("imagePath${imagePath}");

      try {
        // FirebaseDatabase.instance.reference().onDisconnect().

        print("Uploading start");
        await FirebaseDatabase.instance
            .reference()
            .child("User Information")
            .child(FirebaseAuth.instance.currentUser!.uid)
            .update({'imageURL': imagePath, "visibility": visibility}).then((value) {
          isImagesUploaded = true;
          Fluttertoast.showToast(msg: 'Uploaded successfully');
          print("Uploading end");
          setState(() {});
        });
      } catch (e) {
        print("Uploading error");
        Fluttertoast.showToast(
            msg: e.toString(), backgroundColor: HexColor('fa9033'));
      }
    }
    setState(() {});
  }

  var selectedGender;

  String intro = '';
  bool isLoading = false;
  bool isRedirected = false;
  @override
  void initState() {

    Future.delayed(Duration.zero, () async{
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    });



    setIntro();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          elevation: 8,
          backgroundColor: theme.colorCompanion,
          actions: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 10,
                  child: Text(
                    '1',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: theme.colorPrimary,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 10,
                  child: Text(
                    '2',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: theme.colorPrimary,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 10,
                  child: Text(
                    '3',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: theme.colorPrimary,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 15,
                  child: Text(
                    '4',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: Colors.black54,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 10,
                  child: Text(
                    '5',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * .05,
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * .03,
                ),
                Container(
                  width: width,
                  child: Center(
                    child: Text(
                      "You are almost done!",
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                Container(
                  child: Text(
                    'About yourself',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .015,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  height: height * .06 * 3,
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
                  child: TextFormField(
                    initialValue: intro,
                    onChanged: (val) {
                      intro = val;
                    },
                    cursorColor: theme.colorCompanion,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Start typing here...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .04,
                ),
                SizedBox(
                  height: height * .01,
                ),
                GestureDetector(
                  onTap: () {
                    picker();
                  },
                  child: Center(
                    child: Container(
                      height: height * .2,
                      width: width * .3,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child:
                          //  widget.userInfo.imageUrl == null
                          // ?
                          image == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    Text(
                                      'Click Here',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'to upload',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .01,
                                      width: width * 1,
                                    ),
                                    Icon(
                                      MdiIcons.camera,
                                      size: 35,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Photo',
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  child: Image.file(image!),
                                ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Container(
                  child: Text(
                    'Visibility',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .015,
                ),
                //
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  // height: height * .06,
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
                  child: DropdownButtonFormField(
                    validator: (val) {
                      if (val == null) {
                        return 'Required';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    hint: Text('Select'),
                    items: Constants.visibilityList.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (value) {
                      visibility = value ?? "";
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                  ),
                ),
                SizedBox(
                  height: height * .05,
                ),
                InkWell(
                  onTap: () {
                   /* if(isRedirected){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Info4(),
                        ),
                      );
                    }else { */

                        if (image != null && image!.path != "" && image!.path.isNotEmpty) {
                          if (intro.length < 50) {
                            Fluttertoast.showToast(msg: 'length in too short');
                          } else if (image == null) {
                            Fluttertoast.showToast(msg: 'Please select image');
                          } else if (!isImagesUploaded) {
                            Fluttertoast.showToast(msg: 'Please wait image uploading...');
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            // isImagesUploaded
                            // uploadButton();
                            String id = FirebaseAuth.instance.currentUser!.uid;
                            FirebaseDatabase.instance
                                .reference()
                                .child('User Information')
                                .child(id)
                                .update({'intro': intro}).then(
                                  (value) {
                                setState(() {
                                  isLoading = false;
                                  isRedirected = true;
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Info4(),
                                  ),
                                );

                                print("selected visibility--->>>$visibility");

                                if (visibility.isNotEmpty) {
                                  totalProfileCompleted = totalProfileCompleted + percentAdd;
                                  print("totalProfileCompleted--->>>$totalProfileCompleted");
                                }
                              },
                            );
                          }
                        }
                        else {
                          Fluttertoast.showToast(msg: 'Please choose image');
                        }
                        setState(() {});
                    // }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: theme.colorCompanion,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: isLoading
                              ? SpinKitThreeBounce(
                                  size: 20,
                                  color: Colors.white,
                                )
                              : Text(
                                  'Almost There',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
