import 'dart:math';

import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';

import '/Controllers/scanner.dart';
import '/Models/token.dart';
import '/Models/syntax_tree.dart';

/************************************
 * Recursive-descent Implementation
 ************************************/

/// Parser implementation.
/// The implemented algorithm is recursive-descent.
class Parser {
  /// Provide a [scanner] to feed the tokens from.
  Parser(this.scanner);

  /************************************
   * State
   ************************************/

  /// The scanner.
  final Scanner scanner;

  /// Current token.
  late Token token;

  /// Syntax tree cache.
  SyntaxTreeNode? syntaxTree;

  /// Error
  String _errorMessage = "";
  String get errorMessage => "" + _errorMessage;
  bool get hasError => errorMessage.isNotEmpty;

  /************************************
   * Public Interface
   ************************************/

  /// Parse the code from [scanner] and return the root of the syntax tree.
  ///
  /// The syntax tree is cached and returned.
  SyntaxTreeNode? parse() {
    syntaxTree = _parse();
    return syntaxTree;
  }

  /************************************
   * Private Interface
   ************************************/

  /// Parse the code from [scanner] and return the root of the syntax tree.
  SyntaxTreeNode? _parse() {
    token = scanner.read();
    try {
      final syntaxTree = _stmtSequance();
      syntaxTree.annotate();
      return syntaxTree;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }
    return null;
  }

  /// For error.
  void _error() {
    _errorMessage = ("Error parsing token: $token");
    throw Exception(_errorMessage);
  }

  /// For matching a token.
  void _match(Token expectedToken) {
    if (token == expectedToken) {
      token = scanner.read();
    } else {
      debugPrint("Error parsing token: $token");
    }
  }

  SyntaxTreeNode _stmtSequance() {
    final temp = _statement();

    if (token.type == TokenType.Semicolon) {
      final semicolonToken = token as SingleSymbolToken;
      _match(semicolonToken);

      return StmtSequanceSyntaxTreeNode(
        semicolonToken,
        temp,
        _stmtSequance(),
      );
    } else {
      // degrade to a statement if no semicolon is present.
      return temp;
    }
  }

  SyntaxTreeNode _statement() {
    final temp = token;

    switch (token.type) {
      case TokenType.If:
        _match(token);
        final testExp = _exp();
        if (token.type == TokenType.Then) {
          _match(token);
        } else {
          _error();
        }
        final thenBody = _stmtSequance();
        SyntaxTreeNode? elseBody;

        // If else exists.
        if (token.type == TokenType.Else) {
          _match(token);
          elseBody = _stmtSequance();
        }

        if (token.type == TokenType.End) {
          _match(token);
        } else {
          _error();
        }

        return IfStmtSyntaxTreeNode(
          temp as KeywordToken,
          testExp,
          thenBody,
          elseBody,
        );

      case TokenType.Repeat:
        _match(token);
        final stmtSequance = _stmtSequance();
        if (token.type == TokenType.Until) {
          _match(token);
        } else {
          _error();
        }
        final exp = _exp();

        return RepeatStmtSyntaxTreeNode(
          temp as KeywordToken,
          stmtSequance,
          exp,
        );

      case TokenType.Identifier:
        final identifier = _factor();

        final temp = token;
        if (token.type == TokenType.Assignment) {
          _match(token);
        } else {
          _error();
        }

        return AssignStmtSyntaxTreeNode(
          temp as OperatorToken,
          identifier,
          _exp(),
        );

      case TokenType.Read:
        _match(token);
        return ReadStmtSyntaxTreeNode(
          temp as KeywordToken,
          _factor(),
        );

      case TokenType.Write:
        _match(token);
        return WriteStmtSyntaxTreeNode(
          temp as KeywordToken,
          _exp(),
        );

      default:
        throw Exception("Error parsing token: $token");
    }
  }

  //////////// stubs
  SyntaxTreeNode _exp() {
    final simpleExp = _simpleExp();

    if (_isRelationalOperator(token)) {
      final temp = token;
      _match(token);
      return ExpSyntaxTreeNode(
        temp as OperatorToken,
        simpleExp,
        _simpleExp(),
      );
    }

    return simpleExp;
  }

  SyntaxTreeNode _simpleExp() {
    var temp = _term();

    while (_isAddOp(token)) {
      final addOpToken = token;
      _match(token);
      final newTemp = SimpleExpSyntaxTreeNode(
        addOpToken as OperatorToken,
        temp,
        _term(),
      );
      temp = newTemp;
    }

    return temp;
  }

  SyntaxTreeNode _term() {
    var temp = _factor();

    while (_isMulOp(token)) {
      final mulOpToken = token;
      _match(token);
      final newTemp = TermSyntaxTreeNode(
        mulOpToken as OperatorToken,
        temp,
        _factor(),
      );
      temp = newTemp;
    }

    return temp;
  }

  SyntaxTreeNode _factor() {
    final temp = token;

    switch (token.type) {
      case TokenType.LeftParenthesis:
        _match(token);

        final exp = _exp();

        if (token.type == TokenType.RightParenthesis) {
          _match(token);
        } else {
          _error();
        }

        return exp;

      case TokenType.Number:
        _match(token);
        return FactorSyntaxTreeNode(temp as NumberToken);

      case TokenType.Identifier:
        _match(token);
        return FactorSyntaxTreeNode(temp as IdentifierToken);

      default:
        throw Exception("Error parsing token: $token");
    }
  }
}

/************************************
 * Utilities
 ************************************/

/// Checks if a given token is a relational operator.
bool _isRelationalOperator(Token token) {
  return [
    TokenType.Equal,
    TokenType.NotEqual,
    TokenType.GreaterThan,
    TokenType.LessThan,
    TokenType.GreaterEqual,
    TokenType.LessEqual,
  ].contains(token.type);
}

/// Checks if a given token is an addOp (i.e., + or -).
bool _isAddOp(Token token) {
  return [
    TokenType.Plus,
    TokenType.Minus,
  ].contains(token.type);
}

/// Checks if a given token is an mulOp (i.e., * or /).
bool _isMulOp(Token token) {
  return [
    TokenType.Multiply,
    TokenType.Divide,
  ].contains(token.type);
}

extension ReversedDepth on SyntaxTreeNode {
  /// Annotate accounting information
  /// (i.e., dReversedDepth and dDescendentsCount).
  void annotate() {
    for (final child in children) {
      child.annotate();
    }

    dReversedDepth = children.isEmpty
        ? 0
        : children.map<int>((e) => e.dReversedDepth).reduce(max) + 1;

    dDescendentsCount =
        children.map<int>((e) => e.dDescendentsCount).sum + children.length;
  }
}
