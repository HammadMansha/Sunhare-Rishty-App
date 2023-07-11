import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AllPicturesScreen extends StatefulWidget {
  final List<String> imageList;
  AllPicturesScreen(this.imageList);
  @override
  _AllPicturesScreenState createState() => _AllPicturesScreenState();
}

class _AllPicturesScreenState extends State<AllPicturesScreen> {
  TransformationController viewController = TransformationController();
  TapDownDetails? _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (viewController.value != Matrix4.identity()) {
      viewController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      viewController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)

        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      // PageView.builder(
      //   itemCount: widget.imageList.length,
      //   itemBuilder: (context, index) {
      //    return PhotoView(
      //        enableRotation: true,basePosition: Alignment.center,
      //        imageProvider: CachedNetworkImageProvider(widget.imageList[index]));
      // },)

      PhotoViewGallery.builder(
        itemCount: widget.imageList.length,
        builder: (context, index) {
          // return CachedNetworkImage(imageUrl: imageUrl)
          return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(widget.imageList[index]),
            // Contained = the smallest possible size to fit one dimension of the screen
            minScale: PhotoViewComputedScale.contained * 0.8,
            // Covered = the smallest possible size to fit the whole screen
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        // Set the background color to the "classic white"
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
