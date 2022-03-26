import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';

// import './/Controllers/audio_player.dart';
import './/Controllers/file_map.dart';
import './/Controllers/scanner.dart';
import './/Models/token.dart';

class TinyController extends ChangeNotifier {
  // Source code
  String _filePath = "";
  final TextEditingController sourceCodeEditorController =
      TextEditingController();

  String get filePath => _filePath;
  String get sourceCode => sourceCodeEditorController.text;

  // Scanned tokens
  final List<Token> _tokens = [];
  List<Token> get tokens => [..._tokens];

  bool _ready = true;
  bool get ready => _ready;
  set ready(bool v) {
    _ready = v;
    notifyListeners();
  }

  /// Load the source code from a file
  Future<bool> loadSourceCodeFile() async {
    if (isLoadingFile) return false;

    ready = false;
    String path = await compute<void, String>(_pickSourceCodeFilePath, null);
    _filePath = path;
    if (path.isEmpty) {
      ready = false;
      return false;
    }

    isLoadingFile = true;
    {
      isLoadingSourceCode = true;
      sourceCodeEditorController.text =
          await (await FileMap.fromPath(path)).readAsString();
      isLoadingSourceCode = false;
    }
    isLoadingFile = false;

    {
      _tokens.clear();
      notifyListeners();
    }

    // AudioPlayer.playAssetAudio("assets/audio/meow01.wav");

    ready = true;
    return true;
  }

  /// Scan (i.e., tokenize) the source code.
  Future<void> scanSourceCode() async {
    if (!ready) return;

    ready = false;
    {
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
    }
    ready = true;
  }

  Token? _invalidToken;
  Token? get invalidToken => _invalidToken;

  ///////////////////////
  //      Flags
  ///////////////////////

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
}

///////////////////////
//      Utils
///////////////////////

Future<String> _pickSourceCodeFilePath(void _) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowedExtensions: ["tiny"],
    dialogTitle: "Select a source code file",
  );

  if (result == null) {
    return "";
  }

  return result.files.single.path ?? "";
}
