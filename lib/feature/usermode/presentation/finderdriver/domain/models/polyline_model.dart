class PolylineModel {
  final double? duration;
  final double? distance;
  

  PolylineModel({this.duration, this.distance, });

  // ສ້າງ Banner ຈາກ JSON ຂໍ້ມູນ
  factory PolylineModel.fromJson(Map<String, dynamic> json) {
    return PolylineModel(
      duration: json['duration'] / 60,
      distance: json['distance'] / 1000,

    );
  }

  // ແປງ Banner ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {'duration': duration, 'distance': distance};
  }
}
