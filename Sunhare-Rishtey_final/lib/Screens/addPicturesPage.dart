import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import '/Providers/getUserInfo.dart';
import '/main.dart';
import '../models/ImageModel.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPicturesScreen extends StatefulWidget {
  final List<ImageModel> imageList;
  AddPicturesScreen(this.imageList);
  @override
  _AddPicturesScreenState createState() => _AddPicturesScreenState();
}

class _AddPicturesScreenState extends State<AddPicturesScreen> {




  int idx = 0;
  List<ImageModel> list = [];
  @override
  void initState() {
    // list = Provider.of<ImageListProvider>(context, listen: false).imageList;
    // imageList = [...list];
    super.initState();
  }

  int ind = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorCompanion,
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              FirebaseDatabase.instance
                  .reference()
                  .child("Images")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .child(widget.imageList[ind].id)
                  .remove()
                  .then((value) {
                if (widget.imageList.length == 1) {
                  widget.imageList.clear();
                }
                Fluttertoast.showToast(msg: 'Deleted successfully');
                Navigator.of(context).pop(true);
                setState(() {
                  // list.removeWhere(
                  //     (element) => element.id == imageList[ind].id);
                  // imageList.removeWhere(
                  //     (element) => element.id == imageList[ind].id);
                });
              });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            label: Text(
              'Delete',
              style: GoogleFonts.workSans(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      // Implemented with a PageView, simpler than setting it up yourself
      // You can either specify images directly or by using a builder as in this tutorial
      body: Stack(
        children: [
          PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageList.length,
              itemBuilder: (context, index) {
                ind = index;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width * .7,
                    height: height * .7,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageList[index].imageUrl,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                );
              }),
          widget.imageList.length != 0
              ? Positioned(
                  bottom: MediaQuery.of(context).size.width * .01,
                  left: MediaQuery.of(context).size.width * .30,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final currUser = FirebaseAuth.instance.currentUser!.uid;
                      String image =
                          Provider.of<CurrUserInfo>(context, listen: false)
                              .currentUser
                              .imageUrl ?? "";

                      if (widget.imageList[ind].isVerified) {
                        FirebaseDatabase.instance
                            .reference()
                            .child('Images')
                            .child(currUser)
                            .child(widget.imageList[ind].id)
                            .update({'imageURL': image});

                        FirebaseDatabase.instance
                            .reference()
                            .child('User Information')
                            .child(currUser)
                            .update({
                          'imageURL': widget.imageList[ind].imageUrl
                        }).then((value) {
                          Provider.of<CurrUserInfo>(context, listen: false)
                              .updateImageUrl(widget.imageList[ind].imageUrl);
                          // final res = Provider.of<ImageListProvider>(context,
                          //     listen: false);
                          // res.addImage(ImageModel(
                          //     id: widget.imageList[ind].id, imageUrl: tempImage));
                          // res.removeImage(widget.imageList[ind].id);

                          Navigator.of(context).pop(true);
                          Fluttertoast.showToast(msg: 'Updated Successfully');
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'Your profile is not verified yet please wait for image verification');
                      }
                      //  final tempImage = image;
                    },
                    // color: theme.colorCompanion,
                    icon: Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Set as Profile',
                      style: GoogleFonts.workSans(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
