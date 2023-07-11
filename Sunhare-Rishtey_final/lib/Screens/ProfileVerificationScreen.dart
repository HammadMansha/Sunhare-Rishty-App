import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import '/Providers/getUserInfo.dart';
import '/models/UserModel.dart';
import '../models/GovIdModel.dart';
import 'package:provider/provider.dart';
import '/main.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ui;
import 'package:flutter/services.dart';

class ProfileVerificationScreen extends StatefulWidget {
  final GovIdModel govId;
  final bool isForced;
  ProfileVerificationScreen(this.govId, {this.isForced = false});
  @override
  _ProfileVerificationScreenState createState() =>
      _ProfileVerificationScreenState();
}

class _ProfileVerificationScreenState extends State<ProfileVerificationScreen> {
  File? image = null;
  Future<void> picker() async {
    var val2;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Choose Image"),
        content: Text("Please choose a ID Photo"),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera"),
            onPressed: () async {
              _pickImageCamera();

              Navigator.of(ctx).pop(true);
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.image),
            label: Text("Gallery"),
            onPressed: () async {
              _pickImageGallery();
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

  File imageFile = File("");

  Future<Null> _pickImageGallery() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 60);
    imageFile = pickedImage != null ? File(pickedImage.path ?? "") : File("");
    if (imageFile != null) {
      setState(() {
        _cropImage();
      });
    }
  }

  Future<Null> _pickImageCamera() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 60);
    imageFile = pickedImage != null
        ? File(
            pickedImage.path,
          )
        : File("");
    if (imageFile != null) {
      _cropImage();
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 6),
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Crop your image',
        ));
    if (croppedFile != null) {
      //rempve this two line if you need to  compress
      image = croppedFile;
      setState(() {});
      /*compressFile(croppedFile).then((value) {
        croppedFile = value;
        getImageFileFromAssets("watermark.png").then((watermarkFile) {
          ui.Image? originalImage = ui.decodeImage(croppedFile!.readAsBytesSync());
          ui.Image? watermarkImage = ui.decodeImage(watermarkFile.readAsBytesSync());

          int scaledH = (originalImage!.height * 0.50).toInt();
          int scaledW = watermarkImage!.width * scaledH ~/ watermarkImage.height;

          ui.Image watermark = ui.Image(scaledW, scaledH);
          ui.drawImage(watermark, watermarkImage);

          // ui.drawString(originalImage, ui.arial_24, 100, 120, 'Think Different');

          ui.copyInto(originalImage, watermark,
              dstX: originalImage.width - scaledW - 28,
              dstY: (originalImage.height - scaledH) ~/ 2);

          List<int> wmImage = ui.encodePng(originalImage);
          croppedFile!.writeAsBytesSync(wmImage);
          image = croppedFile!;

          setState(() {});
        });
      });*/
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 70,
    );
    // print(file.lengthSync());
    // print(result.lengthSync());
    return result!;
  }

  bool isLoading = false;
  Future<void> uploadButton() async {
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser;
    if (image != null) {
      setState(() {
        isLoading = true;
      });
      Fluttertoast.showToast(msg: 'Uploading');
      /*final ref = FirebaseStorage.instance
          .ref()
          .child("CustomerDP")
          .child("${FirebaseAuth.instance.currentUser!.uid}")
          .child("CustomerID" + ".jpg");
      await ref.putFile(image!);
      final vals = await ref.getDownloadURL();*/
      //'imageUrl': vals,

      String imagePath = await ImageUtils.uploadDocumentsImage(image!);


      try {
        Provider.of<CurrUserInfo>(context, listen: false)
            .isVerificationPending = widget.isForced;
        await FirebaseDatabase.instance
            .reference()
            .child("User Information")
            .child(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'isVerificationPending': widget.isForced,
          'isVerificationRequired': false
        });
        await FirebaseDatabase.instance
            .reference()
            .child("Gov Id")
            .child(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'imageUrl': imagePath,
          'isVerified': false,
          'name': userInfo.name,
          'srId': userInfo.srId,
          'userId': userInfo.id,
          'varificationBy': verificationBy,
        }).then((value) {
          Fluttertoast.showToast(msg: 'Uploaded successfully');
          sendPushNotificationToAdmin(
              "Verify Id", "Verify ${userInfo.name}'s $verificationBy",
              target: Constants.ADMIN_ID_VERIFICATION,
              userId: FirebaseAuth.instance.currentUser!.uid);
          setState(() {
            isLoading = false;
            Navigator.of(context).pop();
          });
        });
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(), backgroundColor: HexColor('fa9033'));
      }
    }
  }

  String verificationBy = "Aadhar Card";
  String id = "Aadhar Card";
  List<String> idList = [
    'Aadhar Card',
    'PAN Card',
    'Driving License',
    'Passport',
  ];
  UserInformation userInfo = UserInformation();
  CurrUserInfo userInfoProvider = CurrUserInfo();
  bool showForm = true;
  bool verificationPending = true;
  bool isNotSubmited = false;
  @override
  void initState() {
    userInfoProvider = Provider.of<CurrUserInfo>(context, listen: false);
    userInfo = userInfoProvider.currentUser;
    getDataFromProvider();
    showForm = (widget.govId == null || widget.govId.imageUrl == null);
    isNotSubmited = (widget.govId == null || widget.govId.imageUrl == null);
    verificationPending = !isNotSubmited && widget.govId.isVerified == false;

    super.initState();
  }

  getDataFromProvider() async {
    await userInfoProvider.getGovData();
    removePreviousIDs();
  }

  removePreviousIDs() {
    var verified = userInfoProvider.govDataModel.verified ?? {};
    verified.forEach((key, value) {
      idList.remove(key);
    });
    setState(() {});
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
            'Verify Profile',
            style: GoogleFonts.karla(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          // leading: Icon(
          //   MdiIcons.check,
          //   size: 20,
          // ),
        ),
        bottomNavigationBar: isNotSubmited
            ? InkWell(
                onTap: () {
                  if (verificationBy == null || image == null) {
                    Fluttertoast.showToast(msg: 'Select Id & image first');
                  } else {
                    uploadButton();
                  }
                },
                child: Container(
                  height: height * .071,
                  alignment: Alignment.center,
                  color: theme.colorCompanion,
                  child: isLoading
                      ? SpinKitThreeBounce(
                          color: Colors.white,
                          size: 20,
                        )
                      : Text(
                          'UPDATE',
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            : Container(
                height: height * .071,
              ),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: showForm
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Container(
                            child: Row(children: [
                          Text("Upload ID proof ",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                          Text(userInfo.name ?? "",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ])),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Verification Method',
                          style: GoogleFonts.openSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .015,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
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
                          value: id,
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
                          items: idList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            verificationBy = value ?? "";
                            print(verificationBy);
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      SizedBox(
                        height: height * .1,
                      ),
                      GestureDetector(
                        onTap: () {
                          // picker();
                        },
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Center(
                            child: Container(
                                height: height * .21,
                                width: width * .7,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                child: InkWell(
                                    onTap: () {
                                      picker();
                                    },
                                    child: image == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                              SizedBox(height: height * .01),
                                              Icon(
                                                MdiIcons.camera,
                                                size: 35,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          )
                                        : Container(
                                            child: Image.file(image!,fit: BoxFit.fill),
                                          ))),
                          ),
                        ),
                      ),
                    ],
                  )
                : verificationPending
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * .3,
                            ),
                            Center(
                                child: Icon(
                              MdiIcons.timer,
                              size: 40,
                            )),
                            Center(child: Text('Verification Pending')),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * .3,
                            ),
                            Center(
                                child: Icon(
                              Icons.check_circle,
                              size: 60,
                              color: Colors.blue,
                            )),
                            Center(child: Text('Verified')),
                            Center(
                              child: Text(
                                'By ${widget.govId.verifiedBy}',
                                style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )),
      ),
    );
  }
}
