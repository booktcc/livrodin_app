import 'dart:io';

import 'package:flutter/material.dart';
import 'package:livrodin/configs/themes.dart';

enum ProfileSize {
  sm(28),
  md(32),
  lg(64),
  xl(100);

  const ProfileSize(this.value);
  final double value;
}

enum ImageType {
  network,
  file,
}
class ProfileIcon extends StatefulWidget {
  final String? image;
  final ProfileSize size;
  final ImageType imageType;
  const ProfileIcon({
    super.key,
    this.image,
    this.size = ProfileSize.xl,
    this.imageType = ImageType.network,
  });

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  @override
  Widget build(BuildContext context) {
    bool hasImage = widget.image != null && widget.image!.isNotEmpty;

    return Container(
      width: widget.size.value,
      height: widget.size.value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: grey,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0.0, 4.0),
            blurRadius: 4.0,
          ),
        ],
        image: hasImage
            ? DecorationImage(
                image: widget.imageType == ImageType.network ? Image.network(
                  widget.image!,
                ).image : Image.file(
                  File(widget.image!),
                ).image,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasImage
          ? Center(
              child: Icon(Icons.person,
                  color: Colors.white, size: widget.size.value * 0.9),
            )
          : null,
    );
  }
}
