import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class FileMap {
  final File _file;
  final Uint8List _bytes;

  FileMap._create(
    this._file,
    this._bytes,
  );

  static Future<FileMap> fromPath(String path, [bool padEnd = true]) async {
    final File file = File(path);
    final bytes = await file.readAsBytes();

    return FileMap._create(
      file,
      padEnd ? Uint8List.fromList(bytes + [10]) : bytes,
    );
  }

  static Future<FileMap> fromString(String code, [bool padEnd = true]) async {
    final bytes = await compute(utf8.encode, code);

    return FileMap._create(
      File("temp"),
      Uint8List.fromList(padEnd ? bytes + [10] : bytes),
    );
  }

  int get length => _bytes.length;

  Uint8List get bytes => _bytes;
  int charByte(int n) => _bytes.elementAt(n);
  Future<String> readAsString() async => compute(utf8.decode, _bytes);

  Iterator<int> get startIterator => bytes.iterator;
}
