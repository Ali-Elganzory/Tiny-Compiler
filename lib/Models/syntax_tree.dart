import '/Models/token.dart';

/// Syntax tree node model.
abstract class SyntaxTreeNode {
  Token get token;
  List<SyntaxTreeNode> get children;
  String get debugName;

  const SyntaxTreeNode();
}

class StmtSequanceSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode stmt;
  final SyntaxTreeNode nextStmtSequance;

  const StmtSequanceSyntaxTreeNode(
    this.token,
    this.stmt,
    this.nextStmtSequance,
  );

  @override
  final SingleSymbolToken token;
  @override
  List<SyntaxTreeNode> get children => [stmt, nextStmtSequance];

  @override
  String get debugName => "Statement Sequance";
}

class IfStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode testExp;
  final SyntaxTreeNode thenBody;
  final SyntaxTreeNode? elseBody;

  const IfStmtSyntaxTreeNode(
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
  String get debugName => "If";
}

class RepeatStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode body;
  final SyntaxTreeNode untilExp;

  const RepeatStmtSyntaxTreeNode(
    this.token,
    this.body,
    this.untilExp,
  );

  @override
  final KeywordToken token;
  @override
  List<SyntaxTreeNode> get children => [body, untilExp];

  @override
  String get debugName => "Repeat";
}

class AssignStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftHandSide;
  final SyntaxTreeNode rightHandSide;

  const AssignStmtSyntaxTreeNode(
    this.token,
    this.leftHandSide,
    this.rightHandSide,
  );

  @override
  final OperatorToken token;
  @override
  List<SyntaxTreeNode> get children => [leftHandSide, rightHandSide];

  @override
  String get debugName => "Assignment";
}

class ReadStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode identifier;

  const ReadStmtSyntaxTreeNode(
    this.token,
    this.identifier,
  );

  @override
  final KeywordToken token;
  @override
  List<SyntaxTreeNode> get children => [identifier];

  @override
  String get debugName => "Read";
}

class WriteStmtSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode exp;

  const WriteStmtSyntaxTreeNode(
    this.token,
    this.exp,
  );

  @override
  final KeywordToken token;
  @override
  List<SyntaxTreeNode> get children => [exp];

  @override
  String get debugName => "Write";
}

class ExpSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftOperand;
  final SyntaxTreeNode rightOperand;

  const ExpSyntaxTreeNode(
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
  String get debugName => "Expression";
}

class SimpleExpSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftOperand;
  final SyntaxTreeNode rightOperand;

  const SimpleExpSyntaxTreeNode(
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
  String get debugName => "Simple Expression";
}

class TermSyntaxTreeNode extends SyntaxTreeNode {
  final SyntaxTreeNode leftOperand;
  final SyntaxTreeNode rightOperand;

  const TermSyntaxTreeNode(
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
  String get debugName => "Term";
}

class FactorSyntaxTreeNode extends SyntaxTreeNode {
  const FactorSyntaxTreeNode(
    this.token,
  );

  @override
  final Token token;
  @override
  List<SyntaxTreeNode> get children => [];

  @override
  String get debugName => "Factor";
}
