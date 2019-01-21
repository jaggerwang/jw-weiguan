import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme.dart';
import '../../models/models.dart';

class ImagesPlayerPage extends StatelessWidget {
  final List<ImageEntity> images;
  final List<File> files;
  final int initialIndex;

  ImagesPlayerPage({
    Key key,
    this.images = const [],
    this.files = const [],
    this.initialIndex = 0,
  })  : assert(images.length != 0 || files.length != 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Body(
        images: images,
        files: files,
        initialIndex: initialIndex,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<ImageEntity> images;
  final List<File> files;
  final int initialIndex;

  _Body({
    Key key,
    this.images = const [],
    this.files = const [],
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: Feedback.wrapForTap(() => Navigator.of(context).pop(), context),
      child: Container(
        color: WgTheme.blackDark,
        child: CarouselSlider(
          items: images.length > 0
              ? images
                  .map<CachedNetworkImage>((image) => CachedNetworkImage(
                        imageUrl: image.url,
                        placeholder: Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      ))
                  .toList()
              : files
                  .map<Image>((image) => Image.file(
                        image,
                        fit: BoxFit.contain,
                      ))
                  .toList(),
          viewportFraction: 1.0,
          height: screenSize.height,
          initialPage: initialIndex,
        ),
      ),
    );
  }
}
