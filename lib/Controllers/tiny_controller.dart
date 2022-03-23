import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:filepicker_windows/filepicker_windows.dart';

import './/Controllers/audio_player.dart';
import './/Controllers/file_map.dart';
import './/Controllers/scanner.dart';
import './/Models/token.dart';

class TinyController extends ChangeNotifier {
  String _filePath = "";
  FileMap? _fileMap;
  String _sourceCode = "";
  final TextEditingController sourceCodeEditorController =
      TextEditingController();

  String get filePath => _filePath;
  String get sourceCode => _sourceCode;

  final List<Token> _tokens = [];
  List<Token> get tokens => [..._tokens];

  bool _ready = false;
  bool get ready => _ready;
  set ready(bool v) {
    _ready = v;
    notifyListeners();
  }

  /// Load the source code from a file
  Future<bool> loadSourceCodeFile() async {
    if (isLoadingFile) return false;
    ready = false;
    String path = await _pickSourceCodeFilePath();
    if (path.isEmpty) return false;
    _filePath = path;

    isLoadingFile = true;
    {
      _fileMap = await FileMap.fromPath(path);
    }

    {
      isLoadingSourceCode = true;
      _sourceCode = await _fileMap!.readAsString();
      sourceCodeEditorController.text = _sourceCode;
      isLoadingSourceCode = false;
    }
    isLoadingFile = false;

    {
      _tokens.clear();
      notifyListeners();
    }

    AudioPlayer.playAssetAudio("assets/audio/meow01.wav");

    ready = true;
    return true;
  }

  Future<void> scanSourceCode() async {
    if (!ready) return;

    ready = false;
    isInvalidSourceCode = false;
    _tokens.clear();
    notifyListeners();

    final FileMap fileMap =
        await FileMap.fromString(sourceCodeEditorController.text);
    final Scanner scanner = Scanner(fileMap);
    Token token = scanner.read();
    while (token is! InvalidToken) {
      _tokens.add(token);
      notifyListeners();
      token = scanner.read();
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
