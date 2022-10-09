import 'math_function.dart';

String nonMathParser(String equationString) {
  print(equationString);
  String equation = equationString.substring(2, equationString.length);
  print(equation);
  //name of equation
  String name = equation.substring(0, equation.indexOf('('));
  print(name);
  //parameter of equation
  String parameter =
      equation.substring(equation.indexOf('(') + 1, equation.indexOf(')'));
  List<String> paraList = parameter.split(',');
  print(parameter);
  print(paraList);

  if (name == "binaryToHexadecimal") {
    return binaryToHex(int.parse(paraList[0]));
  } else if (name == "binaryToDecimal") {
    return binaryToDecimal(int.parse(paraList[0])).toString();
  } else if (name == "decimalToBinary") {
    return decimalToBinary(int.parse(paraList[0])).toString();
  } else if (name == "decimalToHexadecimal") {
    return decimalToHex(int.parse(paraList[0])).toString();
  } else if (name == "hexadecimalToDecimal") {
    return hexToDecimal(paraList[0]).toString();
  } else if (name == "hexadecimalToBinary") {
    return hexToBinary(paraList[0]).toString();
  } else if (name == "substring") {
    if (paraList.length == 3) {
      return paraList[0]
          .substring(int.parse(paraList[1]), int.parse(paraList[2]));
    } else {
      return paraList[0].substring(int.parse(paraList[1]));
    }
  } else if (name == "indexOf") {
    return paraList[0].indexOf(paraList[1]).toString();
  } else if (name == "charAt") {
    return paraList[0][int.parse(paraList[1])];
  }
  return "null function";
}
