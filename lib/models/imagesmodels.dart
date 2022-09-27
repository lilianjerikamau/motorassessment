class ImageList {
  ImageList(this.images);

  List<Images> images;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'photolist': images,
      };
}

class Images {
  Images({required this.filename, required this.attachment});

  String filename;
  String attachment;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'attachment': attachment,
        'filename': filename,
      };

  void add(Images images) {}
}
