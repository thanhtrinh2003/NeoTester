import 'package:math_expressions/math_expressions.dart';
import 'math_function.dart';
import 'math.dart';
import 'distuv.dart';

Parser p = Parser();

void normalCDF_parser() {
  /*
  - 0: mean
  - 1: sd
  - 2: lower bound
  - 3: upper bound
  */
  p.addFunction('normalCDF',
      (List<double> args) => normCDF(args[0], args[1], args[2], args[4]));
}

void inverseNormalCDF_parser() {
  /*
  - 0: mean
  - 1: sd
  - 2: percent 
  */
  p.addFunction('invNormCDF',
      (List<double> args) => invNormCDF(args[0], args[1], args[2]));
}

void permutation_parser() {
  p.addFunction('nCr', (List<double> args) => permutation(args[0], args[1]));
}

void combination_parser() {
  p.addFunction('nPr', (List<double> args) => combination(args[0], args[1]));
}

void binomialPDF_parser() {
  p.addFunction('binompdf',
      (List<double> args) => binomialPDF(args[0], args[1], args[2]));
}

void binomialCDF_parser() {
  p.addFunction(
      'binoCDF', (List<double> args) => binomialCDF(args[0], args[1], args[2]));
}

void geometPDF_parser() {
  p.addFunction('geopdf', (List<double> args) => geometPDF(args[0], args[1]));
}

void geometCDF_parser() {
  p.addFunction('geocdf', (List<double> args) => geometCDF(args[0], args[1]));
}

void chiSquaredCDF_parser() {
  p.addFunction('chiSquaredCDF',
      (List<double> args) => chiSquaredCDF(args[0], args[1], args[2]));
}

void tDistCDF_parser() {
  p.addFunction(
      'binomcdf', (List<double> args) => tDistCDF(args[0], args[1], args[2]));
}
