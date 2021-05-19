import 'package:tiny_compiler/Controllers/file_map.dart';
import 'package:tiny_compiler/Models/token.dart';

import 'package:tiny_compiler/Utils/string_ext.dart';
import 'package:tiny_compiler/Utils/string_buffer_ext.dart';

/// The tiny language [Scanner].
class Scanner {
  // ignore: unused_field
  final FileMap _fileMap;
  // ignore: unused_field
  final int _length;
  int _currentIndex = -1;

  Scanner(FileMap fileMap)
      : _fileMap = fileMap,
        _length = fileMap.length;

  bool _moveNext() {
    ++_currentIndex;
    return _currentIndex < _length;
  }

  /// Limited to one consecutive backward move.
  bool _moveBack() {
    --_currentIndex;
    return _currentIndex >= 0;
  }

  /// Current charachter as string
  int get currentCharacterCode => _fileMap.charByte(_currentIndex);
  String get currentCharacter => String.fromCharCode(currentCharacterCode);

  Token read() {
    StringBuffer buffer = StringBuffer();
    AutomatonState state = AutomatonState.Start;

    while (_moveNext()) {
      // For debugging //print("charCode: $currentCharacterCode | char: $currentCharacter");

      String char = currentCharacter;
      int charCode = currentCharacterCode;
      if (buffer.isNotEmpty || !isWhiteSpace(charCode)) buffer.write(char);

      // Automata transitions
      switch (state) {
        ////    Start state   ////
        case AutomatonState.Start:
          switch (char) {
            // Special symbols
            case '+':
              state = AutomatonState.Plus;
              break;
            case '-':
              state = AutomatonState.Minus;
              break;
            case '*':
              state = AutomatonState.Multiply;
              break;
            case '/':
              state = AutomatonState.Divide;
              break;
            case ';':
              state = AutomatonState.Semicolon;
              break;
            case ':':
              state = AutomatonState.Colon;
              break;
            case '=':
              state = AutomatonState.Equal;
              break;
            case '>':
              state = AutomatonState.GTGE;
              break;
            case '<':
              state = AutomatonState.LTLENE;
              break;
            case '(':
              state = AutomatonState.LeftParenthesis;
              break;
            case ')':
              state = AutomatonState.RightParenthesis;
              break;

            // Comment
            case '{':
              state = AutomatonState.In_Comment;
              break;

            // Keywords
            case 'e':
              state = AutomatonState.Else_End;
              break;
            case 'i':
              state = AutomatonState.If_2;
              break;
            case 'r':
              state = AutomatonState.Read_Repeat_1;
              break;
            case 't':
              state = AutomatonState.Then_4;
              break;
            case 'u':
              state = AutomatonState.Until_5;
              break;
            case 'w':
              state = AutomatonState.Write_5;
              break;
            default:
              // Trims white space and continue to the next character in the loop.
              if (isWhiteSpace(charCode)) continue;
              // Numbers
              if (isDigit(charCode)) {
                state = AutomatonState.In_Integer;
                break;
              }
              // Identifiers
              if (isLetter(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              return InvalidToken(TokenType.Invalid, buffer.toString());
          }
          break;
        ////  Finished start state  ////

        ////  Comment state  ////
        case AutomatonState.In_Comment:
          switch (char) {
            case '}':
              state = AutomatonState.Start;
              buffer.clear();
              break;
            default:
              continue;
          }
          break;

        ////  Assignment state  ////
        case AutomatonState.Colon:
          switch (char) {
            case '=':
              state = AutomatonState.Assignment;
              break;
            default:
              return InvalidToken(TokenType.Invalid, buffer.toString());
          }
          break;
        ////  Finished assignment state  ////

        ////  Identifiers and numbers states  ////
        case AutomatonState.In_Identifier:
          if (!isLetter(charCode) && !isDigit(charCode))
            state = AutomatonState.Identifier;
          break;
        case AutomatonState.In_Integer:
          if (char == '.')
            state = AutomatonState.In_Float;
          else if (!isDigit(charCode)) state = AutomatonState.Number;
          break;
        case AutomatonState.In_Float:
          if (!isDigit(charCode)) state = AutomatonState.Number;
          break;
        ////  Finished identifiers and numbers states  ////

        ////  Special symbols states  ////
        case AutomatonState.GTGE:
          switch (char) {
            case '=':
              state = AutomatonState.GreaterEqual;
              break;
            default:
              state = AutomatonState.GreaterThan;
          }
          break;
        case AutomatonState.LTLENE:
          switch (char) {
            case '=':
              state = AutomatonState.LessEqual;
              break;
            case '>':
              state = AutomatonState.NotEqual;
              break;
            default:
              state = AutomatonState.LessThan;
          }
          break;
        ////  Finished special symbols states  ////

        ////  Keywords states  ////
        // Else_End
        case AutomatonState.Else_End:
          switch (char) {
            case 'l':
              state = AutomatonState.Else_3;
              break;
            case 'n':
              state = AutomatonState.End_2;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;

        // Else
        case AutomatonState.Else_3:
          switch (char) {
            case 's':
              state = AutomatonState.Else_2;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Else_2:
          switch (char) {
            case 'e':
              state = AutomatonState.Else_1;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Else_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Else;
          }
          break;

        // End
        case AutomatonState.End_2:
          switch (char) {
            case 'd':
              state = AutomatonState.End_1;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.End_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.End;
          }
          break;

        // If
        case AutomatonState.If_2:
          switch (char) {
            case 'f':
              state = AutomatonState.If_1;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.If_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.If;
          }
          break;

        // Read_Repeat
        case AutomatonState.Read_Repeat_1:
          switch (char) {
            case 'e':
              state = AutomatonState.Read_Repeat;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Read_Repeat:
          switch (char) {
            case 'a':
              state = AutomatonState.Read_2;
              break;
            case 'p':
              state = AutomatonState.Repeat_4;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;

        // Read
        case AutomatonState.Read_2:
          switch (char) {
            case 'd':
              state = AutomatonState.Read_2;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Read_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Read;
          }
          break;

        // Repeat
        case AutomatonState.Repeat_4:
          switch (char) {
            case 'e':
              state = AutomatonState.Repeat_3;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Repeat_3:
          switch (char) {
            case 'a':
              state = AutomatonState.Repeat_2;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Repeat_2:
          switch (char) {
            case 't':
              state = AutomatonState.Repeat_1;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Repeat_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Repeat;
          }
          break;

        // Then
        case AutomatonState.Then_4:
          switch (char) {
            case 'h':
              state = AutomatonState.Then_3;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Then_3:
          switch (char) {
            case 'e':
              state = AutomatonState.Then_2;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Then_2:
          switch (char) {
            case 'n':
              state = AutomatonState.Then_1;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Then_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Then;
          }
          break;

        // Until
        case AutomatonState.Until_5:
          switch (char) {
            case 'n':
              state = AutomatonState.Until_4;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Until_4:
          switch (char) {
            case 't':
              state = AutomatonState.Until_3;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Until_3:
          switch (char) {
            case 'i':
              state = AutomatonState.Until_2;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Until_2:
          switch (char) {
            case 'l':
              state = AutomatonState.Until_1;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Until_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Until;
          }
          break;

        // Write
        case AutomatonState.Write_5:
          switch (char) {
            case 'r':
              state = AutomatonState.Write_4;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Write_4:
          switch (char) {
            case 'i':
              state = AutomatonState.Write_3;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Write_3:
          switch (char) {
            case 't':
              state = AutomatonState.Write_2;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Write_2:
          switch (char) {
            case 'e':
              state = AutomatonState.Write_1;
              break;
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Identifier;
          }
          break;
        case AutomatonState.Write_1:
          switch (char) {
            default:
              if (isLetter(charCode) || isDigit(charCode)) {
                state = AutomatonState.In_Identifier;
                break;
              }
              state = AutomatonState.Write;
          }
          break;
        default:
          print("Not a valid state: $state");
        ////  Finished keywords states  ////
      }

      // For debugging //print("StringBuffer: ${buffer} | ${buffer.length}");

      ////  Accepting states  ////
      switch (state) {
        // Special symbols
        case AutomatonState.Plus:
          return OperatorToken(TokenType.Plus, buffer.toString());
        case AutomatonState.Minus:
          return OperatorToken(TokenType.Minus, buffer.toString());
        case AutomatonState.Multiply:
          return OperatorToken(TokenType.Multiply, buffer.toString());
        case AutomatonState.Divide:
          return OperatorToken(TokenType.Divide, buffer.toString());
        case AutomatonState.Equal:
          return OperatorToken(TokenType.Equal, buffer.toString());
        case AutomatonState.GreaterThan:
          _moveBack();
          return OperatorToken(TokenType.GreaterThan, buffer.retracted());
        case AutomatonState.GreaterEqual:
          return OperatorToken(TokenType.GreaterEqual, buffer.toString());
        case AutomatonState.LessThan:
          _moveBack();
          return OperatorToken(TokenType.LessThan, buffer.retracted());
        case AutomatonState.LessEqual:
          return OperatorToken(TokenType.LessEqual, buffer.toString());
        case AutomatonState.NotEqual:
          return OperatorToken(TokenType.NotEqual, buffer.toString());
        case AutomatonState.Semicolon:
          return OperatorToken(TokenType.Semicolon, buffer.toString());
        case AutomatonState.Assignment:
          return OperatorToken(TokenType.Assignment, buffer.toString());
        case AutomatonState.LeftParenthesis:
          return OperatorToken(TokenType.LeftParenthesis, buffer.toString());
        case AutomatonState.RightParenthesis:
          return OperatorToken(TokenType.RightParenthesis, buffer.toString());
        // Keywords
        case AutomatonState.Else:
          _moveBack();
          return KeywordToken(TokenType.Else, buffer.retracted());
        case AutomatonState.End:
          _moveBack();
          return KeywordToken(TokenType.End, buffer.retracted());
        case AutomatonState.If:
          _moveBack();
          return KeywordToken(TokenType.If, buffer.retracted());
        case AutomatonState.Read:
          _moveBack();
          return KeywordToken(TokenType.Read, buffer.retracted());
        case AutomatonState.Repeat:
          _moveBack();
          return KeywordToken(TokenType.Repeat, buffer.retracted());
        case AutomatonState.Then:
          _moveBack();
          return KeywordToken(TokenType.Then, buffer.retracted());
        case AutomatonState.Until:
          _moveBack();
          return KeywordToken(TokenType.Until, buffer.retracted());
        case AutomatonState.Write:
          _moveBack();
          return KeywordToken(TokenType.Write, buffer.retracted());
        // Identifiers and numbers
        case AutomatonState.Identifier:
          _moveBack();
          return IdentifierToken(buffer.retracted());
        case AutomatonState.Number:
          _moveBack();
          return NumberToken(buffer.retracted());
        ////  Finished accepting states  ////

        default:
        // For debugging //print("Not an accepting state: $state");
      }
    }

    return InvalidToken(TokenType.EndOfFile, buffer.toString());
  }
}

/// The [AutomatonState]s of the DFA.
/// [AutomatonState]s commented with A are accepting [AutomatonState]s.
enum AutomatonState {
  Start,

  In_Identifier,
  // A
  Identifier,

  In_Integer,
  In_Float,
  // A
  Number,

  In_Comment,

  // A
  Plus,
  // A
  Minus,
  // A
  Multiply,
  // A
  Divide,
  // A
  Semicolon,
  Colon,
  // A
  Assignment,
  // A
  LeftParenthesis,
  // A
  RightParenthesis,

  // A
  Equal,
  // GreaterThan_GreaterEqual
  GTGE,
  // A
  GreaterThan,
  // A
  GreaterEqual,
  // LessThan_LessEqual_NotEqual
  LTLENE,
  // A
  LessThan,
  // A
  LessEqual,
  // A
  NotEqual,

  Else_End,
  Else_3,
  Else_2,
  Else_1,
  // A
  Else,
  End_2,
  End_1,
  // A
  End,

  If_2,
  If_1,
  // A
  If,

  Read_Repeat_1,
  Read_Repeat,
  Read_2,
  Read_1,
  // A
  Read,
  Repeat_4,
  Repeat_3,
  Repeat_2,
  Repeat_1,
  // A
  Repeat,

  Then_4,
  Then_3,
  Then_2,
  Then_1,
  // A
  Then,

  Until_5,
  Until_4,
  Until_3,
  Until_2,
  Until_1,
  // A
  Until,

  Write_5,
  Write_4,
  Write_3,
  Write_2,
  Write_1,
  // A
  Write,
}

/// Checks if the character code is of a digit.
bool isDigit(int charCode) => charCode >= '0'.code && charCode <= '9'.code;

/// Checks if the character code is of an alphabetical char.
bool isLetter(int charCode) =>
    (charCode >= 'a'.code && charCode <= 'z'.code) ||
    (charCode >= 'A'.code && charCode <= 'Z'.code);

bool isWhiteSpace(int charCode) =>
    charCode == ' '.code ||
    charCode == '\t'.code ||
    charCode == '\n'.code ||
    charCode == '\r'.code;
