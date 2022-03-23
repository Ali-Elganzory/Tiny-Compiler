import 'dart:io';

import 'dart:typed_data';

class FileMap {
  // ignore: unused_field
  final File _file;
  final Uint8List _fileBytes;

  FileMap._create(
    this._file,
    this._fileBytes,
  );

  static Future<FileMap> fromPath(String path, [bool padEnd = true]) async {
    final File file = File(path);
    final Uint8List bytes = await file.readAsBytes();

    return FileMap._create(
      file,
      bytes,
    );
  }

  int get length => _fileBytes.length;

  Uint8List get bytes => _fileBytes;
  int charByte(int n) => _fileBytes.elementAt(n);
  Future<String> readAsString() async => _file.readAsString();

  Iterator<int> get startIterator => bytes.iterator;
}
