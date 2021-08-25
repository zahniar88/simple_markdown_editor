import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkMarkdown extends StatelessWidget {
  const ImageNetworkMarkdown({
    Key? key,
    required this.uri,
    this.title,
  }) : super(key: key);

  final String uri;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: uri,
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: Container(
          width: 300,
          height: 220,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Container(
          width: 300,
          height: 220,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: Text(error.toString()),
        ),
      ),
    );
  }
}
