import 'dart:typed_data';

import 'package:image/image.dart';

class Photo {
  final String fileName;
  final Uint8List bytes;
  Uint8List? _encoded;
  bool _isEmpty;

  Photo({required this.fileName, required this.bytes}) : _isEmpty = false;

  Photo.empty()
      : fileName = '',
        bytes = Uint8List(0),
        _isEmpty = true;

  Uint8List? get encoded {
    if (_isEmpty) return null;
    try {
      return _encoded ??= encodeBmp(decodeImage(bytes) ?? Image.empty());
    } catch (e) {
      rethrow;
    }
  }

  @override
  String toString() =>
      '<Photo> fileName: $fileName, bytes.length: ${bytes.length}';
}
