import 'package:flutter/material.dart';
import 'dart:io';

class PostDTO {
  String? savedCount;
  String? latitude;
  String? longitude;
  String? imageFile;
  String? postDate;

// added '?'

  PostDTO(
      {this.savedCount,
      this.latitude,
      this.longitude,
      this.imageFile,
      this.postDate});
  // can also add 'required' keyword
}
