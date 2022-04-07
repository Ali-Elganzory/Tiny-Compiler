import '/Models/token.dart';

/// Syntax tree node model.
abstract class SyntaxTreeNode {
  Token get token;
  List<SyntaxTreeNode> get children;
  String get dName;
  int dReversedDepth = 0;

  bool get isLeaf => children.isEmpty;
}

class StmtSequanceSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode stmt;
  final SyntaxTreeNode nextStmtSequance;

  StmtSequanceSyntaxTreeNode(
    this.token,
    this.stmt,
    this.nextStmtSequance,
  );

  @override
  final SingleSymbolToken token;
  @override
  List<SyntaxTreeNode> get children => [stmt, nextStmtSequance];

  @override
  String get dName => "Statement Sequance";
}

class IfStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode testExp;
  final SyntaxTreeNode thenBody;
  final SyntaxTreeNode? elseBody;

  IfStmtSyntaxTreeNode(
    this.token,
    this.testExp,
    this.thenBody,
    this.elseBody,
  );

  @override
  final KeywordToken token;
  @override
  List<SyntaxTreeNode> get children =>
      [testExp, thenBody, if (elseBody != null) elseBody!];

  @override
  String get dName => "If";
}

class RepeatStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode body;
  final SyntaxTreeNode untilExp;

  RepeatStmtSyntaxTreeNode(
    this.token,
    this.body,
    this.untilExp,
  );

  @override
  final KeywordToken token;
  @override
  List<SyntaxTreeNode> get children => [body, untilExp];

  @override
  String get dName => "Repeat";
}

class AssignStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftHandSide;
  final SyntaxTreeNode rightHandSide;

  AssignStmtSyntaxTreeNode(
    this.token,
    this.leftHandSide,
    this.rightHandSide,
  );

  @override
  final OperatorToken token;
  @override
  List<SyntaxTreeNode> get children => [leftHandSide, rightHandSide];

  @override
  String get dName => "Assignment";
}

class ReadStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode identifier;

  ReadStmtSyntaxTreeNode(
    this.token,
    this.identifier,
  );

  @override
  final KeywordToken token;
  @override
  List<SyntaxTreeNode> get children => [identifier];

  @override
  String get dName => "Read";
}

class WriteStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode exp;

  WriteStmtSyntaxTreeNode(
    this.token,
    this.exp,
  );

  @override
  final KeywordToken token;
  @override
  List<SyntaxTreeNode> get children => [exp];

  @override
  String get dName => "Write";
}

class ExpSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftOperand;
  final SyntaxTreeNode rightOperand;

  ExpSyntaxTreeNode(
    this.token,
    this.leftOperand,
    this.rightOperand,
  );

  @override
  final OperatorToken token;
  @override
  List<SyntaxTreeNode> get children => [
        leftOperand,
        rightOperand,
      ];

  @override
  String get dName => "Expression";
}

class SimpleExpSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftOperand;
  final SyntaxTreeNode rightOperand;

  SimpleExpSyntaxTreeNode(
    this.token,
    this.leftOperand,
    this.rightOperand,
  );

  @override
  final OperatorToken token;
  @override
  List<SyntaxTreeNode> get children => [
        leftOperand,
        rightOperand,
      ];

  @override
  String get dName => "Simple Expression";
}

class TermSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftOperand;
  final SyntaxTreeNode rightOperand;

  TermSyntaxTreeNode(
    this.token,
    this.leftOperand,
    this.rightOperand,
  );

  @override
  final OperatorToken token;
  @override
  List<SyntaxTreeNode> get children => [
        leftOperand,
        rightOperand,
      ];

  @override
  String get dName => "Term";
}

class FactorSyntaxTreeNode extends SyntaxTreeNode {
  FactorSyntaxTreeNode(
    this.token,
  );

  @override
  final Token token;
  @override
  List<SyntaxTreeNode> get children => [];

  @override
  String get dName => "Factor";
}
