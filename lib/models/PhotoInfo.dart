class PhotoInfo {
  final int id;
  final String imgSrc;
  final String earthDate;
  final String roverName;
  final String cameraName;
  bool isFavorite;

  PhotoInfo(this.id,
      this.imgSrc,
      this.earthDate,
      this.roverName,
      this.cameraName,
      this.isFavorite
      );

  static PhotoInfo fromMap(Map<String, dynamic> map) {
    return PhotoInfo(
      map['id'],
      map['imgSrc'],
      map['earthDate'],
      map['roverName'],
      map['cameraName'],
      map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgSrc': imgSrc,
      'earthDate': earthDate,
      'roverName': roverName,
      'cameraName': cameraName,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  static PhotoInfo fromJson(Map<String, dynamic> json) {
    return PhotoInfo(
      json['id'],
      json['img_src'],
      json['earth_date'],
      json['rover']['name'],
      json['camera']['full_name'],
      json['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_src': imgSrc,
      'earth_date': earthDate,
      'rover': {'name': roverName},
      'camera': {'full_name': cameraName},
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

}