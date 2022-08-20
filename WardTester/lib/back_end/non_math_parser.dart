import 'math_function.dart';

String nonMathParser(String equationString) {
  String equation = equationString.substring(2, equationString.length);

  //name of equation
  String name = equation.substring(0, equation.indexOf('('));

  //parameter of equation
  String parameter =
      equation.substring(equation.indexOf('('), equation.indexOf(')'));
  List<String> paraList = parameter.split(',');

  if (name == "binaryToHexadecimal") {
    return binaryToHex(int.parse(paraList[0]));
  } else if (name == "binaryToDecimal") {
    // return binaryToDecimal(int.
  } else if (name == "decimalToDecimal") {
  } else if (name == "decimalToHexadecimal") {
  } else if (name == "hexadecimalToDecimal") {
  } else if (name == "hexadecimalToBinary") {
  } else if (name == "subString") {
  } else if (name == "indexOf") {}

  return '0';
}
