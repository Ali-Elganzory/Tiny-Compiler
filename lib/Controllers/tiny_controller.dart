import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:tiny_compiler/Controllers/audio_player.dart';

import 'package:tiny_compiler/Controllers/file_map.dart';
import 'package:tiny_compiler/Controllers/scanner.dart';
import 'package:tiny_compiler/Models/token.dart';

class TinyController extends ChangeNotifier {
  String _filePath = "";
  FileMap? _fileMap;
  String _sourceCode = "";
  Scanner? _scanner;

  String get filePath => _filePath;
  String get sourceCode => _sourceCode;

  final List<Token> _tokens = [];
  List<Token> get tokens => [..._tokens];

  bool _ready = false;
  bool get ready => _ready;
  set ready(bool v) {
    _ready = v;
    if (v) AudioPlayer.playAssetAudio("assets/audio/meow01.wav");
    notifyListeners();
  }

  Future<bool> loadSourceCodeFile() async {
    ready = false;
    String path = await _pickSourceCodeFilePath();
    if (path.isEmpty) return false;
    _filePath = path;
    {
      isLoadingFile = true;
      _fileMap = await FileMap.fromPath(path);
      isLoadingFile = false;
    }
    {
      isLoadingSourceCode = true;
      _sourceCode = await _fileMap!.readAsString();
      isLoadingSourceCode = false;
    }
    _scanner = Scanner(_fileMap!);
    {
      _tokens.clear();
      notifyListeners();
    }
    ready = true;
    return true;
  }

  Future<void> scanSourceCode() async {
    if (!ready) return;
    ready = false;
    isInvalidSourceCode = false;
    Token token = _scanner!.read();
    while (!(token is InvalidToken)) {
      _tokens.add(token);
      notifyListeners();
      token = _scanner!.read();
    }

    if (token.type == TokenType.Invalid) {
      isInvalidSourceCode = true;
      _invalidToken = token;
    }

    ready = true;
  }

  Future<String> _pickSourceCodeFilePath() async {
    final File? file = (OpenFilePicker()
          ..defaultExtension = "tiny"
          ..fileNameLabel = "Source code"
          ..title = "Select source code file")
        .getFile();

    return file?.path ?? "";
  }

  bool _isLoadingFile = false;
  bool get isLoadingFile => _isLoadingFile;
  set isLoadingFile(bool v) {
    _isLoadingFile = v;
    notifyListeners();
  }

  bool _isLoadingSourceCode = false;
  bool get isLoadingSourceCode => _isLoadingSourceCode;
  set isLoadingSourceCode(bool v) {
    _isLoadingSourceCode = v;
    notifyListeners();
  }

  bool _isInvalidSourceCode = false;
  bool get isInvalidSourceCode => _isInvalidSourceCode;
  set isInvalidSourceCode(bool v) {
    _isInvalidSourceCode = v;
    notifyListeners();
  }

  Token? _invalidToken;
  Token? get invalidToken => _invalidToken;
}
