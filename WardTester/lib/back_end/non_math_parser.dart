double nonMathParser(String equationString) {
  String equation = equationString.substring(2, equationString.length);

  //name of equation
  String name = equation.substring(0, equation.indexOf('('));

  //parameter of equation
  String parameter =
      equation.substring(equation.indexOf('('), equation.indexOf(')'));
  List<String> paraList = parameter.split(',');

  if (name == "hexical") {
    int hexicalNum = 1;
  }

  return 0;
}
