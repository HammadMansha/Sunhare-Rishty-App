import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import '/Providers/getUserInfo.dart';
import '/Screens/addPicturesPage.dart';
import '/models/UserModel.dart';
import '../models/ImageModel.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/main.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  List<String> privacyList = [
    'All Member',
    'Premium Members only',
    'Connected Members',
  ];
  UserInformation userInfo = UserInformation();
  getImageData() {
    FirebaseDatabase.instance
        .reference()
        .child('Images')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        imageList = [];
        final images = data as Map;
        images.forEach((key, value) {
          imageList.add(ImageModel(
              id: key,
              imageUrl: value['imageURL'].toString(),
              isVerified:
                  value['isVerified'] != null ? value['isVerified'] : false));
        });
        setState(() {});
      }
    });
  }

  List<ImageModel> imageList = [];
  String visibility = "";
  File image = File("");
  Future<void> picker() async {
    // ignore: unused_local_variable
    File document;
    var val2;
    // ignore: unused_local_variable

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Choose Image"),
        content: Text("Please choose a Image for your profile"),
        actions: <Widget>[
          OutlinedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera"),
            onPressed: () async {
              ImageUtils.pickImage(ImageSource.camera).then((value) {
                setState(() {
                  image = value;
                });
                uploadButton();
              });
              Navigator.of(ctx).pop(true);
            },
          ),
          OutlinedButton.icon(
            icon: Icon(Icons.image),
            label: Text("Gallery"),
            onPressed: () async {
              ImageUtils.pickImage(ImageSource.gallery).then((value) {
                setState(() {
                  image = value;
                });
                uploadButton();
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
    if (image != null) {
      Fluttertoast.showToast(msg: 'Uploading');
      /*final ref = FirebaseStorage.instance
          .ref()
          .child("CustomerImages")
          .child("${FirebaseAuth.instance.currentUser!.uid}")
          .child("${DateTime.now().toIso8601String()}" + ".jpg");
      await ref.putFile(image);

      final vals = await ref.getDownloadURL();*/

      String imagePath = await ImageUtils.uploadProfileImage(image);


      try {
        String id = Uuid().v4().toString().substring(1, 6);
        await FirebaseDatabase.instance
            .reference()
            .child("Images")
            .child(FirebaseAuth.instance.currentUser!.uid)
            .child(id)
            .update({'imageURL': imagePath, 'id': id}).then((value) {
          Fluttertoast.showToast(msg: 'Uploaded successfully');
          sendPushNotificationToAdmin("Photo verification required",
              "${userInfo.name} uploaded new photo for verification",
              target: Constants.ADMIN_PHOTO_VERIFICATION,
              userId: FirebaseAuth.instance.currentUser!.uid);
          setState(() {});
        });
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(), backgroundColor: HexColor('fa9033'));
      }
    }
  }

  int idx = 0;
  @override
  void initState() {
    getImageData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userInfo = Provider.of<CurrUserInfo>(context).currentUser;
    visibility = userInfo.visibility ?? 'All Member';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          if (imageList.length < 5) {
            picker();
          } else {
            Fluttertoast.showToast(
              msg: 'You can only upload 5 pics maximum',
              textColor: Colors.white,
            );
          }
        },
        child: Container(
          height: height * .07,
          width: width,
          color: Colors.blue.withOpacity(.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.camera,
                color: Colors.white,
              ),
              SizedBox(
                width: width * .02,
              ),
              Text(
                'Add more Photos',
                style: GoogleFonts.workSans(
                    color: Colors.white, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: theme.colorCompanion,
        title: Text('My Photo'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .02,
          ),
          Row(
            children: [
              Container(
                width: width * .23,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Visible to',
                    style: GoogleFonts.openSans(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                // height: height * .06,
                width: width * .7,
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
                  value: visibility,
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
                  items: privacyList.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (visibility) {
                    FirebaseDatabase.instance
                        .reference()
                        .child('User Information')
                        .child(userInfo.id ?? "")
                        .update({"visibility": visibility}).then((value) {
                      Provider.of<CurrUserInfo>(context, listen: false)
                          .updateVisibility(visibility ?? "");
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * .02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddPicturesScreen(imageList),
                  ),
                );
              },
              child: Container(
                height: height * .5,
                width: width * .9,
                child: CachedNetworkImage(
                  imageUrl: userInfo.imageUrl ?? "",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height * .15,
              width: width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (context, index) => Row(
                  children: [
                    Container(
                      height: height * .15,
                      width: width * .25,
                      child: CachedNetworkImage(
                        imageUrl: imageList[index].imageUrl,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder: /* (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        } */
                            (context, url, progress) {
                          if (progress.progress == null) return Container();
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: width * .02,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
