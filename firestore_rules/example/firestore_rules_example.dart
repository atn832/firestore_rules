import 'package:antlr4/antlr4.dart';
import 'package:firestore_rules/FirestoreRulesLexer.dart';
import 'package:firestore_rules/FirestoreRulesParser.dart';

class TreeShapeListener implements ParseTreeListener {
  TreeShapeListener(this.ruleNames, this.tokenTypeNames);

  List<String> ruleNames, tokenTypeNames;

  @override
  void enterEveryRule(ParserRuleContext ctx) {
    print('Rule ${ruleNames[ctx.ruleIndex]}: ${ctx.text}');
    for (final child in ctx.children ?? <ParseTree>[]) {
      if (child is! TerminalNode) {
        continue;
      }
      final s = child.symbol;
      // Skip EOF.
      if (s.type < 0) {
        continue;
      }
      print('Token ${tokenTypeNames[s.type - 1]} ${s.text}');
    }
  }

  @override
  void exitEveryRule(ParserRuleContext node) {}

  @override
  void visitErrorNode(ErrorNode node) {}

  @override
  void visitTerminal(TerminalNode node) {}
}

void main(List<String> args) async {
  FirestoreRulesLexer.checkVersion();
  FirestoreRulesParser.checkVersion();
  final input = await InputStream.fromPath(args[0]);
  final lexer = FirestoreRulesLexer(input);
  final tokens = CommonTokenStream(lexer);
  final parser = FirestoreRulesParser(tokens);
  parser.addErrorListener(DiagnosticErrorListener());
  parser.buildParseTree = true;
  final tree = parser.rulesDefinition();
  ParseTreeWalker.DEFAULT
      .walk(TreeShapeListener(parser.ruleNames, lexer.ruleNames), tree);
}
