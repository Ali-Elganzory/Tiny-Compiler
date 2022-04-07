import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';
import 'package:tiny_compiler/Controllers/parser.dart';
import 'package:tiny_compiler/Models/syntax_tree.dart';

// import './/Controllers/audio_player.dart';
import './/Controllers/file_map.dart';
import './/Controllers/scanner.dart';
import './/Models/token.dart';

class TinyController extends ChangeNotifier {
  /************************************
   * State
   ************************************/

  /// Source code
  String _filePath = "";
  final TextEditingController sourceCodeEditorController =
      TextEditingController();

  String get filePath => _filePath;
  String get sourceCode => sourceCodeEditorController.text;

  // Scanned tokens
  final List<Token> _tokens = [];
  List<Token> get tokens => [..._tokens];

  // Parsed syntax tree.
  SyntaxTreeNode? _syntaxTree;
  SyntaxTreeNode? get syntaxTree => _syntaxTree;
  bool get hasSyntaxTree => _syntaxTree != null;

  bool _ready = true;
  bool get ready => _ready;
  set ready(bool v) {
    _ready = v;
    notifyListeners();
  }

  /// Loading file flag.
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

  // Errors
  Token? _invalidToken;
  Token? get invalidToken => _invalidToken;
  bool _hasParseError = false;
  bool get hasParseError => _parseError.isNotEmpty;
  String _parseError = "";
  String get parseError => "" + _parseError;

  /************************************
   * Public Interface
   ************************************/

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

      // Parse code.
      final FileMap fileMap = await FileMap.fromString(
        sourceCodeEditorController.text,
      );
      final Scanner scanner = Scanner(fileMap);
      final Parser parser = Parser(scanner);
      parser.parse();

      // Load scanned tokens.
      final scannedTokens = scanner.scannedTokens;
      _tokens.addAll(
        scanner.scannedTokens.getRange(0, scanner.scannedTokens.length - 1),
      );

      final lastToken = scannedTokens.last;
      if (lastToken.type == TokenType.Invalid) {
        isInvalidSourceCode = true;
        _invalidToken = lastToken;
      }

      // Load syntax tree.
      _syntaxTree = parser.syntaxTree;
      _parseError = parser.errorMessage;
    }
    ready = true;
  }
}

/************************************
 * Utilities
 ************************************/

/// Show a platform window to pick a source code file and get its path.
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
