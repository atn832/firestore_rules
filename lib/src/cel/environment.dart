import 'package:cel/src/cel/options.dart';
import '../checker/declaration.dart';
import '../parser/parser.dart';
import 'ast.dart';

class Environment {
  Environment({List<EnvironmentOption> environmentOptions = const []}) {
    configure(environmentOptions);
  }

  final List<Declaration> declarations = [];

  Ast compile(String text) {
    return Ast(Parser().parse(text));
  }

  // https://github.com/google/cel-go/blob/9e14003d8a7a856b250c5e6514647dee7d4fd9a2/cel/env.go#L472
  void configure(List<EnvironmentOption> environmentOptions) {
    for (final option in environmentOptions) {
      option(this);
    }
  }
}
