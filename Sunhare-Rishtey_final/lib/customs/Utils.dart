import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:matrimonial_app/models/get_document_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'dart:io';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../models/get_image_model.dart';

bool isDialogShow = false;

String getTimeInHhMmA(DateTime dateTime) {
  return DateFormat.jm().format(dateTime);
}

String getDateInDdMMYyyy(DateTime dateTime) {
  var outputFormat = DateFormat('dd-MM-yyyy');
  return outputFormat.format(dateTime);
}

int calculateAge(String dobirth) {
  var now = DateTime.now();
  final DateFormat format = new DateFormat("dd/MMM/yyyy");
  var dob = format.parse(dobirth);
  return (now.difference(dob).inDays ~/ 365);
}

int countIncome(String annualIncome) {
  String str = annualIncome.replaceAll("-", "").replaceAll(" lakhs", "");
  if (str.contains("<")) {
    return 10;
  } else if (str.contains(">")) {
    return 1000;
  } else if (str == "Not Working") {
    return 0;
  } else {
    return int.parse(str);
  }
}

int calculateHeight(String height) {
  String str = height.split(' - ')[1];
  return int.parse(str.substring(0, str.length - 2));
}

void showToast(message, Color color) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

splitData(String time) {
  if (time != null) {
    try {
      List t = time.split('');
      int hr = int.parse(t[10]) * 10 + int.parse(t[11]);
      int minute = int.parse(t[13]) * 10 + int.parse(t[14]);
      return TimeOfDay(hour: hr, minute: minute);
    } catch (e) {
      return null;
    }
  } else
    return null;
}

getUserData(String id) async {
  final data = await FirebaseDatabase.instance
      .reference()
      .child('User Information')
      .child(id)
      .once();
  final value = data.snapshot.value as Map;

  final verifiedData = await FirebaseDatabase.instance
      .reference()
      .child('Gov Id')
      .child(id)
      .once();
  final govData = (verifiedData.snapshot.value ?? {}) as Map;

  if (value['isVerified'] != null && value['isVerified']) {
    final hideMap =
        value['hideProfile'] != null ? value['hideProfile'] as Map : null;
    bool hide = false;
    if (hideMap != null) {
      hideMap.forEach((key, value) {
        if(key == "unHideDate"){
          DateTime tempDate = DateTime.parse(value);
          if(DateTime.now().isBefore(tempDate) == false){
            hide = false;
          }else{
            hide = true;
          }
        }
        /*if (value) {
          hide = value;
        }*/
      });
    }
    if (!hide) {
      hide = value['isSuspended'] ?? false;
    }
    //  PremiumModel primium = getPrimium(key);
    final dobMap = value['hideDob'] != null ? value['hideDob'] as Map : null;
    final mobileMap =
        value['hideMobile'] != null ? value['hideMobile'] as Map : null;

    bool hideMobile = false;
    bool showDob = false;
    if (dobMap != null)
      dobMap.forEach((key, value) {
        showDob = value ?? false;
      });
    if (mobileMap != null) {
      mobileMap.forEach((key, value) {
        //hideMobile = value;
        if(key == "expireDate"){
          DateTime tempDate = DateTime.parse(value);
          if(DateTime.now().isBefore(tempDate) == false){
            hideMobile = false;
          }else{
            hideMobile = true;
          }
        }else{
          hideMobile = false;
        }
      });
    }
    if (!hide) {
      return UserInformation(
          isGovIdVerified: govData != null ? govData['isVerified'] : false,
          govVerifiedBy: govData != null ? govData['verifiedBy'] : "Adhar card",
          hideProfile: hide,
          hideContact: hideMobile,
          hideDob: showDob,
          birthTime: splitData(value['timeOfBirth']),
          verifiedBy: value['verifiedBy'],
          isPremium: value['isPremium'] ?? false,
          userStatus: value['LastActive'] != null
              ? DateTime.parse(value['LastActive'].toString())
                          .difference(DateTime.now())
                          .inMinutes
                          .abs() <
                      30
                  ? 'Active'
                  : 'Inactive'
              : 'Inactive',
          showHoroscope: value['showHoroscope'] ?? true,
          affluenceLevel: value['afluenceValue'],
          familyValues: value['familyValue'],
          motherName: value['motherName'] ?? '',
          fatherName: value['fatherName'] ?? '',
          bloodGroup: value['bloodGroup'] ?? '',
          healthInfo: value['healthInfo'] ?? '',
          srId: value['id'],
          visibility: value['visibility'] ?? "All Member",
          name: value['userName'],
          email: value['email'],
          id: id,
          employedIn: value['employedIn'] ?? "",
          marriedBrothers: value['marriedBrothers'],
          marriedSisters: value['marriedSisters'],
          phone: value['mobileNo'],
          gender: value['gender'],
          dateOfBirth: value['DateOfBirth'],
          religion: value['Religion'],
          annualIncome: value['annualIncome'],
          collegeAttended: value['clg'],
          workingAs: value['designation'],
          country: value['living'],
          highestQualification: value['qualification'],
          workingWith: value['workAt'],
          anyDisAbility: value['disability'],
          brothers: value['brotherCount'],
          sisters: value['sisterCount'],
          intro: value['intro'],
          manglik: value['maglik'],
          city: value['city'],
          fatherGautra: value['fatherGotra'],
          motherGautra: value['motherGotra'],
          diet: value['diet'],
          imageUrl: value['imageURL'],
          cityOfBirth: value['cityOfBirth'],
          employerName: value['employerName'],
          state: value['state'],
          residencyStatus: value['residency'],
          motherStatus: value['MotherStatus'],
          postedBy: value['ProfileFor'],
          nativePlace: value['nativePlace'],
          motherTongue: value['motherTongue'],
          community: value['Community'],
          fatherStatus: value['FatherStatus'],
          grewUpIn: value['grewUpIn'],
          familyType: value['familyType'],
          height: value['personHeight'],
          maritalStatus: value['maritalStatus'],
          dateOfCreated: DateTime.parse(value['DateTime']) ??
              DateTime.now().subtract(Duration(days: 200)),
          fcmToken: value['fcm'] ?? '');
    }

    return null;
  }
}

launchWhatsApp(String phone, UserInformation user) async {
  var userData = "● Profile id: ${user.srId!.toUpperCase()}";
  userData += "\n● Name: ${user.name!.toLowerCase()}";
  userData += "\n● Occupation: ${user.workingAs!.toUpperCase()}";
  userData += "\n● Income: ${user.annualIncome!.toUpperCase()}";
  userData += "\n● Employed In: ${user.employedIn!.toUpperCase()}";
  userData += "\n● Education: ${user.highestQualification!.toUpperCase()}";
  userData += "\n● College: ${user.collegeAttended!.toUpperCase()}";
  userData += "\n● Birth Date: ${user.dateOfBirth!.toUpperCase()}";
  userData += "\n● Height: ${user.height!.toUpperCase()}";
  userData += "\n● Manglik: ${user.manglik!.toUpperCase()}";
  userData += "\n● Marital Status: ${user.maritalStatus!.toUpperCase()}";
  userData += "\n● City of birth: ${user.cityOfBirth!.toUpperCase()}";
  userData += "\n● Current city: ${user.city!.toUpperCase()}";
  userData += "\n● Contact details: \n     DOWNLOAD SUNHARE Rishtey App.";

  final link = WhatsAppUnilink(
    phoneNumber: '$phone',
    text: userData + "\n\n\nHey! I'm inquiring about SUNHARE Rishtey",
  );

  // Convert the WhatsAppUnilink instance to a string.
  // Use either Dart's string interpolation or the toString() method.
  // The "launch" method is part of "url_launcher".
  await launch('$link');
}

class ImageUtils {
  static final double maxWidth = 1024;
  static final double maxHeight = 1024;

  static Future<File> pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedImage != null ? File(pickedImage.path) : File("");
  }

  static Future<File> pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    return pickedImage != null ? File(pickedImage.path) : File("");
  }

  static Future<File> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return File("");
    File? imageFile = File(pickedImage.path);

    imageFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3.5, ratioY: 6),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            showCropGrid: false,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Crop your image',
        ));
    return imageFile!;

    final byteData = await rootBundle.load('assets/watermark.png');
    final watermarkFile =
        File('${(await getTemporaryDirectory()).path}/watermark.png');
    await watermarkFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    image.Image? originalImage = image.decodeImage(imageFile!.readAsBytesSync());
    image.Image? watermarkImage = image.decodeImage(watermarkFile.readAsBytesSync());

    originalImage = maintainMaximumSize(originalImage!, maxWidth, maxHeight);
    originalImage = maintainSize(originalImage, 800, 1024);

    int scaledH = (originalImage.height * 0.50).toInt();
    int scaledW = watermarkImage!.width * scaledH ~/ watermarkImage.height;

    watermarkImage =
        maintainSize(watermarkImage, scaledW.toDouble(), scaledH.toDouble());

    image.Image watermark = image.Image(scaledW, scaledH);
    image.drawImage(watermark, watermarkImage);

    image.copyInto(originalImage, watermark,
        dstX: originalImage.width - watermark.width - 40,
        dstY: (originalImage.height - watermark.height) ~/ 2);

    List<int> wmImage = image.encodePng(originalImage);
    Uint8List byte = Uint8List.fromList(wmImage);
    wmImage = await FlutterImageCompress.compressWithList(byte,
        keepExif: false,
        quality: 75,
        minHeight: 1024,
        minWidth: 1024,
        format: CompressFormat.webp);
    imageFile.writeAsBytesSync(wmImage);

    String aaa = "";
    final directory = await getExternalStorageDirectory();
    final dirPath = '${directory!.path}/temp_image' ;
    await Directory(dirPath).create().then((Directory directory) {
      aaa = directory.path;
    });
    String formattedDate = DateFormat('yyyyMMddkkmmss').format(DateTime.now());
    File newImagessss = await writeToFile(wmImage,aaa+"/${formattedDate}.jpg");
    debugPrint("nefdfdfwImagessss ==> ${newImagessss.path}");

    return newImagessss;
  }

  static Future<File> writeToFile(List<int> image, String filePath) {
    return File(filePath).writeAsBytes(image, flush: true);
  }


  static getFileSizeInKB(File file) async {
    int bytes = await file.length();
    return bytes / 1024;
  }

  static Future<File> cropImageFile(File imageFile) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3.5, ratioY: 6),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            showCropGrid: false,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Crop your image',
        ));
    return croppedFile!;
  }

  static Future<File> addWaterMark(File imageFile) async {
    final byteData = await rootBundle.load('assets/watermark.png');
    final watermarkFile =
        File('${(await getTemporaryDirectory()).path}/watermark.png');
    await watermarkFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    image.Image? originalImage = image.decodeImage(imageFile.readAsBytesSync());
    image.Image? watermarkImage = image.decodeImage(watermarkFile.readAsBytesSync());

    originalImage = maintainMaximumSize(originalImage!, maxWidth, maxHeight);
    originalImage = maintainSize(originalImage, 800, 1024);

    int scaledH = (originalImage.height * 0.50).toInt();
    int scaledW = watermarkImage!.width * scaledH ~/ watermarkImage.height;

    watermarkImage =
        maintainSize(watermarkImage, scaledW.toDouble(), scaledH.toDouble());

    image.Image watermark = image.Image(scaledW, scaledH);
    image.drawImage(watermark, watermarkImage);

    image.copyInto(originalImage, watermark,
        dstX: originalImage.width - watermark.width - 40,
        dstY: (originalImage.height - watermark.height) ~/ 2);

    List<int> wmImage = image.encodePng(originalImage);
    imageFile.writeAsBytesSync(wmImage);

    return imageFile;
  }

  static image.Image maintainSize(
      image.Image originalImage, double minW, double minH) {
    if (originalImage.height < minH || originalImage.width < minW) {
      if (originalImage.width < minW) {
        double newH = (originalImage.height * minW) / originalImage.width;
        originalImage = image.copyResize(originalImage,
            width: minW.toInt(), height: newH.toInt());
      }
      if (originalImage.height < minH) {
        double newW = (originalImage.width * minH) / originalImage.height;
        originalImage = image.copyResize(originalImage,
            width: newW.toInt(), height: minH.toInt());
      }
    }
    return originalImage;
  }

  static image.Image maintainMaximumSize(
      image.Image originalImage, double maxW, double maxH) {
    if (originalImage.height > maxH || originalImage.width > maxW) {
      if (originalImage.width > maxW) {
        double newH = (originalImage.height * maxW) / originalImage.width;
        originalImage = image.copyResize(originalImage,
            width: maxW.toInt(), height: newH.toInt());
      }
      if (originalImage.height > maxH) {
        double newW = (originalImage.width * maxH) / originalImage.height;
        originalImage = image.copyResize(originalImage,
            width: newW.toInt(), height: maxH.toInt());
      }
    }
    return originalImage;
  }


  static Future<void> clearCache() async {
    final cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache();
    print('Cache cleared');
  }
  static Future<void> clearStorage() async {
    final directory = await getApplicationSupportDirectory();
    final contents = directory.listSync(recursive: true);
    for (final content in contents) {
      await content.delete(recursive: true);
    }
    print('Storage cleared');
  }


  static String profileImageUrl = 'https://sunharerishtey.in/image-upload/public/api/profile';

  static Future<String> uploadProfileImage(File imageFile) async{


    Map<String, String> header = {
      "Content-type": "multipart/form-data; boundary=*****",
      "Connection": "Keep-Alive",
    };

    var request = http.MultipartRequest('POST', Uri.parse(profileImageUrl),);
    request.files.add(await http.MultipartFile.fromPath('profile[]', imageFile.path));
    request.headers.addAll(header);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    debugPrint("imageFile.path ==> ${imageFile.path}");
    debugPrint("aaasdsdsdsdsd ==> ${response.statusCode}");


    List<String> dataList = [];
    if (response.statusCode == 200) {

       GetImageModel allData = GetImageModel.fromJson(jsonDecode(response.body));
       dataList = allData.profile;
    }else{
      dataList.add("");
      Fluttertoast.showToast(msg: "Something Wrong,Please Select Image Again.");
    }
    debugPrint("dataList[0] ==> ${dataList[0]}");
    return dataList[0];
  }

  static String documentsImageUrl = 'https://sunharerishtey.in/image-upload/public/api/documents';

  static Future<String> uploadDocumentsImage(File imageFile) async{

    Map<String, String> header = {
      "Content-type": "multipart/form-data; boundary=*****",
      "Connection": "Keep-Alive",
    };

    var request = http.MultipartRequest('POST', Uri.parse(documentsImageUrl),);
    request.files.add(await http.MultipartFile.fromPath('documents[]', imageFile.path));
    request.headers.addAll(header);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    debugPrint("imageFile.path ==> ${imageFile.path}");
    debugPrint("aaasdsdsdsdsd ==> ${response.statusCode}");


    List<String> dataList = [];
    if (response.statusCode == 200) {

      GetDocumentModel allData = GetDocumentModel.fromJson(jsonDecode(response.body));
      dataList = allData.documents;
    }else{
      dataList.add("");
      Fluttertoast.showToast(msg: "Something Wrong,Please Select Image Again.");
    }
    debugPrint("dataList[0] ==> ${dataList[0]}");
    return dataList[0];

  }
}
