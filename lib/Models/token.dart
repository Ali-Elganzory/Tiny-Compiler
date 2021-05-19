/// [Token] structure that contains its [type] and [value].
/// It also incorporates a [toString].
abstract class Token {
  TokenType get type;
  Object get value;
  String toString() => value.toString();
}

/// Invalid tokens like [Token.Invalid], generally, or [Token.EndOfLine].
class InvalidToken implements Token {
  const InvalidToken(this._type, this._value);
  final TokenType _type;
  final String _value;

  TokenType get type => _type;
  String get value => type == TokenType.EndOfFile ? type.toString() : _value;
}

/// Language keywords like if and repeat.
class KeywordToken implements Token {
  const KeywordToken(this._tokenType, this._value);
  final TokenType _tokenType;
  final String _value;

  TokenType get type => _tokenType;
  String get value => _value;
}

/// Identifier tokens like variable names.
class IdentifierToken implements Token {
  const IdentifierToken(this._value);
  final String _value;

  TokenType get type => TokenType.Identifier;
  String get value => _value;
}

/// Numbers
class NumberToken implements Token {
  NumberToken(String value) : _value = num.tryParse(value) ?? -311;
  final num _value;

  TokenType get type => TokenType.Number;
  num get value => _value;
}

/// All operators: assignment, arithmatic, and relational.
class OperatorToken implements Token {
  const OperatorToken(this._tokenType, this._value);
  final TokenType _tokenType;
  final String _value;

  TokenType get type => _tokenType;
  String get value => _value;
}

// Other single symbol token
class SingleSymbolToken implements Token {
  const SingleSymbolToken(this._tokenType, this._value);
  final TokenType _tokenType;
  final int _value;

  TokenType get type => _tokenType;
  int get value => _value;
  String toString() => String.fromCharCode(value);
}

/// Token types in this language
enum TokenType {
  // Invalid tokens
  Invalid,
  EndOfFile,

  // Reserved keywords
  Keyword,

  Identifier,
  Number,

  Assignment,

  // Arithmatic operators
  Plus,
  Minus,
  Multiply,
  Divide,

  // Relational operators
  Equal,
  NotEqual,
  GreaterThan,
  LessThan,
  GreaterEqual,
  LessEqual,

  // Comment enclosers
  LeftBraces,
  RightBraces,

  // Other symbols
  Semicolon,
  LeftParenthesis,
  RightParenthesis,

  // Language [Keyword]s
  If,
  Then,
  Else,
  End,
  Repeat,
  Until,
  Read,
  Write,
}
