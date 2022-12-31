import 'package:math_expressions/math_expressions.dart';
import 'math_function.dart';
import 'dart:math';

Parser mathParser = Parser();

void normalCDF_parser() {
  mathParser.addFunction('normCDF',
      (List<double> args) => normCDF(args[0], args[1], args[2], args[3]));
}

void inverseNormalCDF_parser() {
  mathParser.addFunction(
      'invNorm', (List<double> args) => invNormCDF(args[0], args[1], args[2]));
}

void inverseTCDF_parser() {
  mathParser.addFunction('invT', (List<double> args) => invT(args[0], args[1]));
}

void tDistCDF_parser() {
  mathParser.addFunction(
      'tcdf', (List<double> args) => tDistCDF(args[0], args[1], args[2]));
}

void chiSquaredCDF_parser() {
  mathParser.addFunction('chicdf',
      (List<double> args) => chiSquaredCDF(args[0], args[1], args[2]));
}

void binomialPDF_parser() {
  mathParser.addFunction(
      'binPDF', (List<double> args) => binomialPDF(args[0], args[1], args[2]));
}

void binomialCDF_parser() {
  mathParser.addFunction('binCDF',
      (List<double> args) => binomialCDF(args[0], args[1], args[2], args[3]));
}

void geometPDF_parser() {
  mathParser.addFunction(
      'geomPDF', (List<double> args) => geomPDF(args[0], args[1]));
}

void geometCDF_parser() {
  mathParser.addFunction(
      'geomCDF', (List<double> args) => geomCDF(args[0], args[1], args[2]));
}

void median_parser() {
  mathParser.addFunction('median', (List<double> args) => median(args));
}

void stddev_parser() {
  mathParser.addFunction('stddev', (List<double> args) => stddev(args));
}

void average_parser() {
  mathParser.addFunction('average', (List<double> args) => average(args));
}

void permutation_parser() {
  mathParser.addFunction(
      'nCr', (List<double> args) => permutation(args[0], args[1]));
}

void combination_parser() {
  mathParser.addFunction(
      'nPr', (List<double> args) => combination(args[0], args[1]));
}

void min_parser() {
  mathParser.addFunction('min', (List<double> args) => min(args));
}

void max_parser() {
  mathParser.addFunction('max', (List<double> args) => max(args));
}

void floor_parser() {
  mathParser.addFunction('floor', (List<double> args) => floor(args[0]));
}

void ceil_parser() {
  mathParser.addFunction('ceil', (List<double> args) => ceil(args[0]));
}

void gcf_parser() {
  mathParser.addFunction(
      'gcf', (List<double> args) => gcf(args[0].toInt(), args[1].toInt()));
}

void lcm_parser() {
  mathParser.addFunction(
      'lcm', (List<double> args) => gcf(args[0].toInt(), args[1].toInt()));
}

void abs_parser() {
  mathParser.addFunction('abs', (List<double> args) => abs(args[0]));
}

void sum_parser() {
  mathParser.addFunction('sum', (List<double> args) => sum(args));
}

void count_parser() {
  mathParser.addFunction('count', (List<double> args) => args.length);
}

void nthroot_parser() {
  mathParser.addFunction(
      'nthroot', (List<double> args) => nthroot(args[0], args[1]));
}

void pi_parser() {
  mathParser.addFunction('pi', (List<double> args) => pi);
}

void e_parser() {
  mathParser.addFunction('e', (List<double> args) => e);
}

void power_parser() {
  mathParser.addFunction('pow', (List<double> args) => pow(args[0], args[1]));
}
