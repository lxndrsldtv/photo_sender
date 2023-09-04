class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates({required this.longitude, required this.latitude});

  Coordinates.empty()
      : longitude = double.nan,
        latitude = double.nan;

  @override
  String toString() =>
      '<Coordinates> longitude: $longitude, latitude: $latitude';
}
