import './coordinates.dart';
import './photo.dart';

class Report {
  final Photo photo;
  String comment = '';
  final Coordinates coordinates;

  Report({required this.photo, this.comment = '', required this.coordinates});

  Report.empty()
      : photo = Photo.empty(),
        coordinates = Coordinates.empty();

  @override
  String toString() => '<Report> photo: ${photo.toString()}, '
      'comment: $comment, coordinates: ${coordinates.toString()}';
}
